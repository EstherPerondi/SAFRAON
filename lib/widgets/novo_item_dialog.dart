// lib/widgets/novo_item_dialog.dart
//
// Diálogo genérico reutilizável para cadastrar rapidamente um novo item
// de uma tabela de lookup (cultura, variedade, adubo, inoculante,
// defensivo, tipo de manejo, estado...) sem precisar sair do formulário
// atual nem mexer no banco manualmente.
//
// Além do nome (sempre obrigatório), o diálogo pode exibir campos extras
// opcionais definidos por CampoExtra, cobrindo as demais colunas
// nullable de cada tabela (fabricante, princípio ativo, utilidade,
// dosagem recomendada etc.), para que o usuário consiga cadastrar todos
// os dados possíveis, não só o nome.
import 'package:flutter/material.dart';
import '../services/lookup_service.dart';
import '../variaveis.dart';

/// Valor sentinela usado como um item a mais dentro das listas de opção
/// dos dropdowns, representando a opção "Adicionar novo...".
const String kAdicionarNovoValor = '__adicionar_novo__';

/// Monta o item de dropdown padrão para a opção "Adicionar novo...",
/// já com o ícone e o estilo usados em todas as telas.
DropdownMenuItem<String> buildAdicionarNovoDropdownItem(String label) {
  return DropdownMenuItem<String>(
    value: kAdicionarNovoValor,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.add_circle_outline, size: 18, color: VerdeEscuro),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            style: TextStyle(color: VerdeEscuro, fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

/// Tipo de entrada de um [CampoExtra].
enum TipoCampoExtra { texto, numero }

/// Descreve um campo opcional adicional (além do nome) que o usuário pode
/// preencher ao cadastrar um novo item — cobre as colunas nullable de
/// cada tabela (fabricante, princípio ativo, utilidade, dosagem
/// recomendada etc.).
class CampoExtra {
  /// Chave usada para identificar o valor preenchido dentro do mapa
  /// [extras] devolvido para o onCriar (ex: 'fabricante').
  final String chave;
  final String label;
  final String? hint;
  final TipoCampoExtra tipo;

  const CampoExtra({
    required this.chave,
    required this.label,
    this.hint,
    this.tipo = TipoCampoExtra.texto,
  });
}

/// Mostra um diálogo para cadastrar um novo item de lookup: o nome
/// (obrigatório) e, opcionalmente, campos extras (todos opcionais).
///
/// - [titulo]: título do diálogo (ex: "Novo Defensivo").
/// - [label]: rótulo do campo de nome (ex: "Nome do defensivo").
/// - [camposExtras]: campos opcionais adicionais (fabricante, etc). Se a
///   tabela não tiver nenhum campo extra, pode ser omitido.
/// - [onCriar]: função que salva o item no banco (via [LookupService]),
///   recebendo o nome e um mapa {chave: valor} com os campos extras que
///   o usuário efetivamente preencheu (campos deixados em branco não
///   entram no mapa).
///
/// Retorna o [LookupItem] recém-criado, ou `null` se o usuário cancelar.
Future<LookupItem?> showNovoItemDialog({
  required BuildContext context,
  required String titulo,
  required String label,
  required Future<LookupItem> Function(
    String nome,
    Map<String, String> extras,
  ) onCriar,
  String? hint,
  List<CampoExtra> camposExtras = const [],
}) {
  return showDialog<LookupItem>(
    context: context,
    barrierDismissible: true,
    builder: (context) => _NovoItemDialog(
      titulo: titulo,
      label: label,
      hint: hint,
      camposExtras: camposExtras,
      onCriar: onCriar,
    ),
  );
}

class _NovoItemDialog extends StatefulWidget {
  final String titulo;
  final String label;
  final String? hint;
  final List<CampoExtra> camposExtras;
  final Future<LookupItem> Function(
    String nome,
    Map<String, String> extras,
  ) onCriar;

  const _NovoItemDialog({
    required this.titulo,
    required this.label,
    required this.onCriar,
    this.hint,
    this.camposExtras = const [],
  });

  @override
  State<_NovoItemDialog> createState() => _NovoItemDialogState();
}

class _NovoItemDialogState extends State<_NovoItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  late final Map<String, TextEditingController> _extraControllers;
  bool _isSaving = false;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _extraControllers = {
      for (final campo in widget.camposExtras)
        campo.chave: TextEditingController(),
    };
  }

  @override
  void dispose() {
    _nomeController.dispose();
    for (final controller in _extraControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  /// Extrai uma mensagem legível da exceção, mostrando o motivo real do
  /// Supabase (ex: RLS bloqueando o insert) em vez de um texto genérico —
  /// isso ajuda a diagnosticar rapidamente o que está impedindo o salvamento.
  String _mensagemDeErro(Object e) {
    final texto = e.toString();
    if (texto.contains('row-level security') || texto.contains('RLS')) {
      return 'Sem permissão para cadastrar (política de segurança do banco '
          'bloqueou o INSERT nesta tabela).';
    }
    return 'Não foi possível salvar: $texto';
  }

  Future<void> _salvar() async {
    if (_isSaving) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
      _erro = null;
    });

    final extras = <String, String>{
      for (final entry in _extraControllers.entries)
        if (entry.value.text.trim().isNotEmpty)
          entry.key: entry.value.text.trim(),
    };

    try {
      final novoItem =
          await widget.onCriar(_nomeController.text.trim(), extras);
      if (mounted) Navigator.pop(context, novoItem);
    } catch (e) {
      if (mounted) {
        setState(() {
          _erro = _mensagemDeErro(e);
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        widget.titulo,
        style: TextStyle(color: VerdeEscuro, fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nomeController,
                autofocus: true,
                enabled: !_isSaving,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: widget.label,
                  hintText: widget.hint,
                  labelStyle: TextStyle(
                    color: VerdeClaro,
                    fontWeight: FontWeight.w600,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Digite um nome';
                  }
                  return null;
                },
                onFieldSubmitted:
                    widget.camposExtras.isEmpty ? (_) => _salvar() : null,
              ),
              for (final campo in widget.camposExtras) ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _extraControllers[campo.chave],
                  enabled: !_isSaving,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: campo.tipo == TipoCampoExtra.numero
                      ? const TextInputType.numberWithOptions(decimal: true)
                      : TextInputType.text,
                  decoration: InputDecoration(
                    labelText: '${campo.label} (opcional)',
                    hintText: campo.hint,
                    labelStyle: TextStyle(
                      color: VerdeClaro,
                      fontWeight: FontWeight.w600,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: campo.tipo == TipoCampoExtra.numero
                      ? (value) {
                          if (value == null || value.trim().isEmpty) {
                            return null;
                          }
                          final normalizado = value.trim().replaceAll(',', '.');
                          return double.tryParse(normalizado) == null
                              ? 'Digite um número válido'
                              : null;
                        }
                      : null,
                ),
              ],
              if (_erro != null) ...[
                const SizedBox(height: 8),
                Text(
                  _erro!,
                  style: const TextStyle(color: Colors.red, fontSize: 13),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _salvar,
          style: ElevatedButton.styleFrom(
            backgroundColor: VerdeEscuro,
            foregroundColor: Bege,
          ),
          child: _isSaving
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Salvar'),
        ),
      ],
    );
  }
}
