import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plantio',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const PlantioPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// TELA PRINCIPAL - PLANTIO
class PlantioPage extends StatefulWidget {
  const PlantioPage({super.key});

  @override
  State<PlantioPage> createState() => _PlantioPageState();
}

class _PlantioPageState extends State<PlantioPage> {
  List<PlantingItem> plantings = [
    PlantingItem(
      id: '1',
      crop: 'Soja',
      date: '20/09/25',
      variety: 'BR 123',
      fertilizer: 'NPK 10-10-10',
      inoculant: 'Sim',
      seeds: '2.500 kg',
    ),
    PlantingItem(
      id: '2',
      crop: 'Milho',
      date: '15/01/26',
      variety: 'Híbrido X',
      fertilizer: 'Ureia',
      inoculant: 'Não',
      seeds: '3.200 kg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Plantio - Talhão 1',
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
            icon: const Icon(Icons.search),
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
            // Cabeçalho com resumo
            _buildHeader(),
            
            // Lista de plantios
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: plantings.length,
                itemBuilder: (context, index) {
                  return _buildPlantingCard(plantings[index]);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPlantingForm(context, null),
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
          _buildStatItem(Icons.eco, 'Culturas', '${plantings.length}'),
          _buildStatItem(Icons.calendar_today, 'Plantios', '2025/26'),
          _buildStatItem(Icons.terrain, 'Área Total', '45,6 ha'),
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

  Widget _buildPlantingCard(PlantingItem planting) {
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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        planting.crop == 'Soja' ? Icons.eco : Icons.grass,
                        color: Colors.green.shade700,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          planting.crop,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Data: ${planting.date}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _showPlantingForm(context, planting),
                      color: Colors.blue.shade600,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      onPressed: () => _deletePlanting(planting.id),
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
                _buildChip(Icons.science, 'Variedade: ${planting.variety}'),
                _buildChip(Icons.agriculture, 'Adubo: ${planting.fertilizer}'),
                _buildChip(Icons.biotech, 'Inoculante: ${planting.inoculant}'),
                _buildChip(Icons.grain, 'Sementes: ${planting.seeds}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(IconData icon, String label) {
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
          ),
        ],
      ),
    );
  }

  void _showPlantingForm(BuildContext context, PlantingItem? planting) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return PlantingFormModal(
          planting: planting,
          onSave: (newPlanting) {
            setState(() {
              if (planting == null) {
                plantings.add(newPlanting);
              } else {
                final index = plantings.indexWhere((p) => p.id == planting.id);
                if (index != -1) {
                  plantings[index] = newPlanting;
                }
              }
            });
          },
        );
      },
    );
  }

  void _deletePlanting(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir Plantio'),
          content: const Text('Tem certeza que deseja excluir este plantio?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  plantings.removeWhere((p) => p.id == id);
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

// MODELO DE DADOS
class PlantingItem {
  final String id;
  final String crop;
  final String date;
  final String variety;
  final String fertilizer;
  final String inoculant;
  final String seeds;

  PlantingItem({
    required this.id,
    required this.crop,
    required this.date,
    required this.variety,
    required this.fertilizer,
    required this.inoculant,
    required this.seeds,
  });

  PlantingItem copyWith({
    String? id,
    String? crop,
    String? date,
    String? variety,
    String? fertilizer,
    String? inoculant,
    String? seeds,
  }) {
    return PlantingItem(
      id: id ?? this.id,
      crop: crop ?? this.crop,
      date: date ?? this.date,
      variety: variety ?? this.variety,
      fertilizer: fertilizer ?? this.fertilizer,
      inoculant: inoculant ?? this.inoculant,
      seeds: seeds ?? this.seeds,
    );
  }
}

// MODAL DE FORMULÁRIO (TELA VERDE)
class PlantingFormModal extends StatefulWidget {
  final PlantingItem? planting;
  final Function(PlantingItem) onSave;

  const PlantingFormModal({
    super.key,
    this.planting,
    required this.onSave,
  });

  @override
  State<PlantingFormModal> createState() => _PlantingFormModalState();
}

class _PlantingFormModalState extends State<PlantingFormModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _cropController;
  late TextEditingController _dateController;
  late TextEditingController _varietyController;
  late TextEditingController _fertilizerController;
  late TextEditingController _inoculantController;
  late TextEditingController _seedsController;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.planting != null;
    _cropController = TextEditingController(text: widget.planting?.crop ?? '');
    _dateController = TextEditingController(text: widget.planting?.date ?? '');
    _varietyController = TextEditingController(text: widget.planting?.variety ?? '');
    _fertilizerController = TextEditingController(text: widget.planting?.fertilizer ?? '');
    _inoculantController = TextEditingController(text: widget.planting?.inoculant ?? '');
    _seedsController = TextEditingController(text: widget.planting?.seeds ?? '');
  }

  @override
  void dispose() {
    _cropController.dispose();
    _dateController.dispose();
    _varietyController.dispose();
    _fertilizerController.dispose();
    _inoculantController.dispose();
    _seedsController.dispose();
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
                  _isEditing ? 'Editar Plantio' : 'Novo Plantio',
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
                      label: 'Planta de Cultivo',
                      controller: _cropController,
                      icon: Icons.eco,
                      hint: 'Ex: Soja, Milho, Café',
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
                      label: 'Variedade',
                      controller: _varietyController,
                      icon: Icons.science,
                      hint: 'Ex: BR 123, Híbrido X',
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Adubo',
                      controller: _fertilizerController,
                      icon: Icons.agriculture,
                      hint: 'Ex: NPK, Ureia',
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Inoculante',
                      controller: _inoculantController,
                      icon: Icons.biotech,
                      hint: 'Sim / Não / Tipo',
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Sementes',
                      controller: _seedsController,
                      icon: Icons.grain,
                      hint: 'Ex: 2.500 kg',
                    ),
                    const SizedBox(height: 32),
                    
                    // Botão Salvar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _savePlanting,
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

  void _savePlanting() {
    if (_formKey.currentState!.validate()) {
      final newPlanting = PlantingItem(
        id: widget.planting?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        crop: _cropController.text,
        date: _dateController.text,
        variety: _varietyController.text,
        fertilizer: _fertilizerController.text,
        inoculant: _inoculantController.text,
        seeds: _seedsController.text,
      );
      
      widget.onSave(newPlanting);
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing ? 'Plantio atualizado com sucesso!' : 'Plantio criado com sucesso!',
          ),
          backgroundColor: Colors.green.shade700,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}