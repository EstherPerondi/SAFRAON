import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicações',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const AplicacoesPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// MODELO DE DADOS
class ApplicationItem {
  final String id;
  final String code;
  final String type;
  final String date;
  final String mainReason;
  final String additionalReasons;
  final String pesticides;
  final int priority;

  ApplicationItem({
    required this.id,
    required this.code,
    required this.type,
    required this.date,
    required this.mainReason,
    required this.additionalReasons,
    required this.pesticides,
    required this.priority,
  });

  ApplicationItem copyWith({
    String? id,
    String? code,
    String? type,
    String? date,
    String? mainReason,
    String? additionalReasons,
    String? pesticides,
    int? priority,
  }) {
    return ApplicationItem(
      id: id ?? this.id,
      code: code ?? this.code,
      type: type ?? this.type,
      date: date ?? this.date,
      mainReason: mainReason ?? this.mainReason,
      additionalReasons: additionalReasons ?? this.additionalReasons,
      pesticides: pesticides ?? this.pesticides,
      priority: priority ?? this.priority,
    );
  }
}

// TELA PRINCIPAL - APLICAÇÕES
class AplicacoesPage extends StatefulWidget {
  const AplicacoesPage({super.key});

  @override
  State<AplicacoesPage> createState() => _AplicacoesPageState();
}

class _AplicacoesPageState extends State<AplicacoesPage> {
  List<ApplicationItem> applications = [
    ApplicationItem(
      id: '1',
      code: 'A001',
      type: 'Fungicida',
      date: '25/02/26',
      mainReason: 'Controle de ferrugem',
      additionalReasons: 'Prevenção de doenças fúngicas',
      pesticides: 'Triazol, Estrobilurina',
      priority: 4,
    ),
    ApplicationItem(
      id: '2',
      code: 'A002',
      type: 'Dessecação',
      date: '03/01/26',
      mainReason: 'Preparo para colheita',
      additionalReasons: 'Uniformização da maturação',
      pesticides: 'Glifosato, Paraquat',
      priority: 3,
    ),
    ApplicationItem(
      id: '3',
      code: 'A003',
      type: 'Herbicida',
      date: '10/03/26',
      mainReason: 'Controle de plantas daninhas',
      additionalReasons: 'Manutenção da lavoura',
      pesticides: 'Atrazina, 2,4-D',
      priority: 5,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Aplicações - Talhão 1',
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
                itemCount: applications.length,
                itemBuilder: (context, index) {
                  return _buildApplicationCard(applications[index]);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showApplicationForm(context, null),
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
            Icons.spa,
            'Aplicações',
            '${applications.length}',
          ),
          _buildStatItem(
            Icons.priority_high,
            'Urgência',
            'Média',
          ),
          _buildStatItem(
            Icons.calendar_today,
            'Última',
            '10/03/26',
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

  Widget _buildApplicationCard(ApplicationItem application) {
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
                          color: _getPriorityColor(application.priority).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getTypeIcon(application.type),
                          color: _getPriorityColor(application.priority),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              application.type,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Código: ${application.code}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _getPriorityColor(application.priority).withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Prioridade ${application.priority}',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: _getPriorityColor(application.priority),
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
                      onPressed: () => _showApplicationForm(context, application),
                      color: Colors.blue.shade600,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      onPressed: () => _deleteApplication(application.id),
                      color: Colors.red.shade400,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildInfoChip(Icons.calendar_today, application.date),
                _buildInfoChip(Icons.description, application.mainReason),
                _buildInfoChip(Icons.add_circle, application.additionalReasons),
                _buildInfoChip(Icons.science, application.pesticides),
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

  IconData _getTypeIcon(String type) {
    if (type.toLowerCase().contains('fungicida')) {
      return Icons.biotech;
    } else if (type.toLowerCase().contains('dessecação')) {
      return Icons.water_drop;
    } else if (type.toLowerCase().contains('herbicida')) {
      return Icons.grass;
    } else {
      return Icons.spa;
    }
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.green.shade700),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade800,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showApplicationForm(BuildContext context, ApplicationItem? application) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ApplicationFormModal(
          application: application,
          onSave: (newApplication) {
            setState(() {
              if (application == null) {
                applications.add(newApplication);
              } else {
                final index = applications.indexWhere((a) => a.id == application.id);
                if (index != -1) {
                  applications[index] = newApplication;
                }
              }
            });
          },
        );
      },
    );
  }

  void _deleteApplication(String id) {
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
                setState(() {
                  applications.removeWhere((a) => a.id == id);
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

// MODAL DE FORMULÁRIO - APLICAÇÕES
class ApplicationFormModal extends StatefulWidget {
  final ApplicationItem? application;
  final Function(ApplicationItem) onSave;

  const ApplicationFormModal({
    super.key,
    this.application,
    required this.onSave,
  });

  @override
  State<ApplicationFormModal> createState() => _ApplicationFormModalState();
}

class _ApplicationFormModalState extends State<ApplicationFormModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codeController;
  late TextEditingController _typeController;
  late TextEditingController _dateController;
  late TextEditingController _mainReasonController;
  late TextEditingController _additionalReasonsController;
  late TextEditingController _pesticidesController;
  int _priority = 3;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.application != null;
    _codeController = TextEditingController(text: widget.application?.code ?? '');
    _typeController = TextEditingController(text: widget.application?.type ?? '');
    _dateController = TextEditingController(text: widget.application?.date ?? '');
    _mainReasonController = TextEditingController(text: widget.application?.mainReason ?? '');
    _additionalReasonsController = TextEditingController(text: widget.application?.additionalReasons ?? '');
    _pesticidesController = TextEditingController(text: widget.application?.pesticides ?? '');
    _priority = widget.application?.priority ?? 3;
  }

  @override
  void dispose() {
    _codeController.dispose();
    _typeController.dispose();
    _dateController.dispose();
    _mainReasonController.dispose();
    _additionalReasonsController.dispose();
    _pesticidesController.dispose();
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
                  _isEditing ? 'Editar Aplicação' : 'Nova Aplicação',
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
                      hint: 'Ex: A001',
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Tipo de Aplicação',
                      controller: _typeController,
                      icon: Icons.spa,
                      hint: 'Ex: Fungicida, Dessecação',
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
                      label: 'Motivo principal',
                      controller: _mainReasonController,
                      icon: Icons.description,
                      hint: 'Motivo da aplicação',
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Motivos Adicionais',
                      controller: _additionalReasonsController,
                      icon: Icons.add_circle,
                      hint: 'Motivos secundários',
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Defensivos Usados',
                      controller: _pesticidesController,
                      icon: Icons.science,
                      hint: 'Lista de defensivos utilizados',
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
                        onPressed: _saveApplication,
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

  void _saveApplication() {
    if (_formKey.currentState!.validate()) {
      final newApplication = ApplicationItem(
        id: widget.application?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        code: _codeController.text,
        type: _typeController.text,
        date: _dateController.text,
        mainReason: _mainReasonController.text,
        additionalReasons: _additionalReasonsController.text,
        pesticides: _pesticidesController.text,
        priority: _priority,
      );
      
      widget.onSave(newApplication);
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing ? 'Aplicação atualizada com sucesso!' : 'Aplicação criada com sucesso!',
          ),
          backgroundColor: Colors.green.shade700,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}