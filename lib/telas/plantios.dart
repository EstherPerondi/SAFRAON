import 'package:flutter/material.dart';
import 'package:safraon/variaveis.dart'; // Mantendo a mesma importação

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
        colorScheme: ColorScheme.fromSeed(seedColor: VerdeEscuro),
        useMaterial3: true,
      ),
      home: const PlantiosPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// MODELO DE DADOS
class PlantioItem {
  final String id;
  final String cultura;
  final String data;
  final String variedade;
  final String adubo;
  final String inoculante;
  final String sementes;
  final String fazenda;
  final String talhao;

  PlantioItem({
    required this.id,
    required this.cultura,
    required this.data,
    required this.variedade,
    required this.adubo,
    required this.inoculante,
    required this.sementes,
    required this.fazenda,
    required this.talhao,
  });

  PlantioItem copyWith({
    String? id,
    String? cultura,
    String? data,
    String? variedade,
    String? adubo,
    String? inoculante,
    String? sementes,
    String? fazenda,
    String? talhao,
  }) {
    return PlantioItem(
      id: id ?? this.id,
      cultura: cultura ?? this.cultura,
      data: data ?? this.data,
      variedade: variedade ?? this.variedade,
      adubo: adubo ?? this.adubo,
      inoculante: inoculante ?? this.inoculante,
      sementes: sementes ?? this.sementes,
      fazenda: fazenda ?? this.fazenda,
      talhao: talhao ?? this.talhao,
    );
  }
}

class PlantiosPage extends StatefulWidget {
  const PlantiosPage({super.key});

  @override
  State<PlantiosPage> createState() => _PlantiosPageState();
}

