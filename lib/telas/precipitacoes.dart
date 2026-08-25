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
      title: 'Precipitações',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: VerdeEscuro),
        useMaterial3: true,
      ),
      home: const PrecipitacoesPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// MODELO DE DADOS
class PrecipitacaoItem {
  final String id;
  final String quantidade;
  final String data;
  final String descricao;
  final String fazenda;
  final String talhao;

  PrecipitacaoItem({
    required this.id,
    required this.quantidade,
    required this.data,
    required this.descricao,
    required this.fazenda,
    required this.talhao,
  });

  PrecipitacaoItem copyWith({
    String? id,
    String? quantidade,
    String? data,
    String? descricao,
    String? fazenda,
    String? talhao,
  }) {
    return PrecipitacaoItem(
      id: id ?? this.id,
      quantidade: quantidade ?? this.quantidade,
      data: data ?? this.data,
      descricao: descricao ?? this.descricao,
      fazenda: fazenda ?? this.fazenda,
      talhao: talhao ?? this.talhao,
    );
  }
}

class PrecipitacoesPage extends StatefulWidget {
  const PrecipitacoesPage({super.key});

  @override
  State<PrecipitacoesPage> createState() => _PrecipitacoesPageState();
}

class _PrecipitacoesPageState extends State<PrecipitacoesPage> {
  List<PrecipitacaoItem> precipitacoes = [
    PrecipitacaoItem(
      id: '1',
      quantidade: '15 mm',
      data: '15/01/26',
      descricao: 'Chuva moderada',
      fazenda: 'Fazenda 1',
      talhao: 'Talhão 1',
    ),
    PrecipitacaoItem(
      id: '2',
      quantidade: '10 mm',
      data: '15/06/26',
      descricao: 'Chuva leve',
      fazenda: 'Fazenda 1',
      talhao: 'Talhão 2',
    ),
    PrecipitacaoItem(
      id: '3',
      quantidade: '25 mm',
      data: '20/02/26',
      descricao: 'Chuva intensa',
      fazenda: 'Fazenda 2',
      talhao: 'Talhão 3',
    ),
  ];

  // Cálculo dos totais
  int get totalPrecipitacao {
    int total = 0;
    for (var item in precipitacoes) {
      String numero = item.quantidade.replaceAll(' mm', '');
      total += int.parse(numero);
    }
    return total;
  }

  double get mediaPrecipitacao {
    if (precipitacoes.isEmpty) return 0;
    return totalPrecipitacao / precipitacoes.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Bege, // Mesma cor do original
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
                      Icon(
                        Icons.water_drop,
                        size: 45,
                        color: VerdeClaro,
                      ), // Mesma cor
                      const SizedBox(width: 10),
                      Text(
                        'Precipitações',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w600,
                          color: VerdeClaro, // Mesma cor do original
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Cards das precipitações
                Expanded(
                  child: ListView.builder(
                    itemCount: precipitacoes.length,
                    itemBuilder: (context, index) {
                      final precipitacao = precipitacoes[index];
                      return _buildPrecipitacaoCard(precipitacao, index);
                    },
                  ),
                ),

                // Rodapé com total de registros
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
                        'Total de Precipitações',
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
                          color: Bege, // Mesma cor do original
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '${precipitacoes.length}',
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
        onPressed: () => _showPrecipitacaoForm(context, null),
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
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: VerdeClaro.withOpacity(0.1), 
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

  Widget _buildPrecipitacaoCard(PrecipitacaoItem precipitacao, int index) {
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
            // Linha superior com ícone, título e número - IGUAL AO ORIGINAL
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.green[100], // Mesma cor do original
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.water_drop,
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
                        precipitacao.quantidade,
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
                            '${precipitacao.fazenda} - ${precipitacao.talhao}',
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
                      _buildInfoChip(Icons.calendar_today, precipitacao.data),
                      _buildInfoChip(Icons.water_drop, precipitacao.descricao),
                    ],
                  ),
                ),
                // Ícones de ação - IGUAL AO ORIGINAL
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () =>
                          _showPrecipitacaoForm(context, precipitacao),
                      color: VerdeClaro, // Mesma cor
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 15),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      onPressed: () => _deletePrecipitacao(precipitacao.id),
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

  void _showPrecipitacaoForm(
    BuildContext context,
    PrecipitacaoItem? precipitacao,
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
            child: PrecipitacaoFormModal(
              precipitacao: precipitacao,
              onSave: (newPrecipitacao) {
                setState(() {
                  if (precipitacao == null) {
                    precipitacoes.add(newPrecipitacao);
                  } else {
                    final index = precipitacoes.indexWhere(
                      (a) => a.id == precipitacao.id,
                    );
                    if (index != -1) {
                      precipitacoes[index] = newPrecipitacao;
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

  void _deletePrecipitacao(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir Registro'),
          content: const Text(
            'Tem certeza que deseja excluir este registro de precipitação?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  precipitacoes.removeWhere((a) => a.id == id);
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

// MODAL DE FORMULÁRIO - PRECIPITAÇÃO
class PrecipitacaoFormModal extends StatefulWidget {
  final PrecipitacaoItem? precipitacao;
  final Function(PrecipitacaoItem) onSave;

  const PrecipitacaoFormModal({
    super.key,
    this.precipitacao,
    required this.onSave,
  });

  @override
  State<PrecipitacaoFormModal> createState() => _PrecipitacaoFormModalState();
}

class _PrecipitacaoFormModalState extends State<PrecipitacaoFormModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _quantidadeController;
  late TextEditingController _dataController;
  late TextEditingController _descricaoController;
  late TextEditingController _fazendaController;
  late TextEditingController _talhaoController;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.precipitacao != null;
    _quantidadeController = TextEditingController(
      text: widget.precipitacao?.quantidade ?? '',
    );
    _dataController = TextEditingController(
      text: widget.precipitacao?.data ?? '',
    );
    _descricaoController = TextEditingController(
      text: widget.precipitacao?.descricao ?? '',
    );
    _fazendaController = TextEditingController(
      text: widget.precipitacao?.fazenda ?? '',
    );
    _talhaoController = TextEditingController(
      text: widget.precipitacao?.talhao ?? '',
    );
  }

  @override
  void dispose() {
    _quantidadeController.dispose();
    _dataController.dispose();
    _descricaoController.dispose();
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
                  _isEditing ? 'Editar Precipitação' : 'Nova Precipitação',
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
                      label: 'Milímetros (mm)',
                      controller: _quantidadeController,
                      icon: Icons.water_drop,
                      hint: 'Ex: 15.5',
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
                      label: 'Observações',
                      controller: _descricaoController,
                      icon: Icons.description,
                      hint: 'Observações adicionais',
                    ),
                    const SizedBox(height: 24),

                    // Botão Salvar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _savePrecipitacao,
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
          labelStyle: TextStyle(
            color: VerdeClaro,
            fontWeight: FontWeight.w600,
          ), // Mesma cor
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

  void _savePrecipitacao() {
    if (_formKey.currentState!.validate()) {
      final newPrecipitacao = PrecipitacaoItem(
        id:
            widget.precipitacao?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        quantidade: _quantidadeController.text,
        data: _dataController.text,
        descricao: _descricaoController.text,
        fazenda: _fazendaController.text,
        talhao: _talhaoController.text,
      );

      widget.onSave(newPrecipitacao);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Registro atualizado com sucesso!'
                : 'Registro criado com sucesso!',
          ),
          backgroundColor: VerdeEscuro, // Mesma cor
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
