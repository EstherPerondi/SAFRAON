import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const OPENWEATHER_API_KEY = Deno.env.get("OPENWEATHER_API_KEY")!;

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

// Converte um instante (UTC) para a data (YYYY-MM-DD) no horário de
// Brasília. O forecast da OpenWeather vem em blocos de 3h em UTC; sem essa
// conversão, os blocos das ~21h-23h59 locais "vazam" para o dia seguinte
// (ou o contrário), agrupando a previsão no dia errado.
function dataLocalISO(instante: Date): string {
  return new Intl.DateTimeFormat("en-CA", {
    timeZone: "America/Sao_Paulo",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  }).format(instante);
}

// Hora (0-23) do instante, já no horário de Brasília.
function horaLocal(instante: Date): number {
  return Number(
    new Intl.DateTimeFormat("en-GB", {
      timeZone: "America/Sao_Paulo",
      hour: "2-digit",
      hour12: false,
    }).format(instante),
  );
}

Deno.serve(async (_req) => {
  try {
    // 1. Busca todos os talhões que já têm coordenadas cadastradas
    const { data: talhoes, error: talhoesError } = await supabase
      .from("talhao")
      .select("id, latitude, longitude")
      .not("latitude", "is", null)
      .not("longitude", "is", null);

    if (talhoesError) throw talhoesError;
    if (!talhoes || talhoes.length === 0) {
      return new Response(
        JSON.stringify({ message: "Nenhum talhão com lat/lon cadastrado." }),
        { status: 200 },
      );
    }

    // Hoje (para não gravar previsão de um dia que já passou), no horário local
    const hojeISO = dataLocalISO(new Date());

    const resultados = [];

    for (const talhao of talhoes) {
      try {
        const url =
          `https://api.openweathermap.org/data/2.5/forecast` +
          `?lat=${talhao.latitude}&lon=${talhao.longitude}` +
          `&units=metric&lang=pt_br&appid=${OPENWEATHER_API_KEY}`;

        const resp = await fetch(url);
        if (!resp.ok) {
          const errText = await resp.text();
          throw new Error(`OpenWeather (forecast) retornou ${resp.status}: ${errText}`);
        }

        const previsao = await resp.json();
        const lista = previsao.list ?? [];
        if (lista.length === 0) throw new Error("Resposta de forecast vazia");

        // 2. Agrupa as entradas de 3 em 3 horas por dia (data)
        // deno-lint-ignore no-explicit-any
        const porDia = new Map<string, any[]>();
        for (const entrada of lista) {
          const instante = new Date(entrada.dt * 1000);
          const data = dataLocalISO(instante); // "YYYY-MM-DD" no horário local
          if (data < hojeISO) continue; // ignora qualquer coisa no passado
          if (!porDia.has(data)) porDia.set(data, []);
          porDia.get(data)!.push(entrada);
        }

        let diasSalvos = 0;

        for (const [data, entradas] of porDia) {
          if (data === hojeISO) continue; // só interessa a previsão dos PRÓXIMOS dias

          const temps = entradas.map((e) => e.main?.temp).filter((t: number) => t != null);
          const temperatura_min = Math.min(...temps);
          const temperatura_max = Math.max(...temps);

          // Usa a condição do horário mais próximo do meio-dia (local) como representativa do dia
          const entradaDoMeioDia = entradas.reduce((melhor: any, atual: any) => {
            const horaAtual = horaLocal(new Date(atual.dt * 1000));
            const horaMelhor = horaLocal(new Date(melhor.dt * 1000));
            return Math.abs(horaAtual - 12) < Math.abs(horaMelhor - 12) ? atual : melhor;
          }, entradas[0]);
          const weather = entradaDoMeioDia.weather?.[0];

          // 3. Garante que a condição climática existe (mesma tabela usada pelo clima atual)
          let condicaoId: string | null = null;
          if (weather) {
            const { data: condicaoExistente } = await supabase
              .from("condicao_climatica_previsao")
              .select("id")
              .eq("codigo_api", weather.id)
              .maybeSingle();

            if (condicaoExistente) {
              condicaoId = condicaoExistente.id;
            } else {
              const { data: novaCondicao, error: condicaoError } = await supabase
                .from("condicao_climatica_previsao")
                .insert({ codigo_api: weather.id, nome: weather.main })
                .select("id")
                .single();
              if (condicaoError) throw condicaoError;
              condicaoId = novaCondicao.id;
            }
          }

          // 4. Upsert em previsao_clima
          const { error: previsaoError } = await supabase
            .from("previsao_clima")
            .upsert(
              {
                talhao_id: talhao.id,
                data,
                temperatura_min,
                temperatura_max,
                condicao_climatica_id: condicaoId,
              },
              { onConflict: "talhao_id,data" },
            );
          if (previsaoError) throw previsaoError;
          diasSalvos++;
        }

        resultados.push({ talhao_id: talhao.id, status: "ok", dias_salvos: diasSalvos });
      } catch (err) {
        const detalhe = err instanceof Error
          ? err.message
          : JSON.stringify(err, Object.getOwnPropertyNames(err ?? {}));
        resultados.push({ talhao_id: talhao.id, status: "erro", detalhe });
      }
    }

    return new Response(JSON.stringify({ resultados }), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  } catch (err) {
    console.error("Erro na function atualizar-previsao:", err);
    const detalhe = err instanceof Error
      ? err.message
      : JSON.stringify(err, Object.getOwnPropertyNames(err ?? {}));
    return new Response(JSON.stringify({ erro: detalhe }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }
});