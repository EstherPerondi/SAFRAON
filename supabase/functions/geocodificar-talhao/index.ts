import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const OPENWEATHER_API_KEY = Deno.env.get("OPENWEATHER_API_KEY")!;

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

Deno.serve(async (req) => {
  try {
    // 1. Recebe o id do talhão que precisa ser geocodificado
    const { talhao_id } = await req.json();
    if (!talhao_id) {
      return new Response(
        JSON.stringify({ erro: "talhao_id é obrigatório no corpo da requisição" }),
        { status: 400, headers: { "Content-Type": "application/json" } },
      );
    }

    // 2. Busca a cidade do talhão + sigla do estado (via fazenda)
    const { data: talhao, error: talhaoError } = await supabase
      .from("talhao")
      .select("id, cidade, fazenda_id, fazenda:fazenda_id (estado_id, estados:estado_id (sigla))")
      .eq("id", talhao_id)
      .single();

    if (talhaoError) throw talhaoError;
    if (!talhao) {
      return new Response(JSON.stringify({ erro: "Talhão não encontrado" }), {
        status: 404,
        headers: { "Content-Type": "application/json" },
      });
    }
    if (!talhao.cidade) {
      return new Response(
        JSON.stringify({ erro: "Talhão não tem cidade cadastrada" }),
        { status: 422, headers: { "Content-Type": "application/json" } },
      );
    }

    // deno-lint-ignore no-explicit-any
    const sigla = (talhao as any).fazenda?.estados?.sigla;
    if (!sigla) {
      return new Response(
        JSON.stringify({ erro: "Não foi possível determinar o estado do talhão" }),
        { status: 422, headers: { "Content-Type": "application/json" } },
      );
    }

    // 3. Chama o Geocoding API (gratuito, sem necessidade de assinatura)
    const query = encodeURIComponent(`${talhao.cidade},${sigla},BR`);
    const url =
      `https://api.openweathermap.org/geo/1.0/direct?q=${query}&limit=1&appid=${OPENWEATHER_API_KEY}`;

    const resp = await fetch(url);
    if (!resp.ok) {
      const errText = await resp.text();
      throw new Error(`OpenWeather Geocoding retornou ${resp.status}: ${errText}`);
    }

    const resultados = await resp.json();
    if (!resultados || resultados.length === 0) {
      return new Response(
        JSON.stringify({
          erro: `Cidade "${talhao.cidade}, ${sigla}" não encontrada pela API de geocoding`,
        }),
        { status: 404, headers: { "Content-Type": "application/json" } },
      );
    }

    const { lat, lon, name } = resultados[0];

    // 4. Atualiza o talhão com as coordenadas encontradas
    const { error: updateError } = await supabase
      .from("talhao")
      .update({ latitude: lat, longitude: lon })
      .eq("id", talhao_id);

    if (updateError) throw updateError;

    return new Response(
      JSON.stringify({
        talhao_id,
        cidade_encontrada: name,
        latitude: lat,
        longitude: lon,
        status: "ok",
      }),
      { status: 200, headers: { "Content-Type": "application/json" } },
    );
  } catch (err) {
    console.error("Erro na function geocodificar-talhao:", err);
    const detalhe = err instanceof Error
      ? err.message
      : JSON.stringify(err, Object.getOwnPropertyNames(err ?? {}));
    return new Response(JSON.stringify({ erro: detalhe }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }
});