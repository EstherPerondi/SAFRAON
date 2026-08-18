import 'package:flutter/material.dart';
import 'package:safraon/variaveis.dart';

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
  final String type;
  final String date;
  final String reason;
  final String pesticides;

  ApplicationItem({
    required this.id,
    required this.type,
    required this.date,
    required this.reason,
    required this.pesticides,
  });

  ApplicationItem copyWith({
    String? id,
    String? type,
    String? date,
    String? reason,
    String? pesticides,
  }) {
    return ApplicationItem(
      id: id ?? this.id,
      type: type ?? this.type,
      date: date ?? this.date,
      reason: reason ?? this.reason,
      pesticides: pesticides ?? this.pesticides,
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
      type: 'Fungicida',
      date: '25/02/26',
      reason: 'Controle de ferrugem',
      pesticides: 'Triazol, Estrobilurina',
    ),
    ApplicationItem(
      id: '2',
      type: 'Dessecação',
      date: '03/01/26',
      reason: 'Preparo para colheita',
      pesticides: 'Glifosato, Paraquat',
    ),
    ApplicationItem(
      id: '3',
      type: 'Herbicida',
      date: '10/03/26',
      reason: 'Controle de plantas daninhas',
      pesticides: 'Atrazina, 2,4-D',
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
        backgroundColor: VerdeEscuro,
        foregroundColor: Bege,
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
          color: Bege
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
        backgroundColor: VerdeEscuro,
        child: Icon(Icons.add, color: Bege, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BegeClaro,
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
        Icon(icon, color: VerdeClaro, size: 24),
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
          color: VerdeClaro.withOpacity(0.5),
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
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getTypeIcon(application.type),
                          color: VerdeEscuro,
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
                      color: VerdeClaro,
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
                _buildInfoChip(Icons.description, application.reason),
                _buildInfoChip(Icons.science, application.pesticides),
              ],
            ),
          ],
        ),
      ),
    );
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
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: VerdeEscuro),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: BegeClaro,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // MÉTODO MODIFICADO - Agora usando showDialog com Dialog centralizado
  void _showApplicationForm(BuildContext context, ApplicationItem? application) {
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
            child: ApplicationFormModal(
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
            ),
          ),
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

// MODAL DE FORMULÁRIO - APLICAÇÕES (MODIFICADO PARA DIÁLOGO)
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
  late TextEditingController _typeController;
  late TextEditingController _dateController;
  late TextEditingController _reasonController;
  late TextEditingController _pesticidesController;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.application != null;
    _typeController = TextEditingController(text: widget.application?.type ?? '');
    _dateController = TextEditingController(text: widget.application?.date ?? '');
    _reasonController = TextEditingController(text: widget.application?.reason ?? '');
    _pesticidesController = TextEditingController(text: widget.application?.pesticides ?? '');
  }

  @override
  void dispose() {
    _typeController.dispose();
    _dateController.dispose();
    _reasonController.dispose();
    _pesticidesController.dispose();
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
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                      label: 'Motivo',
                      controller: _reasonController,
                      icon: Icons.description,
                      hint: 'Motivo da aplicação',
                    ),            
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Defensivos Usados',
                      controller: _pesticidesController,
                      icon: Icons.science,
                      hint: 'Lista de defensivos utilizados',
                    ),
                    const SizedBox(height: 24),
                    
                    // Botão Salvar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveApplication,
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
          if (value == null || value.isEmpty) {
            return 'Campo obrigatório';
          }
          return null;
        },
      ),
    );
  }

  void _saveApplication() {
    if (_formKey.currentState!.validate()) {
      final newApplication = ApplicationItem(
        id: widget.application?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        type: _typeController.text,
        date: _dateController.text,
        reason: _reasonController.text,
        pesticides: _pesticidesController.text
      );
      
      widget.onSave(newApplication);
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing ? 'Aplicação atualizada com sucesso!' : 'Aplicação criada com sucesso!',
          ),
          backgroundColor: VerdeEscuro,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}