// lib/widgets/seletor_local.dart
//
// Seletor de "Fazenda" + "Talhão" usado nos formulários de aplicação,
// plantio, colheita, manejo e precipitação.
//
// As tabelas aplicacao/plantio/colheita/manejo/clima_dia só têm
// talhao_id (a fazenda é descoberta pelo talhão). Por isso, quando o
// formulário é aberto pelo menu principal (sem talhão definido), o
// usuário precisa escolher primeiro a fazenda e depois o talhão.
//
// Modos:
//  - talhaoIdFixo != null  -> veio da tela de um talhão: só mostra
//    "Fazenda • Talhão" (somente leitura) e devolve esse id.
//  - talhaoIdInicial != null -> edição de um registro: já vem com a
//    fazenda e o talhão do registro selecionados (pode trocar).
//  - nenhum dos dois -> escolha livre (se houver só uma fazenda / um
//    talhão, já vem selecionado).
import 'package:flutter/material.dart';
import '../models/fazenda_model.dart';
import '../models/talhao_model.dart';
import '../services/fazenda_service.dart';
import '../services/supabase_service.dart';
import '../services/talhao_service.dart';
import '../variaveis.dart';

class SeletorFazendaTalhao extends StatefulWidget {
  final String? talhaoIdFixo;
  final String? talhaoIdInicial;
  final ValueChanged<String?> onChanged;

  const SeletorFazendaTalhao({
    super.key,
    this.talhaoIdFixo,
    this.talhaoIdInicial,
    required this.onChanged,
  });

  @override
  State<SeletorFazendaTalhao> createState() => _SeletorFazendaTalhaoState();
}

class _SeletorFazendaTalhaoState extends State<SeletorFazendaTalhao> {
  List<FazendaModel> _fazendas = [];
  List<TalhaoModel> _talhoes = [];
  String? _fazendaId;
  String? _talhaoId;
  bool _carregando = true;
  bool _carregandoTalhoes = false;

