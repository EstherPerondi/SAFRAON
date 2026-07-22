import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manejo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const ManejoPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// MODELO DE DADOS
class ManagementItem {
  final String id;
  final String code;
  final String type;
  final String date;
  final String reason;
  final int priority;

  ManagementItem({
    required this.id,
    required this.code,
    required this.type,
    required this.date,
    required this.reason,
    required this.priority,
  });

  ManagementItem copyWith({
    String? id,
    String? code,
    String? type,
    String? date,
    String? reason,
    int? priority,
  }) {
    return ManagementItem(
      id: id ?? this.id,
      code: code ?? this.code,
      type: type ?? this.type,
      date: date ?? this.date,
      reason: reason ?? this.reason,
      priority: priority ?? this.priority,
    );
  }
}

// TELA PRINCIPAL - MANEJO
class ManejoPage extends StatefulWidget {
  const ManejoPage({super.key});

  @override
  State<ManejoPage> createState() => _ManejoPageState();
}

class _ManejoPageState extends State<ManejoPage> {
  List<ManagementItem> managements = [
    ManagementItem(
      id: '1',
      code: 'M001',
      type: 'Correção de solo',
      date: '12/08/25',
      reason: 'Solo com baixo pH',
      priority: 5,
    ),
    ManagementItem(
      id: '2',
      code: 'M002',
      type: 'Subsolação',
      date: '15/01/26',
      reason: 'Compactação do solo',
      priority: 3,
    ),
    ManagementItem(
      id: '3',
      code: 'M003',
      type: 'Calagem',
      date: '20/02/26',
      reason: 'Neutralizar acidez',
      priority: 4,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manejo - Talhão 1',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: managements.length,
                itemBuilder: (context, index) {
                  return _buildManagementCard(managements[index]);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showManagementForm(context, null),
        backgroundColor: Colors.green.shade700,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            Icons.build,
            'Total',
            '${managements.length}',
          ),
          _buildStatItem(
            Icons.priority_high,
            'Prioridade',
            'Média',
          ),
          _buildStatItem(
            Icons.calendar_today,
            'Último',
            '15/01/26',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.green.shade700, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildManagementCard(ManagementItem management) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _getPriorityColor(management.priority).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.build,
                          color: _getPriorityColor(management.priority),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              management.type,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Código: ${management.code}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _getPriorityColor(management.priority).withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Prioridade ${management.priority}',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: _getPriorityColor(management.priority),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _showManagementForm(context, management),
                      color: Colors.blue.shade600,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      onPressed: () => _deleteManagement(management.id),
                      color: Colors.red.shade400,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildInfoRow(
                    Icons.calendar_today,
                    management.date,
                    'Data',
                  ),
                ),
                Expanded(
                  child: _buildInfoRow(
                    Icons.description,
                    management.reason,
                    'Motivo',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(int priority) {
    if (priority >= 4) {
      return Colors.red.shade700;
    } else if (priority >= 3) {
      return Colors.orange.shade700;
    } else {
      return Colors.green.shade700;
    }
  }

  Widget _buildInfoRow(IconData icon, String value, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showManagementForm(BuildContext context, ManagementItem? management) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ManagementFormModal(
          management: management,
          onSave: (newManagement) {
            setState(() {
              if (management == null) {
                managements.add(newManagement);
              } else {
                final index = managements.indexWhere((m) => m.id == management.id);
                if (index != -1) {
                  managements[index] = newManagement;
                }
              }
            });
          },
        );
      },
    );
  }

  void _deleteManagement(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir Manejo'),
          content: const Text('Tem certeza que deseja excluir este manejo?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  managements.removeWhere((m) => m.id == id);
                });
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

// MODAL DE FORMULÁRIO - MANEJO
class ManagementFormModal extends StatefulWidget {
  final ManagementItem? management;
  final Function(ManagementItem) onSave;

  const ManagementFormModal({
    super.key,
    this.management,
    required this.onSave,
  });

  @override
  State<ManagementFormModal> createState() => _ManagementFormModalState();
}

class _ManagementFormModalState extends State<ManagementFormModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codeController;
  late TextEditingController _typeController;
  late TextEditingController _dateController;
  late TextEditingController _reasonController;
  int _priority = 3;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.management != null;
    _codeController = TextEditingController(text: widget.management?.code ?? '');
    _typeController = TextEditingController(text: widget.management?.type ?? '');
    _dateController = TextEditingController(text: widget.management?.date ?? '');
    _reasonController = TextEditingController(text: widget.management?.reason ?? '');
    _priority = widget.management?.priority ?? 3;
  }

  @override
  void dispose() {
    _codeController.dispose();
    _typeController.dispose();
    _dateController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.green.shade700,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isEditing ? 'Editar Manejo' : 'Novo Manejo',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          
          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormField(
                      label: 'Código',
                      controller: _codeController,
                      icon: Icons.code,
                      hint: 'Ex: M001',
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Tipo de manejo',
                      controller: _typeController,
                      icon: Icons.build,
                      hint: 'Ex: Correção de solo, Subsolação',
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Data',
                      controller: _dateController,
                      icon: Icons.calendar_today,
                      hint: 'DD/MM/AAAA',
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Motivo...',
                      controller: _reasonController,
                      icon: Icons.description,
                      hint: 'Descreva o motivo do manejo',
                    ),
                    const SizedBox(height: 16),
                    
                    // Prioridade
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
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.priority_high, color: Colors.green.shade700),
                              const SizedBox(width: 8),
                              Text(
                                'Prioridade',
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Slider(
                                  value: _priority.toDouble(),
                                  min: 1,
                                  max: 5,
                                  divisions: 4,
                                  label: 'Prioridade $_priority',
                                  activeColor: _getPriorityColor(_priority),
                                  onChanged: (value) {
                                    setState(() {
                                      _priority = value.round();
                                    });
                                  },
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getPriorityColor(_priority).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '$_priority',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _getPriorityColor(_priority),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Baixa',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              Text(
                                'Alta',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Botão Salvar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveManagement,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          foregroundColor: Colors.white,
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
                    const SizedBox(height: 16),
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
            color: Colors.green.shade700,
            fontWeight: FontWeight.w600,
          ),
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.green.shade700),
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

  Color _getPriorityColor(int priority) {
    if (priority >= 4) {
      return Colors.red.shade700;
    } else if (priority >= 3) {
      return Colors.orange.shade700;
    } else {
      return Colors.green.shade700;
    }
  }

  void _saveManagement() {
    if (_formKey.currentState!.validate()) {
      final newManagement = ManagementItem(
        id: widget.management?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        code: _codeController.text,
        type: _typeController.text,
        date: _dateController.text,
        reason: _reasonController.text,
        priority: _priority,
      );
      
      widget.onSave(newManagement);
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing ? 'Manejo atualizado com sucesso!' : 'Manejo criado com sucesso!',
          ),
          backgroundColor: Colors.green.shade700,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}