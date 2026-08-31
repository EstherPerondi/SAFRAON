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
      title: 'Talhões',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: VerdeEscuro),
        useMaterial3: true,
      ),
      home: const TalhoesPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TalhoesPage extends StatefulWidget {
  const TalhoesPage({super.key});

  @override
  State<TalhoesPage> createState() => _TalhoesPageState();
}

class _TalhoesPageState extends State<TalhoesPage> {
  List<Map<String, String>> talhoes = [
    {'nome': 'Talhão 1', 'fazenda': 'Fazenda 1', 'cidade': 'São Paulo, SP'},
    {'nome': 'Talhão 2', 'fazenda': 'Fazenda 1', 'cidade': 'São Paulo, SP'},
    {'nome': 'Talhão 3', 'fazenda': 'Fazenda 2', 'cidade': 'Minas Gerais, MG'},
  ];

  // Função para mostrar diálogo de adição igual ao das fazendas
  void _mostrarDialogAdicionar() {
    final TextEditingController nomeController = TextEditingController();
    final TextEditingController fazendaController = TextEditingController();
    final TextEditingController cidadeController = TextEditingController();

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
            child: TalhaoFormModal(
              onSave: (nome, fazenda, cidade) {
                setState(() {
                  talhoes.add({
                    'nome': nome,
                    'fazenda': fazenda,
                    'cidade': cidade,
                  });
                });
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Bege,
      appBar: AppBar(
        backgroundColor: VerdeEscuro,
        iconTheme: IconThemeData(color: BegeClaro),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(
              image: const AssetImage('Imagens/ICONE_TALHAO.png'),
              width: 38,
              height: 28,
              fit: BoxFit.cover,
              color: BegeClaro,
            ),
            const SizedBox(width: 8),
            Text(
              'Talhões',
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
                    itemCount: talhoes.length,
                    itemBuilder: (context, index) {
                      final talhao = talhoes[index];
                      return Card(
                        color: Colors.orange[50],
                        margin: const EdgeInsets.only(bottom: 8),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.agriculture,
                              color: VerdeEscuro,
                              size: 22,
                            ),
                          ),
                          title: Text(
                            talhao['nome']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 14,
                                    color: VerdeClaro,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    talhao['cidade']!,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.business,
                                    size: 14,
                                    color: VerdeClaro,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    talhao['fazenda']!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Container(
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
                                fontSize: 13,
                              ),
                            ),
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Selecionado: ${talhao['nome']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                backgroundColor: VerdeClaro,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                // Rodapé
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
                        'Total de Talhões',
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
                          '${talhoes.length}',
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
        onPressed: _mostrarDialogAdicionar,
        backgroundColor: VerdeEscuro,
        child: Icon(Icons.add, color: Bege, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

// Modal de formulário para adicionar talhão (igual ao das fazendas)
class TalhaoFormModal extends StatefulWidget {
  final Function(String, String, String) onSave;

  const TalhaoFormModal({
    super.key,
    required this.onSave,
  });

  @override
  State<TalhaoFormModal> createState() => _TalhaoFormModalState();
}

class _TalhaoFormModalState extends State<TalhaoFormModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _fazendaController;
  late TextEditingController _cidadeController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController();
    _fazendaController = TextEditingController();
    _cidadeController = TextEditingController();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _fazendaController.dispose();
    _cidadeController.dispose();
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
          // Cabeçalho verde (igual ao das fazendas)
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
                  'Novo Talhão',
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

          // Corpo do formulário (igual ao das fazendas)
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
                      label: 'Nome do Talhão',
                      controller: _nomeController,
                      icon: Icons.agriculture,
                      hint: 'Ex: Talhão A1',
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Fazenda',
                      controller: _fazendaController,
                      icon: Icons.business,
                      hint: 'Ex: Fazenda Boa Vista',
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Localização',
                      controller: _cidadeController,
                      icon: Icons.location_on,
                      hint: 'Ex: São Paulo, SP',
                    ),
                    const SizedBox(height: 24),
                    
                    // Botão Salvar (igual ao das fazendas)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _salvarTalhao,
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

  void _salvarTalhao() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(
        _nomeController.text,
        _fazendaController.text,
        _cidadeController.text,
      );
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Talhão "${_nomeController.text}" criado com sucesso!',
          ),
          backgroundColor: VerdeEscuro,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}