  bool get _fixo =>
      widget.talhaoIdFixo != null && widget.talhaoIdFixo!.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _carregarInicial();
  }

  String? _vazioParaNulo(String? v) => (v == null || v.isEmpty) ? null : v;

  Future<void> _carregarInicial() async {
    try {
      final todas = await FazendaService().getAll();
      final userId = SupabaseService().currentUserId;
      // Só as fazendas do usuário logado
      final fazendas = userId.isEmpty
          ? todas
          : todas.where((f) => f.userId == userId).toList();

      final idInicial = _vazioParaNulo(
        _fixo ? widget.talhaoIdFixo : widget.talhaoIdInicial,
      );

      String? fazendaId;
      String? talhaoId;
      List<TalhaoModel> talhoes = [];

      if (idInicial != null) {
        final talhao = await TalhaoService().getById(idInicial);
        if (talhao != null) {
          fazendaId = talhao.fazendaId;
          talhaoId = talhao.id;
          talhoes = await TalhaoService().getByFazenda(talhao.fazendaId);
        }
      } else if (fazendas.length == 1) {
        // Só uma fazenda: já seleciona
        fazendaId = fazendas.first.id;
        talhoes = await TalhaoService().getByFazenda(fazendaId);
        if (talhoes.length == 1) talhaoId = talhoes.first.id;
      }

      if (!mounted) return;
      setState(() {
        _fazendas = fazendas;
        _talhoes = talhoes;
        _fazendaId = fazendaId;
        _talhaoId = talhaoId;
        _carregando = false;
      });
      widget.onChanged(_fixo ? widget.talhaoIdFixo : _talhaoId);
    } catch (e) {
      if (!mounted) return;
      setState(() => _carregando = false);
      widget.onChanged(_fixo ? widget.talhaoIdFixo : null);
    }
  }

  Future<void> _aoTrocarFazenda(String? fazendaId) async {
    setState(() {
      _fazendaId = fazendaId;
      _talhaoId = null;
      _talhoes = [];
      _carregandoTalhoes = fazendaId != null;
    });
    widget.onChanged(null);
    if (fazendaId == null) return;

    final talhoes = await TalhaoService().getByFazenda(fazendaId);
    if (!mounted || _fazendaId != fazendaId) return;
    setState(() {
      _talhoes = talhoes;
      _carregandoTalhoes = false;
      if (talhoes.length == 1) _talhaoId = talhoes.first.id;
    });
    widget.onChanged(_talhaoId);
  }

  void _aoTrocarTalhao(String? talhaoId) {
    setState(() => _talhaoId = talhaoId);
    widget.onChanged(talhaoId);
  }

  InputDecoration _decoracao(String label, IconData icon, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(color: VerdeClaro, fontWeight: FontWeight.w600),
      prefixIcon: Icon(icon, color: VerdeClaro),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(16),
    );
  }

  Widget _caixa({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: LinearProgressIndicator(
          color: VerdeEscuro,
          backgroundColor: VerdeClaro.withOpacity(0.15),
        ),
      );
    }

    // ---- Modo fixo: veio da tela de um talhão ----
    if (_fixo) {
      final fazenda = _fazendas.where((f) => f.id == _fazendaId);
      final talhao = _talhoes.where((t) => t.id == _talhaoId);
      final texto = [
        if (fazenda.isNotEmpty) fazenda.first.nome,
        if (talhao.isNotEmpty) talhao.first.nome,
      ].join(' • ');

      return _caixa(
        child: InputDecorator(
          decoration: _decoracao('Fazenda • Talhão', Icons.location_on),
          child: Text(
            texto.isNotEmpty ? texto : 'Talhão selecionado',
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      );
    }

    // ---- Sem nenhuma fazenda cadastrada ----
    if (_fazendas.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.orange[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.orange.shade700),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Cadastre uma fazenda e um talhão antes de adicionar registros.',
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ),
          ],
        ),
      );
    }

    // ---- Escolha de fazenda + talhão ----
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _caixa(
          child: DropdownButtonFormField<String>(
            value: _fazendas.any((f) => f.id == _fazendaId) ? _fazendaId : null,
            isExpanded: true,
            decoration: _decoracao('Fazenda', Icons.landscape),
            items: _fazendas
                .map((f) => DropdownMenuItem(
                      value: f.id,
                      child: Text(f.nome, overflow: TextOverflow.ellipsis),
                    ))
                .toList(),
            onChanged: _aoTrocarFazenda,
            validator: (v) =>
                v == null || v.isEmpty ? 'Selecione a fazenda' : null,
          ),
        ),
        const SizedBox(height: 16),
        _caixa(
          child: DropdownButtonFormField<String>(
            // muda a key quando a fazenda muda, para limpar a seleção anterior
            key: ValueKey('talhao-$_fazendaId-${_talhoes.length}'),
            value: _talhoes.any((t) => t.id == _talhaoId) ? _talhaoId : null,
            isExpanded: true,
            decoration: _decoracao(
              'Talhão',
              Icons.grid_view,
              hint: _fazendaId == null
                  ? 'Escolha a fazenda primeiro'
                  : _carregandoTalhoes
                      ? 'Carregando talhões...'
                      : _talhoes.isEmpty
                          ? 'Nenhum talhão nesta fazenda'
                          : 'Selecione o talhão',
            ),
            items: _talhoes
                .map((t) => DropdownMenuItem(
                      value: t.id,
                      child: Text(t.nome, overflow: TextOverflow.ellipsis),
                    ))
                .toList(),
            onChanged: (_fazendaId == null || _talhoes.isEmpty)
                ? null
                : _aoTrocarTalhao,
            validator: (v) =>
                v == null || v.isEmpty ? 'Selecione o talhão' : null,
          ),
        ),
      ],
    );
  }
}
