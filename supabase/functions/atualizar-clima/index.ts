import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// Variáveis injetadas automaticamente pela Supabase em toda Edge Function
const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
// Secret que você configurou com: supabase secrets set OPENWEATHER_API_KEY=...
const OPENWEATHER_API_KEY = Deno.env.get("OPENWEATHER_API_KEY")!;

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

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

    const resultados = [];

    // 2. Para cada talhão, busca o clima do dia e grava no banco
    for (const talhao of talhoes) {
      try {
       const url =
        `https://api.openweathermap.org/data/2.5/weather` +
        `?lat=${talhao.latitude}&lon=${talhao.longitude}` +
        `&units=metric&lang=pt_br&appid=${OPENWEATHER_API_KEY}`;

        const resp = await fetch(url);
        if (!resp.ok) {
          const errText = await resp.text();
          throw new Error(`OpenWeather retornou ${resp.status}: ${errText}`);
        }

        const dia = await resp.json();
        if (!dia.main || !dia.weather) throw new Error("Resposta da API incompleta");

        const dataISO = new Date(dia.dt * 1000).toISOString().slice(0, 10);
        const weather = dia.weather?.[0];

        // 3. Garante que a condição climática existe (busca por codigo_api, senão cria)
        let condicaoId: string;
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
            .insert({
              codigo_api: weather.id,
              nome: weather.main,
            })
            .select("id")
            .single();
          if (condicaoError) throw condicaoError;
          condicaoId = novaCondicao.id;
        }

        // 4. Upsert em clima_dia (não duplica se já rodou hoje pra esse talhão)
        const precipitacao = (dia.rain?.["1h"] ?? 0) + (dia.snow?.["1h"] ?? 0);
        const { error: climaError } = await supabase
          .from("clima_dia")
          .upsert(
            {
              talhao_id: talhao.id,
              condicao_climatica_id: condicaoId,
              data: dataISO,
              fonte: "openweathermap",
              precipitacao_dia: precipitacao,
            },
            { onConflict: "talhao_id,data" },
          );
        if (climaError) throw climaError;

        // 5. Upsert em metricas_dia
        const { error: metricasError } = await supabase
          .from("metricas_dia")
          .upsert(
            {
              talhao_id: talhao.id,
              data: dataISO,
              temperatura_min: dia.temp?.min,
              temperatura_max: dia.temp?.max,
              umidade_media: dia.humidity,
            },
            { onConflict: "talhao_id,data" },
          );
        if (metricasError) throw metricasError;

        resultados.push({ talhao_id: talhao.id, status: "ok" });
      }  catch (err) {
        // Um talhão com erro não deve travar os outros
        const detalhe = err instanceof Error
          ? err.message
          : JSON.stringify(err, Object.getOwnPropertyNames(err ?? {}));
        resultados.push({
          talhao_id: talhao.id,
          status: "erro",
          detalhe,
        });
      }
    }

    return new Response(JSON.stringify({ resultados }), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  } catch (err) {
    console.error("Erro na function atualizar-clima:", err);
    const detalhe = err instanceof Error
      ? err.message
      : JSON.stringify(err, Object.getOwnPropertyNames(err ?? {}));
    return new Response(JSON.stringify({ erro: detalhe }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }
});