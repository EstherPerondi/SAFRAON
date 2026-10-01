// lib/powersync/schema.dart
//
// Schema LOCAL (SQLite). A coluna "id" (texto/uuid) é implícita em toda
// tabela do PowerSync, então não é declarada aqui.
// Datas ficam como texto ISO-8601; números como real.
import 'package:powersync/powersync.dart';

const _porTalhao = 'talhao_id';

final schema = Schema([
  // ---------- Lookups (globais) ----------
  Table('estados', [Column.text('nome')]),
  Table('cultura', [Column.text('plantacultivada')]),
  Table(
    'variedade',
    [
      Column.text('nomedavariedade'),
      Column.text('cultura_id'),
      Column.text('fabricante'),
    ],
    indexes: [
      Index('por_cultura', [IndexedColumn('cultura_id')]),
    ],
  ),
  Table('adubo', [Column.text('nomedoadubo'), Column.text('fabricante')]),
  Table('inoculante', [
    Column.text('nomedoinoculante'),
    Column.text('fabricante'),
    Column.real('dosagemrecomendada'),
  ]),
  Table('defensivo', [
    Column.text('nome'),
    Column.text('principioativo'),
    Column.text('fabricante'),
    Column.text('utilidade'),
  ]),
  Table('tipo_manejo', [Column.text('tipo_de_manejo')]),
  Table('condicao_climatica_previsao', [
    Column.text('codigo_api'),
    Column.text('nome'),
  ]),

  // ---------- Dados do usuário ----------
  Table(
    'fazenda',
    [
      Column.text('nome'),
      Column.text('usuario_id'),
      Column.text('estado_id'),
      Column.text('created_at'),
      Column.text('updated_at'),
    ],
    indexes: [
      Index('por_usuario', [IndexedColumn('usuario_id')]),
    ],
  ),
  Table(
    'talhao',
    [
      Column.text('nome'),
      Column.text('cidade'),
      Column.text('fazenda_id'),
      Column.real('latitude'),
      Column.real('longitude'),
      Column.text('created_at'),
      Column.text('updated_at'),
    ],
    indexes: [
      Index('por_fazenda', [IndexedColumn('fazenda_id')]),
    ],
  ),
  Table(
    'plantio',
    [
      Column.text('talhao_id'),
      Column.text('cultura_id'),
      Column.text('variedade_id'),
      Column.text('adubo_id'),
      Column.text('inoculante_id'),
      Column.text('dataplantio'),
      Column.real('quantidadessementespormetro'),
      Column.real('quantidadeaduboporalqueire'),
      Column.text('created_at'),
      Column.text('updated_at'),
    ],
    indexes: [
      Index('por_talhao', [IndexedColumn(_porTalhao)]),
    ],
  ),
  Table(
    'aplicacao',
    [
      Column.text('talhao_id'),
      Column.text('defensivo_id'),
      Column.real('doseporhectare'),
      Column.text('dataaplicacao'),
      Column.text('motivo'),
      Column.text('created_at'),
      Column.text('updated_at'),
    ],
    indexes: [
      Index('por_talhao', [IndexedColumn(_porTalhao)]),
    ],
  ),
  Table(
    'manejo',
    [
      Column.text('talhao_id'),
      Column.text('tipo_manejo_id'),
      Column.text('datadomanejo'),
      Column.text('descricao'),
      Column.text('created_at'),
      Column.text('updated_at'),
    ],
    indexes: [
      Index('por_talhao', [IndexedColumn(_porTalhao)]),
    ],
  ),
  Table(
    'colheita',
    [
      Column.text('talhao_id'),
      Column.text('cultura_id'),
      Column.text('datadacolheita'),
      Column.real('producao'),
      Column.real('umidade'),
      Column.text('created_at'),
      Column.text('updated_at'),
    ],
    indexes: [
      Index('por_talhao', [IndexedColumn(_porTalhao)]),
    ],
  ),

  // ---------- Clima ----------
  // clima_dia recebe linhas manuais (app) e automáticas (Edge Function).
  Table(
    'clima_dia',
    [
      Column.text('talhao_id'),
      Column.text('condicao_climatica_id'),
      Column.text('data'),
      Column.text('fonte'),
      Column.real('precipitacao_dia'),
      Column.text('created_at'),
      Column.text('updated_at'),
    ],
    indexes: [
      Index('por_talhao_data', [IndexedColumn(_porTalhao), IndexedColumn('data')]),
    ],
  ),
  Table(
    'metricas_dia',
    [
      Column.text('talhao_id'),
      Column.text('data'),
      Column.real('temperatura_min'),
      Column.real('temperatura_max'),
      Column.real('umidade_media'),
      Column.real('velocidade_vento'),
    ],
    indexes: [
      Index('por_talhao_data', [IndexedColumn(_porTalhao), IndexedColumn('data')]),
    ],
  ),
  Table(
    'previsao_clima',
    [
      Column.text('talhao_id'),
      Column.text('condicao_climatica_id'),
      Column.text('data'),
      Column.real('temperatura_min'),
      Column.real('temperatura_max'),
    ],
    indexes: [
      Index('por_talhao_data', [IndexedColumn(_porTalhao), IndexedColumn('data')]),
    ],
  ),
]);