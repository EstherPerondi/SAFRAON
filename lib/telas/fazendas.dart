// lib/screens/fazendas.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../telas/fazenda.dart';  
import '../providers/fazenda_provider.dart';
import '../models/fazenda_model.dart';
import '../services/lookup_service.dart';
import '../variaveis.dart';

class FazendasPage extends StatefulWidget {
  const FazendasPage({super.key});

  @override
  State<FazendasPage> createState() => _FazendasPageState();
}

class _FazendasPageState extends State<FazendasPage> {
  List<LookupItem> _estados = [];

  @override
  void initState() {
    super.initState();
    LookupService().getEstados().then((lista) {
      if (mounted) setState(() => _estados = lista);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final provider = context.read<FazendaProvider>();
    await provider.loadUserFazendas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Bege,
      appBar: _buildAppBar(),
      body: Consumer<FazendaProvider>(
        builder: (context, provider, child) {
          // Mostrar mensagens de sucesso/erro
          if (provider.successMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(provider.successMessage!),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
              provider.resetMessages();
            });
          }

          if (provider.error != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(provider.error!),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3),
                ),
              );
              provider.resetMessages();
            });
          }

          return _buildBody(provider);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFazendaForm(context, null),
        backgroundColor: VerdeEscuro,
        foregroundColor: Bege,
        child: const Icon(Icons.add, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
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
            'Imagens/ICONE_FAZENDAS.png',
            width: 35,
            height: 35,
            color: BegeClaro,
          ),
          const SizedBox(width: 8),
          Text(
            'Fazendas',
            style: TextStyle(
              fontSize: 30,
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
    );
  }

  Widget _buildBody(FazendaProvider provider) {
    // Estado de loading
    if (provider.isLoading && provider.fazendas.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.green),
            SizedBox(height: 16),
            Text('Carregando fazendas...'),
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
              if (provider.fazendas.isEmpty)
                _buildEmptyState()
              else
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _loadData,
                    child: ListView.builder(
                      itemCount: provider.fazendas.length,
                      itemBuilder: (context, index) {
                        final fazenda = provider.fazendas[index];
                        return _buildFazendaCard(fazenda);
                      },
                    ),
                  ),
                ),
              _buildFooter(provider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.house, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Nenhuma fazenda cadastrada',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Clique no botão + para adicionar',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFazendaCard(FazendaModel fazenda) {
    return GestureDetector(
      onTap: () => _navigateToTalhoes(fazenda.id, fazenda.nome),
      child: Card(
        color: Colors.orange[50],
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.house, color: VerdeEscuro, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fazenda.nome,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: () => _showFazendaForm(context, fazenda),
                    color: VerdeClaro,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 15),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: () => _deleteFazenda(fazenda.id),
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

  Widget _buildFooter(FazendaProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: VerdeEscuro,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total de Fazendas',
            style: TextStyle(color: Bege, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
            decoration: BoxDecoration(
              color: Bege,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '${provider.fazendas.length}',
              style: TextStyle(
                color: VerdeEscuro,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToTalhoes(String fazendaId, String fazendaNome) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FazendaPage(
          fazendaId: fazendaId,
          fazendaNome: fazendaNome,
        ),
      ),
    );
  }

  void _showFazendaForm(BuildContext context, FazendaModel? fazenda) {
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
            child: _FazendaFormModal(
              fazenda: fazenda,
              estados: _estados,
              onSave: (novaFazenda) async {
                final provider = context.read<FazendaProvider>();
                bool success;

                if (fazenda == null) {
                  success = await provider.create(novaFazenda);
                } else {
                  success = await provider.update(novaFazenda);
                }

                if (success && mounted) {
                  Navigator.pop(context);
                  await provider.loadUserFazendas();
                }
              },
            ),
          ),
        );
      },
    );
  }

  void _deleteFazenda(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir Fazenda'),
          content: const Text(
            'Tem certeza que deseja excluir esta fazenda?\n\n'
            'Isso também excluirá todos os talhões e dados relacionados.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final provider = context.read<FazendaProvider>();
                final success = await provider.delete(id);

                if (success && mounted) {
                  Navigator.pop(context);
                  await provider.loadUserFazendas();
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

// ============================================
// MODAL DO FORMULÁRIO DE FAZENDA
// ============================================
class _FazendaFormModal extends StatefulWidget {
  final FazendaModel? fazenda;
  final List<LookupItem> estados;
  final Function(FazendaModel) onSave;

  const _FazendaFormModal({
    this.fazenda,
    required this.estados,
    required this.onSave,
  });

  @override
  State<_FazendaFormModal> createState() => _FazendaFormModalState();
}

class _FazendaFormModalState extends State<_FazendaFormModal> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  String? _estadoId;
  bool _isSaving = false;

  bool get _isEditing => widget.fazenda != null;

  @override
  void initState() {
    super.initState();
    if (widget.fazenda != null) {
      _nomeController.text = widget.fazenda!.nome;
      _estadoId = widget.fazenda!.estadoId;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
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
                  _isEditing ? 'Editar Fazenda' : 'Nova Fazenda',
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
                    _buildFormField(
                      label: 'Nome da Fazenda',
                      controller: _nomeController,
                      icon: Icons.house,
                      hint: 'Ex: Fazenda Santa Clara',
                    ),
                    const SizedBox(height: 16),
                    _buildEstadoDropdown(),
                    const SizedBox(height: 24),

                    // Botão Salvar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _saveFazenda,
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

  Widget _buildEstadoDropdown() {
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
        value: _estadoId,
        decoration: InputDecoration(
          labelText: 'Estado',
          labelStyle: TextStyle(color: VerdeClaro, fontWeight: FontWeight.w600),
          prefixIcon: Icon(Icons.map, color: VerdeClaro),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(16),
        ),
        items: widget.estados
            .map((e) => DropdownMenuItem(value: e.id, child: Text(e.nome)))
            .toList(),
        onChanged: (value) => setState(() => _estadoId = value),
        validator: (value) =>
            value == null || value.isEmpty ? 'Selecione o estado' : null,
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
          labelStyle: TextStyle(color: VerdeClaro, fontWeight: FontWeight.w600),
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

  void _saveFazenda() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final novaFazenda = FazendaModel(
        id: widget.fazenda?.id ?? '',
        nome: _nomeController.text.trim(),
        userId: '', // Será preenchido pelo service
        estadoId: _estadoId ?? '',
      );

      await widget.onSave(novaFazenda);
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