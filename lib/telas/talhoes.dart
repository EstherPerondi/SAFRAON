import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/talhao_provider.dart';
import '../providers/fazenda_provider.dart';
import '../models/talhao_model.dart';
import '../models/fazenda_model.dart';
import '../variaveis.dart';
import 'talhao.dart';

class TalhoesPage extends StatefulWidget {
  const TalhoesPage({super.key});

  @override
  State<TalhoesPage> createState() => _TalhoesPageState();
}

class _TalhoesPageState extends State<TalhoesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    await context.read<TalhaoProvider>().loadAll();
    await context.read<FazendaProvider>().loadUserFazendas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Bege,
      appBar: AppBar(
        backgroundColor: VerdeEscuro,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'Imagens/ICONE_TALHAO.png',
              color: BegeClaro,
              width: 35,
              height: 35,
            ),
            const SizedBox(width: 8),
            Text(
              'Talhões',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: BegeClaro,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: BegeClaro),
            onPressed: _loadData,
          ),
        ],
      ),
      body: Consumer2<TalhaoProvider, FazendaProvider>(
        builder: (context, talhaoProvider, fazendaProvider, child) {
          if (talhaoProvider.successMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(talhaoProvider.successMessage!),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
              talhaoProvider.resetMessages();
            });
          }

          if (talhaoProvider.error != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(talhaoProvider.error!),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3),
                ),
              );
              talhaoProvider.resetMessages();
            });
          }

          if (talhaoProvider.isLoading && talhaoProvider.talhoes.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.green),
                  SizedBox(height: 16),
                  Text('Carregando talhões...'),
                ],
              ),
            );
          }

          if (talhaoProvider.error != null && talhaoProvider.talhoes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Erro ao carregar talhões',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    talhaoProvider.error!,
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadData,
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
                    if (talhaoProvider.talhoes.isEmpty)
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.terrain,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Nenhum talhão cadastrado',
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
                          onRefresh: _loadData,
                          child: ListView.builder(
                            itemCount: talhaoProvider.talhoes.length,
                            itemBuilder: (context, index) {
                              final talhao = talhaoProvider.talhoes[index];
                              final fazenda = fazendaProvider.fazendas
                                  .firstWhere(
                                    (f) => f.id == talhao.fazendaId,
                                    orElse: () => FazendaModel(
                                      id: '',
                                      nome: 'Fazenda Desconhecida',
                                      area: '',
                                      userId: '',
                                    ),
                                  );
                              return _buildTalhaoCard(talhao, fazenda);
                            },
                          ),
                        ),
                      ),

                    // Rodapé
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: VerdeEscuro,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total de Talhões',
                            style: TextStyle(
                              color: Bege,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Bege,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              '${talhaoProvider.talhoes.length}',
                              style: TextStyle(
                                color: VerdeEscuro,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
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
        onPressed: () => _showTalhaoForm(context, null),
        backgroundColor: VerdeEscuro,
        foregroundColor: Bege,
        child: const Icon(Icons.add, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildTalhaoCard(TalhaoModel talhao, FazendaModel fazenda) {
    return Card(
      color: Colors.orange[50],
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TalhaoPage(
                talhaoData: {
                  'id': talhao.id,
                  'nome': talhao.nome,
                  'fazenda': fazenda.nome,
                  'cidade': talhao.cidade,
                  'fazenda_id': talhao.fazendaId,
                },
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.terrain,
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
                      talhao.nome,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.business, size: 14, color: VerdeClaro),
                        const SizedBox(width: 4),
                        Text(
                          fazenda.nome,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.location_on, size: 14, color: VerdeClaro),
                        const SizedBox(width: 4),
                        Text(
                          talhao.cidade,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: () => _showTalhaoForm(context, talhao),
                    color: VerdeClaro,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 15),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: () => _deleteTalhao(talhao.id),
                    color: Colors.red.shade400,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTalhaoForm(BuildContext context, TalhaoModel? talhao) {
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
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            child: _TalhaoFormModal(
              talhao: talhao,
              onSave: (novoTalhao) async {
                final provider = context.read<TalhaoProvider>();
                bool success;

                if (talhao == null) {
                  success = await provider.create(novoTalhao);
                } else {
                  success = await provider.update(novoTalhao);
                }

                if (success && mounted) {
                  Navigator.pop(context);
                  await _loadData();
                }
              },
            ),
          ),
        );
      },
    );
  }

  void _deleteTalhao(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir Talhão'),
          content: const Text('Tem certeza que deseja excluir este talhão?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final provider = context.read<TalhaoProvider>();
                final success = await provider.delete(id);

                if (success && mounted) {
                  Navigator.pop(context);
                  await _loadData();
                }
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

class _TalhaoFormModal extends StatefulWidget {
  final TalhaoModel? talhao;
  final Function(TalhaoModel) onSave;

  const _TalhaoFormModal({
    this.talhao,
    required this.onSave,
  });

  @override
  State<_TalhaoFormModal> createState() => _TalhaoFormModalState();
}

class _TalhaoFormModalState extends State<_TalhaoFormModal> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _cidadeController = TextEditingController();
  String? _selectedFazendaId;
  bool _isSaving = false;

  bool get _isEditing => widget.talhao != null;

  @override
  void initState() {
    super.initState();
    if (widget.talhao != null) {
      _nomeController.text = widget.talhao!.nome;
      _cidadeController.text = widget.talhao!.cidade;
      _selectedFazendaId = widget.talhao!.fazendaId;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _cidadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fazendas = context.watch<FazendaProvider>().fazendas;

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
                  _isEditing ? 'Editar Talhão' : 'Novo Talhão',
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
                    Container(
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
                        value: _selectedFazendaId,
                        decoration: InputDecoration(
                          labelText: 'Fazenda',
                          labelStyle: TextStyle(
                            color: VerdeClaro,
                            fontWeight: FontWeight.w600,
                          ),
                          prefixIcon: Icon(Icons.business, color: VerdeClaro),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        items: fazendas.map((fazenda) {
                          return DropdownMenuItem(
                            value: fazenda.id,
                            child: Text(fazenda.nome),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedFazendaId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Selecione uma fazenda';
                          }
                          return null;
                        },
                        dropdownColor: Colors.white,
                        style: const TextStyle(color: Colors.black87),
                        icon: Icon(Icons.arrow_drop_down, color: VerdeClaro),
                        isExpanded: true,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildFormField(
                      label: 'Nome do Talhão',
                      controller: _nomeController,
                      icon: Icons.map,
                      hint: 'Ex: Talhão 5',
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Localização',
                      controller: _cidadeController,
                      icon: Icons.location_on,
                      hint: 'Ex: Toledo',
                    ),
                    const SizedBox(height: 24),

                    // Botão Salvar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _saveTalhao,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: VerdeEscuro,
                          foregroundColor: Bege,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
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

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? hint,
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
          if (value == null || value.trim().isEmpty) {
            return 'Campo obrigatório';
          }
          return null;
        },
      ),
    );
  }

  void _saveTalhao() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedFazendaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione uma fazenda'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final novoTalhao = TalhaoModel(
        id: widget.talhao?.id ?? '',
        fazendaId: _selectedFazendaId!,
        nome: _nomeController.text.trim(),
        cidade: _cidadeController.text.trim(),
        userId: '', 
      );

      await widget.onSave(novoTalhao);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}