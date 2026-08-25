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
      title: 'Características Climáticas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: VerdeEscuro),
        useMaterial3: true,
      ),
      home: const ClimasPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// MODELO DE DADOS
class ClimateItem {
  final String id;
  final String talhao;
  final String fazenda;
  final String temperatura;
  final String umidade;
  final String vento;
  final String precipitacao;
  final String data;
  final String condicao;

  ClimateItem({
    required this.id,
    required this.talhao,
    required this.fazenda,
    required this.temperatura,
    required this.umidade,
    required this.vento,
    required this.precipitacao,
    required this.data,
    required this.condicao,
  });

  ClimateItem copyWith({
    String? id,
    String? talhao,
    String? fazenda,
    String? temperatura,
    String? umidade,
    String? vento,
    String? precipitacao,
    String? data,
    String? condicao,
  }) {
    return ClimateItem(
      id: id ?? this.id,
      talhao: talhao ?? this.talhao,
      fazenda: fazenda ?? this.fazenda,
      temperatura: temperatura ?? this.temperatura,
      umidade: umidade ?? this.umidade,
      vento: vento ?? this.vento,
      precipitacao: precipitacao ?? this.precipitacao,
      data: data ?? this.data,
      condicao: condicao ?? this.condicao,
    );
  }
}

class ClimasPage extends StatefulWidget {
  const ClimasPage({super.key});

  @override
  State<ClimasPage> createState() => _ClimasPageState();
}

