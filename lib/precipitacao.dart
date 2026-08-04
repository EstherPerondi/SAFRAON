import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Precipitações',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const PrecipitacaoPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// MODELO DE DADOS
class PrecipitationItem {
  final String id;
  final double millimeters;
  final String date;
  final String city;
  final String observations;

  PrecipitationItem({
    required this.id,
    required this.millimeters,
    required this.date,
    required this.city,
    required this.observations,
  });

  PrecipitationItem copyWith({
    String? id,
    double? millimeters,
    String? date,
    String? city,
    String? observations,
  }) {
    return PrecipitationItem(
      id: id ?? this.id,
      millimeters: millimeters ?? this.millimeters,
      date: date ?? this.date,
      city: city ?? this.city,
      observations: observations ?? this.observations,
    );
  }
}

// TELA PRINCIPAL - PRECIPITAÇÕES
class PrecipitacaoPage extends StatefulWidget {
  const PrecipitacaoPage({super.key});

  @override
  State<PrecipitacaoPage> createState() => _PrecipitacaoPageState();
}

class _PrecipitacaoPageState extends State<PrecipitacaoPage> {
  List<PrecipitationItem> precipitations = [
    PrecipitationItem(
      id: '1',
      millimeters: 15,
      date: '15/01/26',
      city: 'São Paulo',
      observations: 'Chuva moderada',
    ),
    PrecipitationItem(
      id: '2',
      millimeters: 10,
      date: '15/06/26',
      city: 'São Paulo',
      observations: 'Chuva leve',
    ),
    PrecipitationItem(
      id: '3',
      millimeters: 25,
      date: '20/02/26',
      city: 'Campinas',
      observations: 'Chuva intensa',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Precipitações - Talhão 1',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud),
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
              Colors.blue.shade50,
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
                itemCount: precipitations.length,
                itemBuilder: (context, index) {
                  return _buildPrecipitationCard(precipitations[index]);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPrecipitationForm(context, null),
        backgroundColor: Colors.blue.shade700,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildHeader() {
    double totalPrecipitation = precipitations.fold(0, (sum, item) => sum + item.millimeters);
    double averagePrecipitation = precipitations.isNotEmpty 
        ? totalPrecipitation / precipitations.length 
        : 0;

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
            Icons.water_drop,
            'Total',
            '${totalPrecipitation.toStringAsFixed(0)} mm',
          ),
          _buildStatItem(
            Icons.show_chart,
            'Média',
            '${averagePrecipitation.toStringAsFixed(1)} mm',
          ),
          _buildStatItem(
            Icons.calendar_today,
            'Registros',
            '${precipitations.length}',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue.shade700, size: 24),
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

  Widget _buildPrecipitationCard(PrecipitationItem precipitation) {
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
              Colors.blue.shade50,
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
                          color: _getIntensityColor(precipitation.millimeters).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getIntensityIcon(precipitation.millimeters),
                          color: _getIntensityColor(precipitation.millimeters),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${precipitation.millimeters.toStringAsFixed(0)} mm',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _getIntensityColor(precipitation.millimeters).withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _getIntensityLabel(precipitation.millimeters),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: _getIntensityColor(precipitation.millimeters),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 12,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  precipitation.date,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Icon(
                                  Icons.location_on,
                                  size: 12,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  precipitation.city,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
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
                      onPressed: () => _showPrecipitationForm(context, precipitation),
                      color: Colors.blue.shade600,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      onPressed: () => _deletePrecipitation(precipitation.id),
                      color: Colors.red.shade400,
                    ),
                  ],
                ),
              ],
            ),
            if (precipitation.observations.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.description,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      precipitation.observations,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getIntensityIcon(double mm) {
    if (mm < 5) {
      return Icons.grain;
    } else if (mm < 15) {
      return Icons.water_drop;
    } else if (mm < 25) {
      return Icons.umbrella;
    } else {
      return Icons.thunderstorm;
    }
  }

  Color _getIntensityColor(double mm) {
    if (mm < 5) {
      return Colors.green.shade400;
    } else if (mm < 15) {
      return Colors.blue.shade400;
    } else if (mm < 25) {
      return Colors.orange.shade400;
    } else {
      return Colors.red.shade400;
    }
  }

  String _getIntensityLabel(double mm) {
    if (mm < 5) {
      return 'Leve';
    } else if (mm < 15) {
      return 'Moderada';
    } else if (mm < 25) {
      return 'Forte';
    } else {
      return 'Intensa';
    }
  }

  void _showPrecipitationForm(BuildContext context, PrecipitationItem? precipitation) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return PrecipitationFormModal(
          precipitation: precipitation,
          onSave: (newPrecipitation) {
            setState(() {
              if (precipitation == null) {
                precipitations.add(newPrecipitation);
              } else {
                final index = precipitations.indexWhere((p) => p.id == precipitation.id);
                if (index != -1) {
                  precipitations[index] = newPrecipitation;
                }
              }
            });
          },
        );
      },
    );
  }

  void _deletePrecipitation(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir Registro'),
          content: const Text('Tem certeza que deseja excluir este registro de precipitação?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  precipitations.removeWhere((p) => p.id == id);
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

// MODAL DE FORMULÁRIO - PRECIPITAÇÕES
class PrecipitationFormModal extends StatefulWidget {
  final PrecipitationItem? precipitation;
  final Function(PrecipitationItem) onSave;

  const PrecipitationFormModal({
    super.key,
    this.precipitation,
    required this.onSave,
  });

  @override
  State<PrecipitationFormModal> createState() => _PrecipitationFormModalState();
}

class _PrecipitationFormModalState extends State<PrecipitationFormModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _millimetersController;
  late TextEditingController _dateController;
  late TextEditingController _cityController;
  late TextEditingController _observationsController;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.precipitation != null;
    _millimetersController = TextEditingController(
      text: widget.precipitation?.millimeters.toString() ?? '',
    );
    _dateController = TextEditingController(text: widget.precipitation?.date ?? '');
    _cityController = TextEditingController(text: widget.precipitation?.city ?? '');
    _observationsController = TextEditingController(text: widget.precipitation?.observations ?? '');
  }

  @override
  void dispose() {
    _millimetersController.dispose();
    _dateController.dispose();
    _cityController.dispose();
    _observationsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
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
              color: Colors.blue.shade700,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isEditing ? 'Editar Precipitação' : 'Nova Precipitação',
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
                      label: 'Milímetros',
                      controller: _millimetersController,
                      icon: Icons.water_drop,
                      hint: 'Ex: 15.5',
                      keyboardType: TextInputType.number,
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
                      label: 'Cidade',
                      controller: _cityController,
                      icon: Icons.location_on,
                      hint: 'Ex: São Paulo',
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Observações',
                      controller: _observationsController,
                      icon: Icons.description,
                      hint: 'Observações adicionais',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 32),
                    
                    // Botão Salvar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _savePrecipitation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
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
    TextInputType? keyboardType,
    int maxLines = 1,
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
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.blue.shade700,
            fontWeight: FontWeight.w600,
          ),
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.blue.shade700),
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
          if (label == 'Milímetros' && double.tryParse(value) == null) {
            return 'Digite um número válido';
          }
          if (label == 'Milímetros' && double.tryParse(value) != null && double.parse(value) < 0) {
            return 'Digite um valor positivo';
          }
          return null;
        },
      ),
    );
  }

  void _savePrecipitation() {
    if (_formKey.currentState!.validate()) {
      final newPrecipitation = PrecipitationItem(
        id: widget.precipitation?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        millimeters: double.parse(_millimetersController.text),
        date: _dateController.text,
        city: _cityController.text,
        observations: _observationsController.text,
      );
      
      widget.onSave(newPrecipitation);
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing ? 'Precipitação atualizada com sucesso!' : 'Precipitação criada com sucesso!',
          ),
          backgroundColor: Colors.blue.shade700,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}