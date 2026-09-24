-- ============================================================
-- Agenda a atualização automática do clima e da previsão,
-- para não precisar mais chamar as Edge Functions manualmente.
-- ============================================================
--
-- ⚠️ ANTES DE EXECUTAR: troque "SEU_PROJECT_REF" abaixo pela
-- referência do seu projeto (o pedaço antes de ".supabase.co"
-- na URL do seu projeto, ex: "abcdefghijklmnop").
--
-- Essas duas Edge Functions estão com "verify_jwt = false" no
-- config.toml, então não é necessário enviar Authorization/apikey
-- para chamá-las.

-- 1. Habilita as extensões necessárias para agendar tarefas e
--    fazer chamadas HTTP de dentro do Postgres.
create extension if not exists pg_cron;
create extension if not exists pg_net;

-- 2. Remove agendamentos antigos com o mesmo nome (permite rodar
--    esta migration de novo sem duplicar jobs).
select cron.unschedule(jobid)
from cron.job
where jobname in ('atualizar-clima-diario', 'atualizar-previsao-diaria');

-- 3. Atualiza o clima do dia (temperatura, umidade, vento, condição
--    atual) todos os dias às 06:00 (horário de Brasília = 09:00 UTC).
select cron.schedule(
  'atualizar-clima-diario',
  '0 9 * * *', -- 09:00 UTC = 06:00 em America/Sao_Paulo
  $$
  select net.http_post(
    url := 'https://https://lqrelxniitrfhdcpbvwu.supabase.co/functions/v1/atualizar-clima',
    headers := '{"Content-Type": "application/json"}'::jsonb
  );
  $$
);

-- 4. Atualiza a previsão dos próximos dias, também às 06:00 local.
select cron.schedule(
  'atualizar-previsao-diaria',
  '5 9 * * *', -- 09:05 UTC = 06:05 em America/Sao_Paulo (5 min depois, evita concorrência)
  $$
  select net.http_post(
    url := 'https://SEU_PROJECT_REF.supabase.co/functions/v1/atualizar-previsao',
    headers := '{"Content-Type": "application/json"}'::jsonb
  );
  $$
);

-- Para conferir se os jobs foram criados:
-- select * from cron.job;

-- Para ver o histórico de execuções (sucesso/erro):
-- select * from cron.job_run_details order by start_time desc limit 20;