class _PlantiosPageState extends State<PlantiosPage> {
  List<PlantioItem> plantios = [
    PlantioItem(
      id: '1',
      cultura: 'Soja',
      data: '20/09/25',
      variedade: 'BR 123',
      adubo: 'NPK 10-10-10',
      inoculante: 'Sim',
      sementes: '2.500 kg',
      fazenda: 'Fazenda 1',
      talhao: 'Talhão 1',
    ),
    PlantioItem(
      id: '2',
      cultura: 'Milho',
      data: '15/01/26',
      variedade: 'Hibrido X',
      adubo: 'Ureia',
      inoculante: 'Não',
      sementes: '3.200 kg',
      fazenda: 'Fazenda 1',
      talhao: 'Talhão 2',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Bege,
      appBar: AppBar(
        backgroundColor: VerdeEscuro, // Mesma cor do fundo da imagem
        iconTheme: IconThemeData(color: BegeClaro), // Cor da seta (Bege)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Ação de voltar
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(
              image: AssetImage('Imagens/ICONE_PLANTIO.png'),
              width: 35,
              height: 35,
              fit: BoxFit.cover,
              color: BegeClaro,
            ),
            const SizedBox(width: 8),
            Text(
              'Plantios',
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
      body: Center(
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
                Expanded(
                  child: ListView.builder(
                    itemCount: plantios.length,
                    itemBuilder: (context, index) {
                      final plantio = plantios[index];
                      return _buildPlantioCard(plantio, index);
                    },
                  ),
                ),

                // Rodapé com total de plantios
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: VerdeEscuro, // Mesma cor do original
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total de Plantios',
                        style: TextStyle(
                          color: Bege, // Mesma cor do original
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
                          color: Bege, // Mesma cor do original
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '${plantios.length}',
                          style: TextStyle(
                            color: VerdeEscuro, // Mesma cor do original
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPlantioForm(context, null),
        backgroundColor: VerdeEscuro, // Mesma cor do original
        foregroundColor: Bege, // Mesma cor do original
        child: const Icon(Icons.add, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: VerdeClaro.withOpacity(0.1), // Mesmo estilo do original
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: VerdeClaro.withOpacity(0.3), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: VerdeEscuro), // Mesma cor
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: VerdeEscuro, // Mesma cor
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantioCard(PlantioItem plantio, int index) {
    return Card(
      color: Colors.orange[50], // MESMA COR DO CARD ORIGINAL
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Linha superior com ícone, título e número - IGUAL AO ORIGINAL
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.green[100], // Mesma cor
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getCulturaIcon(plantio.cultura),
                    color: VerdeEscuro, // Mesma cor
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plantio.cultura,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 14, color: VerdeClaro),
                          const SizedBox(width: 4),
                          Text(
                            '${plantio.fazenda} - ${plantio.talhao}',
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: VerdeClaro, // Mesma cor
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: Bege, // Mesma cor
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 8),

            // Informações em chips com ícones de ação - IGUAL AO ORIGINAL
            Row(
              children: [
                // Chips de informações
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _buildInfoChip(Icons.calendar_today, 'Data: ${plantio.data}'),
                      _buildInfoChip(Icons.science, 'Variedade: ${plantio.variedade}'),
                      _buildInfoChip(Icons.agriculture, plantio.adubo),
                      _buildInfoChip(Icons.biotech, 'Inoculante: ${plantio.inoculante}'),
                      _buildInfoChip(Icons.grain, 'Sementes: ${plantio.sementes}'),
                    ],
                  ),
                ),
                // Ícones de ação - IGUAL AO ORIGINAL
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _showPlantioForm(context, plantio),
                      color: VerdeClaro, // Mesma cor
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 15),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      onPressed: () => _deletePlantio(plantio.id),
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
        color: VerdeClaro.withOpacity(0.1), // Mesmo estilo do original
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: VerdeEscuro), // Mesma cor
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
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

  IconData _getCulturaIcon(String cultura) {
    if (cultura.toLowerCase().contains('soja')) {
      return Icons.eco;
    } else if (cultura.toLowerCase().contains('milho')) {
      return Icons.grass;
    } else {
      return Icons.spa;
    }
  }

  void _showPlantioForm(
    BuildContext context,
    PlantioItem? plantio,
  ) {
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
            child: PlantioFormModal(
              plantio: plantio,
              onSave: (newPlantio) {
                setState(() {
                  if (plantio == null) {
                    plantios.add(newPlantio);
                  } else {
                    final index = plantios.indexWhere(
                      (a) => a.id == plantio.id,
                    );
                    if (index != -1) {
                      plantios[index] = newPlantio;
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

  void _deletePlantio(String id) {
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
                  plantios.removeWhere((a) => a.id == id);
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

// MODAL DE FORMULÁRIO - PLANTIO
class PlantioFormModal extends StatefulWidget {
  final PlantioItem? plantio;
  final Function(PlantioItem) onSave;

  const PlantioFormModal({
    super.key,
    this.plantio,
    required this.onSave,
  });

  @override
  State<PlantioFormModal> createState() => _PlantioFormModalState();
}

class _PlantioFormModalState extends State<PlantioFormModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _culturaController;
  late TextEditingController _dataController;
  late TextEditingController _variedadeController;
  late TextEditingController _aduboController;
  late TextEditingController _inoculanteController;
  late TextEditingController _sementesController;
  late TextEditingController _fazendaController;
  late TextEditingController _talhaoController;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.plantio != null;
    _culturaController = TextEditingController(
      text: widget.plantio?.cultura ?? '',
    );
    _dataController = TextEditingController(
      text: widget.plantio?.data ?? '',
    );
    _variedadeController = TextEditingController(
      text: widget.plantio?.variedade ?? '',
    );
    _aduboController = TextEditingController(
      text: widget.plantio?.adubo ?? '',
    );
    _inoculanteController = TextEditingController(
      text: widget.plantio?.inoculante ?? '',
    );
    _sementesController = TextEditingController(
      text: widget.plantio?.sementes ?? '',
    );
    _fazendaController = TextEditingController(
      text: widget.plantio?.fazenda ?? '',
    );
    _talhaoController = TextEditingController(
      text: widget.plantio?.talhao ?? '',
    );
  }

  @override
  void dispose() {
    _culturaController.dispose();
    _dataController.dispose();
    _variedadeController.dispose();
    _aduboController.dispose();
    _inoculanteController.dispose();
    _sementesController.dispose();
    _fazendaController.dispose();
    _talhaoController.dispose();
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
          // Header - IGUAL AO ORIGINAL
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: VerdeEscuro, // Mesma cor
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isEditing ? 'Editar Plantio' : 'Novo Plantio',
                  style: TextStyle(
                    color: Bege, // Mesma cor
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Bege), // Mesma cor
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
                      label: 'Fazenda',
                      controller: _fazendaController,
                      icon: Icons.store,
                      hint: 'Ex: Fazenda 1',
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Talhão',
                      controller: _talhaoController,
                      icon: Icons.crop,
                      hint: 'Ex: Talhão 1',
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Planta de Cultivo',
                      controller: _culturaController,
                      icon: Icons.eco,
                      hint: 'Ex: Soja, Milho',
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Data',
                      controller: _dataController,
                      icon: Icons.calendar_today,
                      hint: 'DD/MM/AA',
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Variedade',
                      controller: _variedadeController,
                      icon: Icons.science,
                      hint: 'Ex: BR 123',
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Adubo',
                      controller: _aduboController,
                      icon: Icons.agriculture,
                      hint: 'Ex: NPK 10-10-10',
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Inoculante',
                      controller: _inoculanteController,
                      icon: Icons.biotech,
                      hint: 'Sim / Não',
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Sementes',
                      controller: _sementesController,
                      icon: Icons.grain,
                      hint: 'Ex: 2.500 kg',
                    ),
                    const SizedBox(height: 24),

                    // Botão Salvar - IGUAL AO ORIGINAL
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _savePlantio,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: VerdeEscuro, // Mesma cor
                          foregroundColor: Bege, // Mesma cor
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
          labelStyle: TextStyle(color: VerdeClaro, fontWeight: FontWeight.w600), // Mesma cor
          hintText: hint,
          prefixIcon: Icon(icon, color: VerdeClaro), // Mesma cor
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

  void _savePlantio() {
    if (_formKey.currentState!.validate()) {
      final newPlantio = PlantioItem(
        id:
            widget.plantio?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        cultura: _culturaController.text,
        data: _dataController.text,
        variedade: _variedadeController.text,
        adubo: _aduboController.text,
        inoculante: _inoculanteController.text,
        sementes: _sementesController.text,
        fazenda: _fazendaController.text,
        talhao: _talhaoController.text,
      );

      widget.onSave(newPlantio);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Plantio atualizado com sucesso!'
                : 'Plantio criado com sucesso!',
          ),
          backgroundColor: VerdeEscuro, // Mesma cor
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}