class _ClimasPageState extends State<ClimasPage> {
  List<ClimateItem> climateData = [
    ClimateItem(
      id: '1',
      talhao: 'Talhão 1',
      fazenda: 'Fazenda Principal',
      temperatura: '23',
      umidade: '76',
      vento: '3.2',
      precipitacao: '12',
      data: '24/08/2026',
      condicao: 'Ensolarado',
    ),
    ClimateItem(
      id: '2',
      talhao: 'Talhão 2',
      fazenda: 'Fazenda Principal',
      temperatura: '21',
      umidade: '82',
      vento: '4.1',
      precipitacao: '8',
      data: '24/08/2026',
      condicao: 'Nublado',
    ),
    ClimateItem(
      id: '3',
      talhao: 'Talhão 3',
      fazenda: 'Fazenda Secundária',
      temperatura: '19',
      umidade: '88',
      vento: '2.8',
      precipitacao: '15',
      data: '24/08/2026',
      condicao: 'Chuvoso',
    ),
    ClimateItem(
      id: '4',
      talhao: 'Talhão 4',
      fazenda: 'Fazenda Secundária',
      temperatura: '25',
      umidade: '65',
      vento: '5.0',
      precipitacao: '0',
      data: '24/08/2026',
      condicao: 'Ensolarado',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Bege,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Características climáticas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: VerdeEscuro,
        foregroundColor: Bege,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
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
                // Cabeçalho
                _buildHeader(),
                const SizedBox(height: 16),

                // Cards dos dados climáticos
                Expanded(
                  child: ListView.builder(
                    itemCount: climateData.length,
                    itemBuilder: (context, index) {
                      final climate = climateData[index];
                      return _buildClimateCard(climate, index);
                    },
                  ),
                ),

                // Rodapé com estatísticas
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showClimateForm(context, null),
        backgroundColor: VerdeEscuro,
        foregroundColor: Bege,
        child: const Icon(Icons.add, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: BegeClaro,
        borderRadius: BorderRadius.circular(12),
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
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.wb_sunny,
              color: VerdeEscuro,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Características - ${climateData.isNotEmpty ? climateData[0].talhao : 'Sem dados'}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 14,
                    color: VerdeEscuro,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    climateData.isNotEmpty ? climateData[0].fazenda : 'Sem dados',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  VerdeEscuro,
                  VerdeClaro,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.wifi,
                  color: BegeClaro,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  'Online',
                  style: TextStyle(
                    color: BegeClaro,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClimateCard(ClimateItem climate, int index) {
    return Card(
      color: BegeClaro,
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
                    _getConditionIcon(climate.condicao),
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
                        climate.talhao,
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
                            climate.fazenda,
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
                    color: _getConditionColor(climate.condicao),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    climate.condicao,
                    style: TextStyle(
                      color: Bege,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 8),

            // Informações climáticas em chips
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _buildInfoChip(Icons.calendar_today, climate.data),
                _buildInfoChip(Icons.thermostat, '${climate.temperatura}°C'),
                _buildInfoChip(Icons.water_drop, '${climate.umidade}%'),
                _buildInfoChip(Icons.air, '${climate.vento} m/s'),
                _buildInfoChip(Icons.umbrella, '${climate.precipitacao} mm'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _showClimateForm(context, climate),
                      color: VerdeClaro,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      onPressed: () => _deleteClimate(climate.id),
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

  Widget _buildFooter() {
    return Container(
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
            'Total de Registros Climáticos',
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
              '${climateData.length}',
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

  IconData _getConditionIcon(String condition) {
    if (condition.toLowerCase().contains('ensolarado') || 
        condition.toLowerCase().contains('sol')) {
      return Icons.wb_sunny;
    } else if (condition.toLowerCase().contains('nublado') || 
               condition.toLowerCase().contains('nuvem')) {
      return Icons.cloud;
    } else if (condition.toLowerCase().contains('chuvoso') || 
               condition.toLowerCase().contains('chuva')) {
      return Icons.water_drop;
    } else {
      return Icons.wb_cloudy;
    }
  }

  Color _getConditionColor(String condition) {
    if (condition.toLowerCase().contains('ensolarado') || 
        condition.toLowerCase().contains('sol')) {
      return Colors.orange;
    } else if (condition.toLowerCase().contains('nublado') || 
               condition.toLowerCase().contains('nuvem')) {
      return Colors.grey;
    } else if (condition.toLowerCase().contains('chuvoso') || 
               condition.toLowerCase().contains('chuva')) {
      return Colors.blue;
    } else {
      return VerdeEscuro;
    }
  }

  void _showClimateForm(
    BuildContext context,
    ClimateItem? climate,
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
            child: ClimateFormModal(
              climate: climate,
              onSave: (newClimate) {
                setState(() {
                  if (climate == null) {
                    climateData.add(newClimate);
                  } else {
                    final index = climateData.indexWhere(
                      (c) => c.id == climate.id,
                    );
                    if (index != -1) {
                      climateData[index] = newClimate;
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

  void _deleteClimate(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir Registro'),
          content: const Text('Tem certeza que deseja excluir este registro climático?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  climateData.removeWhere((c) => c.id == id);
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

// MODAL DE FORMULÁRIO - DADOS CLIMÁTICOS
class ClimateFormModal extends StatefulWidget {
  final ClimateItem? climate;
  final Function(ClimateItem) onSave;

  const ClimateFormModal({
    super.key,
    this.climate,
    required this.onSave,
  });

  @override
  State<ClimateFormModal> createState() => _ClimateFormModalState();
}

class _ClimateFormModalState extends State<ClimateFormModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _talhaoController;
  late TextEditingController _fazendaController;
  late TextEditingController _temperaturaController;
  late TextEditingController _umidadeController;
  late TextEditingController _ventoController;
  late TextEditingController _precipitacaoController;
  late TextEditingController _dataController;
  late TextEditingController _condicaoController;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.climate != null;
    _talhaoController = TextEditingController(
      text: widget.climate?.talhao ?? '',
    );
    _fazendaController = TextEditingController(
      text: widget.climate?.fazenda ?? '',
    );
    _temperaturaController = TextEditingController(
      text: widget.climate?.temperatura ?? '',
    );
    _umidadeController = TextEditingController(
      text: widget.climate?.umidade ?? '',
    );
    _ventoController = TextEditingController(
      text: widget.climate?.vento ?? '',
    );
    _precipitacaoController = TextEditingController(
      text: widget.climate?.precipitacao ?? '',
    );
    _dataController = TextEditingController(
      text: widget.climate?.data ?? '',
    );
    _condicaoController = TextEditingController(
      text: widget.climate?.condicao ?? '',
    );
  }

  @override
  void dispose() {
    _talhaoController.dispose();
    _fazendaController.dispose();
    _temperaturaController.dispose();
    _umidadeController.dispose();
    _ventoController.dispose();
    _precipitacaoController.dispose();
    _dataController.dispose();
    _condicaoController.dispose();
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
                  _isEditing ? 'Editar Dados Climáticos' : 'Novo Registro',
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
                      label: 'Talhão',
                      controller: _talhaoController,
                      icon: Icons.crop,
                      hint: 'Ex: Talhão 1',
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Fazenda',
                      controller: _fazendaController,
                      icon: Icons.store,
                      hint: 'Ex: Fazenda Principal',
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Temperatura (°C)',
                      controller: _temperaturaController,
                      icon: Icons.thermostat,
                      hint: 'Ex: 23',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Umidade (%)',
                      controller: _umidadeController,
                      icon: Icons.water_drop,
                      hint: 'Ex: 76',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Vento (m/s)',
                      controller: _ventoController,
                      icon: Icons.air,
                      hint: 'Ex: 3.2',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Precipitação (mm)',
                      controller: _precipitacaoController,
                      icon: Icons.umbrella,
                      hint: 'Ex: 12',
                      keyboardType: TextInputType.number,
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
                      label: 'Condição Climática',
                      controller: _condicaoController,
                      icon: Icons.wb_sunny,
                      hint: 'Ex: Ensolarado, Nublado, Chuvoso',
                    ),
                    const SizedBox(height: 24),

                    // Botão Salvar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveClimate,
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
    TextInputType? keyboardType,
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

  void _saveClimate() {
    if (_formKey.currentState!.validate()) {
      final newClimate = ClimateItem(
        id:
            widget.climate?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        talhao: _talhaoController.text,
        fazenda: _fazendaController.text,
        temperatura: _temperaturaController.text,
        umidade: _umidadeController.text,
        vento: _ventoController.text,
        precipitacao: _precipitacaoController.text,
        data: _dataController.text,
        condicao: _condicaoController.text,
      );

      widget.onSave(newClimate);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Registro atualizado com sucesso!'
                : 'Registro criado com sucesso!',
          ),
          backgroundColor: VerdeEscuro,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}