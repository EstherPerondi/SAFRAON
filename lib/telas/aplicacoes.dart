import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/aplicacao_provider.dart';
import '../providers/talhao_provider.dart';
import '../models/aplicacao_model.dart';
import '../services/lookup_service.dart';
import '../widgets/novo_item_dialog.dart';
import '../variaveis.dart';
import '../models/fazenda_model.dart';
import '../models/talhao_model.dart';
import '../services/fazenda_service.dart';
import '../services/talhao_service.dart';
import '../services/supabase_service.dart';

class AplicacoesPage extends StatefulWidget {
  const AplicacoesPage({super.key});

  @override
  State<AplicacoesPage> createState() => _AplicacoesPageState();
}

class _AplicacoesPageState extends State<AplicacoesPage> {
  String? _talhaoId;
  List<LookupItem> _defensivos = [];

  @override
  void initState() {
    super.initState();
    LookupService().getDefensivos().then((lista) {
      if (mounted) setState(() => _defensivos = lista);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Tentar obter talhaoId dos argumentos
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map && args.containsKey('talhaoId')) {
        _talhaoId = args['talhaoId'].toString();
        context.read<AplicacaoProvider>().loadByTalhaoId(_talhaoId!);
      } else {
        // Carregar todas as aplicações do usuário
        context.read<AplicacaoProvider>().loadAll();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Bege,
      appBar: AppBar(
        backgroundColor: VerdeEscuro,
        iconTheme: IconThemeData(color: BegeClaro),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(
              image: AssetImage('Imagens/ICONE_DEFENSIVO.png'),
              width: 35,
              height: 35,
              fit: BoxFit.cover,
              color: BegeClaro,
            ),
            const SizedBox(width: 8),
            Text(
              'Aplicações',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: BegeClaro,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Consumer<AplicacaoProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.aplicacoes.isEmpty) {
            return Center(
              child: CircularProgressIndicator(color: VerdeEscuro),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Erro ao carregar aplicações',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.error!,
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_talhaoId != null) {
                        provider.loadByTalhaoId(_talhaoId!);
                      } else {
                        provider.loadAll();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: VerdeEscuro,
                      foregroundColor: Bege,
                    ),
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (provider.aplicacoes.isEmpty)
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.spa,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Nenhuma aplicação registrada',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Clique no botão + para adicionar',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () {
                            if (_talhaoId != null) {
                              return provider.loadByTalhaoId(_talhaoId!);
                            } else {
                              return provider.loadAll();
                            }
                          },
                          child: ListView.builder(
                            itemCount: provider.aplicacoes.length,
                            itemBuilder: (context, index) {
                              final aplicacao = provider.aplicacoes[index];
                              return _buildAplicacaoCard(aplicacao, index);
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAplicacaoForm(context, null),
        backgroundColor: VerdeEscuro,
        foregroundColor: Bege,
        child: const Icon(Icons.add, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }

  Widget _buildAplicacaoCard(AplicacaoModel aplicacao, int index) {
    return Card(
      color: Colors.orange[50],
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.science,
                    color: VerdeEscuro,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        aplicacao.defensivos,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 14, color: VerdeClaro),
                          const SizedBox(width: 4),
                          Text(
                            aplicacao.formattedDate,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      if (_talhaoId == null && aplicacao.localizacao != null)
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 14,
                              color: VerdeClaro,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                aplicacao.localizacao!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _buildInfoChip(Icons.description, aplicacao.motivo),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _showAplicacaoForm(context, aplicacao),
                      color: VerdeClaro,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(height: 15),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      onPressed: () => _deleteAplicacao(aplicacao.id),
                      color: Colors.red.shade400,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: VerdeClaro.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: VerdeEscuro),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label.isNotEmpty ? label : 'Sem informação',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTipoIcon(String tipo) {
    if (tipo.toLowerCase().contains('fungicida')) {
      return Icons.biotech;
    } else if (tipo.toLowerCase().contains('dessecação')) {
      return Icons.water_drop;
    } else if (tipo.toLowerCase().contains('herbicida')) {
      return Icons.grass;
    } else if (tipo.toLowerCase().contains('inseticida')) {
      return Icons.bug_report;
    } else {
      return Icons.spa;
    }
  }

  void _showAplicacaoForm(BuildContext context, AplicacaoModel? aplicacao) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: BoxConstraints(
              maxWidth: 560,
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            child: _AplicacaoFormModal(
              aplicacao: aplicacao,
              talhaoId: _talhaoId,
              defensivos: _defensivos,
              onSave: (novaAplicacao) {
                final provider = context.read<AplicacaoProvider>();
                if (aplicacao == null) {
                  provider.create(novaAplicacao);
                } else {
                  provider.update(novaAplicacao);
                }
              },
            ),
          ),
        );
      },
    );
  }

  void _deleteAplicacao(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir Aplicação'),
          content: const Text('Tem certeza que deseja excluir esta aplicação?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                context.read<AplicacaoProvider>().delete(id);
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }
}

// ============================================
// MODAL DO FORMULÁRIO DE APLICAÇÃO
// ============================================
class _AplicacaoFormModal extends StatefulWidget {
  final AplicacaoModel? aplicacao;
  final String? talhaoId;
  final List<LookupItem> defensivos;
  final Function(AplicacaoModel) onSave;

  const _AplicacaoFormModal({
    this.aplicacao,
    this.talhaoId,
    required this.defensivos,
    required this.onSave,
  });

  @override
  State<_AplicacaoFormModal> createState() => _AplicacaoFormModalState();
}

class _AplicacaoFormModalState extends State<_AplicacaoFormModal> {
  final _formKey = GlobalKey<FormState>();
  String? _talhaoSelecionadoId;
  final _motivoController = TextEditingController();
  final _doseController = TextEditingController();
  String? _defensivoId;
  DateTime? _selectedDate;

  bool get _isEditing => widget.aplicacao != null;

  @override
  void initState() {
    super.initState();
    if (widget.aplicacao != null) {
      _defensivoId = widget.aplicacao!.defensivoId;
      _motivoController.text = widget.aplicacao!.motivo;
      _doseController.text = widget.aplicacao!.doseporhectare.toString();
      _selectedDate = widget.aplicacao!.data;
    } else {
      _selectedDate = DateTime.now();
    }
  }

  @override
  void dispose() {
    _motivoController.dispose();
    _doseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: VerdeEscuro,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isEditing ? 'Editar Aplicação' : 'Nova Aplicação',
                  style: TextStyle(
                    color: Bege,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Bege),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Form
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Só pede fazenda/talhão quando a tela foi aberta pelo menu
                    // principal. Dentro de um talhão, o talhão já é conhecido.
                    if (widget.talhaoId == null) ...[
                      _FazendaTalhaoCampos(
                        talhaoIdInicial: widget.aplicacao?.talhaoId,
                        onChanged: (id) => _talhaoSelecionadoId = id,
                      ),
                      const SizedBox(height: 16),
                    ],
                    _buildDefensivoDropdown(),
                    const SizedBox(height: 16),
                    _buildDateField(),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Motivo',
                      controller: _motivoController,
                      icon: Icons.description,
                      hint: 'Motivo da aplicação',
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Dose por hectare',
                      controller: _doseController,
                      icon: Icons.water_drop_outlined,
                      hint: 'Ex: 2.5',
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 24),

                    // Botão Salvar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveAplicacao,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: VerdeEscuro,
                          foregroundColor: Bege,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          'Salvar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefensivoDropdown() {
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
      child: DropdownButtonFormField<String>(
        value: _defensivoId,
        decoration: InputDecoration(
          labelText: 'Defensivo',
          labelStyle: TextStyle(color: VerdeClaro, fontWeight: FontWeight.w600),
          prefixIcon: Icon(Icons.science, color: VerdeClaro),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(16),
        ),
        items: [
          ...widget.defensivos
              .map((d) => DropdownMenuItem(value: d.id, child: Text(d.nome))),
          buildAdicionarNovoDropdownItem('+ Adicionar novo defensivo...'),
        ],
        onChanged: (value) async {
          if (value == kAdicionarNovoValor) {
            final novoDefensivo = await showNovoItemDialog(
              context: context,
              titulo: 'Novo Defensivo',
              label: 'Nome do defensivo',
              hint: 'Ex: Glifosato',
              camposExtras: const [
                CampoExtra(
                  chave: 'principioAtivo',
                  label: 'Princípio ativo',
                  hint: 'Ex: Glifosato 480 g/L',
                ),
                CampoExtra(
                  chave: 'fabricante',
                  label: 'Fabricante',
                  hint: 'Ex: Bayer',
                ),
                CampoExtra(
                  chave: 'utilidade',
                  label: 'Utilidade',
                  hint: 'Ex: Herbicida',
                ),
              ],
              onCriar: (nome, extras) => LookupService().createDefensivo(
                nome,
                principioAtivo: extras['principioAtivo'],
                fabricante: extras['fabricante'],
                utilidade: extras['utilidade'],
              ),
            );
            if (novoDefensivo != null) {
              setState(() {
                widget.defensivos.add(novoDefensivo);
                _defensivoId = novoDefensivo.id;
              });
            }
            return;
          }
          setState(() => _defensivoId = value);
        },
        validator: (value) =>
            value == null || value.isEmpty ? 'Selecione o defensivo' : null,
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? hint,
    TextInputType? keyboardType,
  }) {
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
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: VerdeClaro,
            fontWeight: FontWeight.w600,
          ),
          hintText: hint,
          prefixIcon: Icon(icon, color: VerdeClaro),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(16),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Campo obrigatório';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDateField() {
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
      child: InkWell(
        onTap: _selectDate,
        borderRadius: BorderRadius.circular(12),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'Data',
            labelStyle: TextStyle(
              color: VerdeClaro,
              fontWeight: FontWeight.w600,
            ),
            prefixIcon: Icon(Icons.calendar_today, color: VerdeClaro),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(16),
          ),
          child: Text(
            _selectedDate != null
                ? '${_selectedDate!.day.toString().padLeft(2, '0')}/'
                    '${_selectedDate!.month.toString().padLeft(2, '0')}/'
                    '${_selectedDate!.year}'
                : 'Selecione uma data',
            style: TextStyle(
              fontSize: 16,
              color: _selectedDate != null ? Colors.black87 : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('pt', 'BR'),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveAplicacao() {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final novaAplicacao = AplicacaoModel(
        id: widget.aplicacao?.id ?? '',
        talhaoId: _talhaoSelecionadoId ??
            widget.talhaoId ??
            widget.aplicacao?.talhaoId ??
            '',
        defensivoId: _defensivoId!,
        data: _selectedDate!,
        motivo: _motivoController.text,
        doseporhectare: double.parse(_doseController.text),
      );

      widget.onSave(novaAplicacao);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Aplicação atualizada com sucesso!'
                : 'Aplicação criada com sucesso!',
          ),
          backgroundColor: VerdeEscuro,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}


// ---------------------------------------------------------------------------
// Campos Fazenda + Talhão do formulário (só aparecem quando a tela é aberta
// pelo menu principal; dentro de um talhão, o talhão já é conhecido).
// ---------------------------------------------------------------------------
class _FazendaTalhaoCampos extends StatefulWidget {
  final String? talhaoIdInicial;
  final ValueChanged<String?> onChanged;

  const _FazendaTalhaoCampos({this.talhaoIdInicial, required this.onChanged});

  @override
  State<_FazendaTalhaoCampos> createState() => _FazendaTalhaoCamposState();
}

class _FazendaTalhaoCamposState extends State<_FazendaTalhaoCampos> {
  List<FazendaModel> _fazendas = [];
  List<TalhaoModel> _talhoes = [];
  String? _fazendaId;
  String? _talhaoId;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    try {
      final todas = await FazendaService().getAll();
      final userId = SupabaseService().currentUserId;
      final fazendas = userId.isEmpty
          ? todas
          : todas.where((f) => f.userId == userId).toList();

      String? fazendaId;
      String? talhaoId;
      List<TalhaoModel> talhoes = [];
      final inicial = widget.talhaoIdInicial;

      if (inicial != null && inicial.isNotEmpty) {
        final t = await TalhaoService().getById(inicial);
        if (t != null) {
          fazendaId = t.fazendaId;
          talhaoId = t.id;
          talhoes = await TalhaoService().getByFazenda(t.fazendaId);
        }
      } else if (fazendas.length == 1) {
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
      widget.onChanged(talhaoId);
    } catch (_) {
      if (!mounted) return;
      setState(() => _carregando = false);
    }
  }

  Future<void> _trocarFazenda(String? fazendaId) async {
    setState(() {
      _fazendaId = fazendaId;
      _talhaoId = null;
      _talhoes = [];
    });
    widget.onChanged(null);
    if (fazendaId == null) return;

    final talhoes = await TalhaoService().getByFazenda(fazendaId);
    if (!mounted || _fazendaId != fazendaId) return;
    setState(() {
      _talhoes = talhoes;
      if (talhoes.length == 1) _talhaoId = talhoes.first.id;
    });
    widget.onChanged(_talhaoId);
  }

  // Mesmo visual dos demais campos do formulário
  Widget _campo({required Widget child}) {
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

  InputDecoration _deco(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _campo(
          child: DropdownButtonFormField<String>(
            key: ValueKey('fazenda-$_carregando'),
            isExpanded: true,
            value: _fazendaId,
            decoration: _deco('Fazenda', Icons.landscape),
            items: [
              for (final f in _fazendas)
                DropdownMenuItem(
                  value: f.id,
                  child: Text(f.nome, overflow: TextOverflow.ellipsis),
                ),
            ],
            onChanged: _trocarFazenda,
            validator: (v) =>
                v == null || v.isEmpty ? 'Selecione a fazenda' : null,
          ),
        ),
        const SizedBox(height: 16),
        _campo(
          child: DropdownButtonFormField<String>(
            key: ValueKey('talhao-$_fazendaId-${_talhoes.length}-$_carregando'),
            isExpanded: true,
            value: _talhaoId,
            decoration: _deco('Talhão', Icons.grid_view),
            items: [
              for (final t in _talhoes)
                DropdownMenuItem(
                  value: t.id,
                  child: Text(t.nome, overflow: TextOverflow.ellipsis),
                ),
            ],
            onChanged: _fazendaId == null
                ? null
                : (v) {
                    setState(() => _talhaoId = v);
                    widget.onChanged(v);
                  },
            validator: (v) =>
                v == null || v.isEmpty ? 'Selecione o talhão' : null,
          ),
        ),
      ],
    );
  }
}