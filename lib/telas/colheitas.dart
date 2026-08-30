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
      title: 'Colheitas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: VerdeEscuro),
        useMaterial3: true,
      ),
      home: const ColheitasPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// MODELO DE DADOS - COLHEITA
class ColheitaItem {
  final String id;
  final String crop;
  final String data;
  final double humidity;
  final double production;
  final String fazenda;
  final String talhao;

  ColheitaItem({
    required this.id,
    required this.crop,
    required this.data,
    required this.humidity,
    required this.production,
    required this.fazenda,
    required this.talhao,
  });

  ColheitaItem copyWith({
    String? id,
    String? crop,
    String? data,
    double? humidity,
    double? production,
    String? fazenda,
    String? talhao,
  }) {
    return ColheitaItem(
      id: id ?? this.id,
      crop: crop ?? this.crop,
      data: data ?? this.data,
      humidity: humidity ?? this.humidity,
      production: production ?? this.production,
      fazenda: fazenda ?? this.fazenda,
      talhao: talhao ?? this.talhao,
    );
  }
}

class ColheitasPage extends StatefulWidget {
  const ColheitasPage({super.key});

  @override
  State<ColheitasPage> createState() => _ColheitasPageState();
}

class _ColheitasPageState extends State<ColheitasPage> {
  List<ColheitaItem> colheitas = [
    ColheitaItem(
      id: '1',
      crop: 'Soja',
      data: '15/01/26',
      humidity: 14.5,
      production: 4200,
      fazenda: 'Fazenda 1',
      talhao: 'Talhão 1',
    ),
    ColheitaItem(
      id: '2',
      crop: 'Milho',
      data: '15/06/26',
      humidity: 12.0,
      production: 3800,
      fazenda: 'Fazenda 1',
      talhao: 'Talhão 2',
    ),
    ColheitaItem(
      id: '3',
      crop: 'Café',
      data: '10/07/26',
      humidity: 11.2,
      production: 2500,
      fazenda: 'Fazenda 2',
      talhao: 'Talhão 3',
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
              image: AssetImage('Imagens/ICONE_COLHEITA.png'),
              width: 35,
              height: 35,
              fit: BoxFit.cover,
              color: BegeClaro,
            ),
            const SizedBox(width: 8),
            Text(
              'Colheitas',
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
                    itemCount: colheitas.length,
                    itemBuilder: (context, index) {
                      final colheita = colheitas[index];
                      return _buildColheitaCard(colheita, index);
                    },
                  ),
                ),

                // Rodapé com estatísticas
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
                        'Total de Colheitas',
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
                          '${colheitas.length}',
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showColheitaForm(context, null),
        backgroundColor: VerdeEscuro,
        foregroundColor: Bege,
        child: const Icon(Icons.add, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildColheitaCard(ColheitaItem colheita, int index) {
    IconData _getcropIcon(String crop) {
      if (crop.toLowerCase().contains('soja')) {
        return Icons.eco;
      } else if (crop.toLowerCase().contains('milho')) {
        return Icons.grass;
      } else if (crop.toLowerCase().contains('café')) {
        return Icons.coffee;
      } else {
        return Icons.agriculture;
      }
    }

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
            // Linha superior com ícone, título e número
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
                    _getcropIcon(colheita.crop),
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
                        colheita.crop,
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
                            '${colheita.fazenda} - ${colheita.talhao}',
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
                    color: VerdeClaro,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: Bege,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 8),

            // Informações em chips com ícones de ação na mesma linha
            Row(
              children: [
                // Chips de informações - ocupam o espaço disponível
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _buildInfoChip(Icons.calendar_today, colheita.data),
                      _buildInfoChip(Icons.water_drop_outlined, '${colheita.humidity} %'),
                      _buildInfoChip(Icons.inbox, '${colheita.production} sacas'),
                    ],
                  ),
                ),
                // Ícones de ação no canto direito
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _showColheitaForm(context, colheita),
                      color: VerdeClaro,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 15),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      onPressed: () => _deleteColheita(colheita.id),
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

  void _showColheitaForm(
    BuildContext context,
    ColheitaItem? colheita,
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
            child: ColheitaFormModal(
              colheita: colheita,
              onSave: (novaColheita) {
                setState(() {
                  if (colheita == null) {
                    colheitas.add(novaColheita);
                  } else {
                    final index = colheitas.indexWhere(
                      (a) => a.id == colheita.id,
                    );
                    if (index != -1) {
                      colheitas[index] = novaColheita;
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

  void _deleteColheita(String id) {
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
                  colheitas.removeWhere((a) => a.id == id);
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

// MODAL DE FORMULÁRIO - COLHEITAS
class ColheitaFormModal extends StatefulWidget {
  final ColheitaItem? colheita;
  final Function(ColheitaItem) onSave;

  const ColheitaFormModal({
    super.key,
    this.colheita,
    required this.onSave,
  });

  @override
  State<ColheitaFormModal> createState() => _ColheitaFormModalState();
}

class _ColheitaFormModalState extends State<ColheitaFormModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _cropController;
  late TextEditingController _dataController;
  late TextEditingController _humidityController;
  late TextEditingController _productionController;
  late TextEditingController _fazendaController;
  late TextEditingController _talhaoController;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.colheita != null;
    _cropController = TextEditingController(
      text: widget.colheita?.crop ?? '',
    );
    _dataController = TextEditingController(
      text: widget.colheita?.data ?? '',
    );
    _humidityController = TextEditingController(
      text: widget.colheita?.humidity.toString() ?? '',
    );
    _productionController = TextEditingController(
      text: widget.colheita?.production.toString() ?? '',
    );
    _fazendaController = TextEditingController(
      text: widget.colheita?.fazenda ?? '',
    );
    _talhaoController = TextEditingController(
      text: widget.colheita?.talhao ?? '',
    );
  }

  @override
  void dispose() {
    _cropController.dispose();
    _dataController.dispose();
    _humidityController.dispose();
    _productionController.dispose();
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
                  _isEditing ? 'Editar Colheita' : 'Nova Colheita',
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
                      label: 'Planta',
                      controller: _cropController,
                      icon: Icons.eco,
                      hint: 'Ex: Soja, Milho, Café',
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Data',
                      controller: _dataController,
                      icon: Icons.calendar_today,
                      hint: 'DD/MM/AAAA',
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Produção (production)',
                      controller: _productionController,
                      icon: Icons.bar_chart,
                      hint: 'Ex: 4200',
                    ),
                    const SizedBox(height: 16),                                        
                    _buildFormField(
                      label: 'Umidade (%)',
                      controller: _humidityController,
                      icon: Icons.water_drop_outlined,
                      hint: 'Ex: 14.5',
                    ),                   
                    const SizedBox(height: 24),

                    // Botão Salvar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveColheita,
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
          if (value == null || value.isEmpty) {
            return 'Campo obrigatório';
          }
          return null;
        },
      ),
    );
  }

  void _saveColheita() {
    if (_formKey.currentState!.validate()) {
      final novaColheita = ColheitaItem(
        id: widget.colheita?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        crop: _cropController.text,
        data: _dataController.text,
        humidity: double.parse(_humidityController.text),
        production: double.parse(_productionController.text),
        fazenda: _fazendaController.text,
        talhao: _talhaoController.text,
      );

      widget.onSave(novaColheita);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Colheita atualizada com sucesso!'
                : 'Colheita criada com sucesso!',
          ),
          backgroundColor: VerdeEscuro,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}