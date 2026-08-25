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
      title: 'Manejo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: VerdeEscuro),
        useMaterial3: true,
      ),
      home: const ManejosPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// MODELO DE DADOS
class ManejoItem {
  final String id;
  final String pratica;
  final String date;
  final String motivo;
  final String fazenda;
  final String talhao;

  ManejoItem({
    required this.id,
    required this.pratica,
    required this.date,
    required this.motivo,
    required this.fazenda,
    required this.talhao,
  });

  ManejoItem copyWith({
    String? id,
    String? pratica,
    String? date,
    String? motivo,
    String? fazenda,
    String? talhao,
  }) {
    return ManejoItem(
      id: id ?? this.id,
      pratica: pratica ?? this.pratica,
      date: date ?? this.date,
      motivo: motivo ?? this.motivo,
      fazenda: fazenda ?? this.fazenda,
      talhao: talhao ?? this.talhao,
    );
  }
}

class ManejosPage extends StatefulWidget {
  const ManejosPage({super.key});

  @override
  State<ManejosPage> createState() => _ManejosPageState();
}

class _ManejosPageState extends State<ManejosPage> {
  List<ManejoItem> manejos = [
    ManejoItem(
      id: '1',
      pratica: 'Correção de solo',
      date: '12/08/25',
      motivo: 'Solo com baixo pH',
      fazenda: 'Fazenda 1',
      talhao: 'Talhão 1',
    ),
    ManejoItem(
      id: '2',
      pratica: 'Subsolação',
      date: '15/01/26',
      motivo: 'Compactação do solo',
      fazenda: 'Fazenda 1',
      talhao: 'Talhão 1',
    ),
    ManejoItem(
      id: '3',
      pratica: 'Calagem',
      date: '20/02/26',
      motivo: 'Neutralizar acidez',
      fazenda: 'Fazenda 1',
      talhao: 'Talhão 1',
    ),
  ];

  // Cálculo de estatísticas
  int get totalPraticas => manejos.length;
  String get ultimaData {
    if (manejos.isEmpty) return '--';
    final sorted = List<ManejoItem>.from(manejos)
      ..sort((a, b) => _parseDate(b.date).compareTo(_parseDate(a.date)));
    return sorted.first.date;
  }

  DateTime _parseDate(String date) {
    try {
      final parts = date.split('/');
      if (parts.length == 3) {
        return DateTime(
          int.parse('20${parts[2]}'),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      }
      return DateTime(2000, 1, 1);
    } catch (e) {
      return DateTime(2000, 1, 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Bege,
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
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.agriculture, size: 45, color: VerdeClaro),
                      const SizedBox(width: 10),
                      Text(
                        'Manejos',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w600,
                          color: VerdeClaro,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Cards das práticas de manejo
                Expanded(
                  child: ListView.builder(
                    itemCount: manejos.length,
                    itemBuilder: (context, index) {
                      final manejo = manejos[index];
                      return _buildManejoCard(manejo, index);
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
                        'Total de Manejos',
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
                          '${manejos.length}',
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
        onPressed: () => _showManejoForm(context, null),
        backgroundColor: VerdeEscuro,
        foregroundColor: Bege,
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: VerdeEscuro, size: 22),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: VerdeEscuro,
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

  Widget _buildManejoCard(ManejoItem manejo, int index) {
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
            // Linha superior com ícone, título e status
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
                    _getPraticaIcon(manejo.pratica),
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
                        manejo.pratica,
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
                            '${manejo.fazenda} - ${manejo.talhao}',
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
                      fontSize: 11,
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
                      _buildInfoChip(Icons.calendar_today, manejo.date),
                      _buildInfoChip(Icons.description, manejo.motivo),
                    ],
                  ),
                ),
                // Ícones de ação no canto direito
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _showManejoForm(context, manejo),
                      color: VerdeClaro,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 15),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      onPressed: () => _deleteManejo(manejo.id),
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

  IconData _getPraticaIcon(String pratica) {
    if (pratica.toLowerCase().contains('correção')) {
      return Icons.science;
    } else if (pratica.toLowerCase().contains('subsolação')) {
      return Icons.water_drop;
    } else if (pratica.toLowerCase().contains('calagem')) {
      return Icons.grass;
    } else {
      return Icons.agriculture;
    }
  }

  void _showManejoForm(
    BuildContext context,
    ManejoItem? manejo,
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
            child: ManejoFormModal(
              manejo: manejo,
              onSave: (newManejo) {
                setState(() {
                  if (manejo == null) {
                    manejos.add(newManejo);
                  } else {
                    final index = manejos.indexWhere(
                      (a) => a.id == manejo.id,
                    );
                    if (index != -1) {
                      manejos[index] = newManejo;
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

  void _deleteManejo(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir Prática'),
          content: const Text('Tem certeza que deseja excluir esta prática de manejo?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  manejos.removeWhere((a) => a.id == id);
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
class ManejoFormModal extends StatefulWidget {
  final ManejoItem? manejo;
  final Function(ManejoItem) onSave;

  const ManejoFormModal({
    super.key,
    this.manejo,
    required this.onSave,
  });

  @override
  State<ManejoFormModal> createState() => _ManejoFormModalState();
}

class _ManejoFormModalState extends State<ManejoFormModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _praticaController;
  late TextEditingController _dateController;
  late TextEditingController _motivoController;
  late TextEditingController _fazendaController;
  late TextEditingController _talhaoController;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.manejo != null;
    _praticaController = TextEditingController(
      text: widget.manejo?.pratica ?? '',
    );
    _dateController = TextEditingController(
      text: widget.manejo?.date ?? '',
    );
    _motivoController = TextEditingController(
      text: widget.manejo?.motivo ?? '',
    );
    _fazendaController = TextEditingController(
      text: widget.manejo?.fazenda ?? '',
    );
    _talhaoController = TextEditingController(
      text: widget.manejo?.talhao ?? '',
    );
  }

  @override
  void dispose() {
    _praticaController.dispose();
    _dateController.dispose();
    _motivoController.dispose();
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
                  _isEditing ? 'Editar Manejo' : 'Novo Manejo',
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
                      label: 'Tipo de Manejo',
                      controller: _praticaController,
                      icon: Icons.agriculture,
                      hint: 'Ex: Correção de solo, Calagem',
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
                      controller: _motivoController,
                      icon: Icons.description,
                      hint: 'Motivo da prática',
                    ),
                    const SizedBox(height: 24),

                    // Botão Salvar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveManejo,
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

  void _saveManejo() {
    if (_formKey.currentState!.validate()) {
      final newManejo = ManejoItem(
        id: widget.manejo?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        pratica: _praticaController.text,
        date: _dateController.text,
        motivo: _motivoController.text,
        fazenda: _fazendaController.text,
        talhao: _talhaoController.text,
      );

      widget.onSave(newManejo);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Prática de manejo atualizada com sucesso!'
                : 'Prática de manejo criada com sucesso!',
          ),
          backgroundColor: VerdeEscuro,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}