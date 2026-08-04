import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Colheita',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const ColheitaPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// MODELO DE DADOS
class HarvestItem {
  final String id;
  final String crop;
  final String date;
  final double production;
  final String quality;
  final String observations;

  HarvestItem({
    required this.id,
    required this.crop,
    required this.date,
    required this.production,
    required this.quality,
    required this.observations,
  });

  HarvestItem copyWith({
    String? id,
    String? crop,
    String? date,
    double? production,
    String? quality,
    String? observations,
  }) {
    return HarvestItem(
      id: id ?? this.id,
      crop: crop ?? this.crop,
      date: date ?? this.date,
      production: production ?? this.production,
      quality: quality ?? this.quality,
      observations: observations ?? this.observations,
    );
  }
}

// TELA PRINCIPAL - COLHEITA
class ColheitaPage extends StatefulWidget {
  const ColheitaPage({super.key});

  @override
  State<ColheitaPage> createState() => _HarvestScreenState();
}

class _HarvestScreenState extends State<ColheitaPage> {
  List<HarvestItem> harvests = [
    HarvestItem(
      id: '1',
      crop: 'Soja',
      date: '15/01/26',
      production: 4200,
      quality: 'Excelente',
      observations: 'Produtividade acima da média',
    ),
    HarvestItem(
      id: '2',
      crop: 'Milho',
      date: '15/06/26',
      production: 3800,
      quality: 'Boa',
      observations: 'Colheita mecanizada',
    ),
    HarvestItem(
      id: '3',
      crop: 'Café',
      date: '10/07/26',
      production: 2500,
      quality: 'Ótima',
      observations: 'Café especial',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Colheita - Talhão 1',
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
            icon: const Icon(Icons.bar_chart),
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
                itemCount: harvests.length,
                itemBuilder: (context, index) {
                  return _buildHarvestCard(harvests[index]);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showHarvestForm(context, null),
        backgroundColor: Colors.green.shade700,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildHeader() {
    double totalProduction = harvests.fold(0, (sum, item) => sum + item.production);
    
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
            Icons.agriculture,
            'Colheitas',
            '${harvests.length}',
          ),
          _buildStatItem(
            Icons.bar_chart,
            'Total',
            '${totalProduction.toStringAsFixed(0)} kg',
          ),
          _buildStatItem(
            Icons.calendar_today,
            'Última',
            '10/07/26',
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

  Widget _buildHarvestCard(HarvestItem harvest) {
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
              Colors.orange.shade50,
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
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getCropIcon(harvest.crop),
                          color: Colors.orange.shade700,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              harvest.crop,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
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
                                  harvest.date,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _getQualityColor(harvest.quality).withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    harvest.quality,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: _getQualityColor(harvest.quality),
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
                      onPressed: () => _showHarvestForm(context, harvest),
                      color: Colors.blue.shade600,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      onPressed: () => _deleteHarvest(harvest.id),
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
                    Icons.bar_chart,
                    '${harvest.production.toStringAsFixed(0)} kg',
                    'Produção',
                  ),
                ),
                Expanded(
                  child: _buildInfoRow(
                    Icons.description,
                    harvest.observations,
                    'Observações',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCropIcon(String crop) {
    switch (crop.toLowerCase()) {
      case 'soja':
        return Icons.eco;
      case 'milho':
        return Icons.grass;
      case 'café':
        return Icons.local_cafe;
      case 'laranja':
        return Icons.circle;
      default:
        return Icons.agriculture;
    }
  }

  Color _getQualityColor(String quality) {
    switch (quality.toLowerCase()) {
      case 'excelente':
        return Colors.green.shade700;
      case 'ótima':
        return Colors.green.shade600;
      case 'boa':
        return Colors.blue.shade600;
      case 'regular':
        return Colors.orange.shade600;
      case 'ruim':
        return Colors.red.shade600;
      default:
        return Colors.grey.shade600;
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

  void _showHarvestForm(BuildContext context, HarvestItem? harvest) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return HarvestFormModal(
          harvest: harvest,
          onSave: (newHarvest) {
            setState(() {
              if (harvest == null) {
                harvests.add(newHarvest);
              } else {
                final index = harvests.indexWhere((h) => h.id == harvest.id);
                if (index != -1) {
                  harvests[index] = newHarvest;
                }
              }
            });
          },
        );
      },
    );
  }

  void _deleteHarvest(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir Colheita'),
          content: const Text('Tem certeza que deseja excluir esta colheita?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  harvests.removeWhere((h) => h.id == id);
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

// MODAL DE FORMULÁRIO - COLHEITA
class HarvestFormModal extends StatefulWidget {
  final HarvestItem? harvest;
  final Function(HarvestItem) onSave;

  const HarvestFormModal({
    super.key,
    this.harvest,
    required this.onSave,
  });

  @override
  State<HarvestFormModal> createState() => _HarvestFormModalState();
}

class _HarvestFormModalState extends State<HarvestFormModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _cropController;
  late TextEditingController _dateController;
  late TextEditingController _productionController;
  late TextEditingController _qualityController;
  late TextEditingController _observationsController;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.harvest != null;
    _cropController = TextEditingController(text: widget.harvest?.crop ?? '');
    _dateController = TextEditingController(text: widget.harvest?.date ?? '');
    _productionController = TextEditingController(
      text: widget.harvest?.production.toString() ?? '',
    );
    _qualityController = TextEditingController(text: widget.harvest?.quality ?? '');
    _observationsController = TextEditingController(text: widget.harvest?.observations ?? '');
  }

  @override
  void dispose() {
    _cropController.dispose();
    _dateController.dispose();
    _productionController.dispose();
    _qualityController.dispose();
    _observationsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
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
              color: Colors.orange.shade700,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isEditing ? 'Editar Colheita' : 'Nova Colheita',
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
                      label: 'Planta',
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
                      label: 'Produção (kg)',
                      controller: _productionController,
                      icon: Icons.bar_chart,
                      hint: 'Ex: 4200',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Qualidade',
                      controller: _qualityController,
                      icon: Icons.star,
                      hint: 'Ex: Excelente, Boa, Regular',
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
                        onPressed: _saveHarvest,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade700,
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
            color: Colors.orange.shade700,
            fontWeight: FontWeight.w600,
          ),
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.orange.shade700),
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
          if (label == 'Produção (kg)' && double.tryParse(value) == null) {
            return 'Digite um número válido';
          }
          return null;
        },
      ),
    );
  }

  void _saveHarvest() {
    if (_formKey.currentState!.validate()) {
      final newHarvest = HarvestItem(
        id: widget.harvest?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        crop: _cropController.text,
        date: _dateController.text,
        production: double.parse(_productionController.text),
        quality: _qualityController.text,
        observations: _observationsController.text,
      );
      
      widget.onSave(newHarvest);
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing ? 'Colheita atualizada com sucesso!' : 'Colheita criada com sucesso!',
          ),
          backgroundColor: Colors.orange.shade700,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}