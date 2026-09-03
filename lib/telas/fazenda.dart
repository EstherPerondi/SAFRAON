// talhoes.dart
import 'package:flutter/material.dart';
import 'package:safraon/telas/talhao.dart';
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
      home: const FazendaPage(
        fazendaId: '1',
        fazendaNome: 'Fazenda 1',
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

// MODELO DE DADOS
class TalhaoItem {
  final String id;
  final String nome;
  final String cidade;

  TalhaoItem({
    required this.id,
    required this.nome,
    required this.cidade,
  });

  TalhaoItem copyWith({
    String? id,
    String? nome,
    String? cidade,
  }) {
    return TalhaoItem(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      cidade: cidade ?? this.cidade,
    );
  }
}

class FazendaPage extends StatefulWidget {
  final String fazendaId;
  final String fazendaNome;

  const FazendaPage({
    super.key,
    required this.fazendaId,
    required this.fazendaNome,
  });

  @override
  State<FazendaPage> createState() => _FazendaPageState();
}

class _FazendaPageState extends State<FazendaPage> {
  List<TalhaoItem> talhoes = [];

  @override
  void initState() {
    super.initState();
    // Carregar talhões específicos da fazenda
    talhoes = _loadTalhoesForFazenda(widget.fazendaId);
  }

  List<TalhaoItem> _loadTalhoesForFazenda(String fazendaId) {
    // Exemplo com dados mock baseados no ID da fazenda
    if (fazendaId == '1') {
      return [
        TalhaoItem(id: '1', nome: 'Talhão 1', cidade: 'Toledo'),
        TalhaoItem(id: '2', nome: 'Talhão 2', cidade: 'Cascavel'),
        TalhaoItem(id: '3', nome: 'Talhão 3', cidade: 'Palotina'),
      ];
    } else if (fazendaId == '2') {
      return [
        TalhaoItem(id: '4', nome: 'Talhão 4', cidade: 'Maripá'),
        TalhaoItem(id: '5', nome: 'Talhão 5', cidade: 'Assis Chateaubriand'),
      ];
    } else if (fazendaId == '3') {
      return [
        TalhaoItem(id: '6', nome: 'Talhão 6', cidade: 'Nova Aurora'),
        TalhaoItem(id: '7', nome: 'Talhão 7', cidade: 'Cafelândia'),
        TalhaoItem(id: '8', nome: 'Talhão 8', cidade: 'Umuarama'),
      ];
    } else {
      return [];
    }
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
              image: AssetImage('Imagens/ICONE_TALHAO.png'),
              color: BegeClaro,
              width: 35,
              height: 35,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Talhões',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: BegeClaro,
                  ),
                ),
                Text(
                  widget.fazendaNome,
                  style: TextStyle(
                    fontSize: 14,
                    color: BegeClaro.withOpacity(0.8),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
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
                if (talhoes.isEmpty)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.terrain,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Nenhum talhão cadastrado',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Clique no botão + para adicionar',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: talhoes.length,
                      itemBuilder: (context, index) {
                        final talhao = talhoes[index];
                        return _buildTalhaoCard(talhao, index);
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
        onPressed: () => _showTalhaoForm(context, null),
        backgroundColor: VerdeEscuro,
        foregroundColor: Bege,
        child: const Icon(Icons.add, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildTalhaoCard(TalhaoItem talhao, int index) {
  return Card(
    color: Colors.orange[50],
    margin: const EdgeInsets.only(bottom: 8),
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: InkWell(
      onTap: () {
        // Navegar para a tela TalhaoPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TalhaoPage(
              talhaoData: {
                'nome': talhao.nome,
                'fazenda': widget.fazendaNome,
                'cidade': talhao.cidade,
              },
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(10),
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
                    Icons.terrain,
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
                        talhao.nome,
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
                            talhao.cidade,
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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _showTalhaoForm(context, talhao),
                      color: VerdeClaro,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 15),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      onPressed: () => _deleteTalhao(talhao.id),
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

  void _showTalhaoForm(
    BuildContext context,
    TalhaoItem? talhao,
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
            child: TalhaoFormModal(
              talhao: talhao,
              onSave: (newTalhao) {
                setState(() {
                  if (talhao == null) {
                    talhoes.add(newTalhao);
                  } else {
                    final index = talhoes.indexWhere(
                      (t) => t.id == talhao.id,
                    );
                    if (index != -1) {
                      talhoes[index] = newTalhao;
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

  void _deleteTalhao(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir Talhão'),
          content: const Text('Tem certeza que deseja excluir este talhão?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  talhoes.removeWhere((t) => t.id == id);
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

// MODAL DE FORMULÁRIO - TALHÕES
class TalhaoFormModal extends StatefulWidget {
  final TalhaoItem? talhao;
  final Function(TalhaoItem) onSave;

  const TalhaoFormModal({
    super.key,
    this.talhao,
    required this.onSave,
  });

  @override
  State<TalhaoFormModal> createState() => _TalhaoFormModalState();
}

class _TalhaoFormModalState extends State<TalhaoFormModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _cidadeController;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.talhao != null;
    _nomeController = TextEditingController(
      text: widget.talhao?.nome ?? '',
    );
    _cidadeController = TextEditingController(
      text: widget.talhao?.cidade ?? '',
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
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
                  _isEditing ? 'Editar Talhão' : 'Novo Talhão',
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
                      label: 'Nome do Talhão',
                      controller: _nomeController,
                      icon: Icons.map,
                      hint: 'Ex: Talhão 1',
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Localização',
                      controller: _cidadeController,
                      icon: Icons.location_on,
                      hint: 'Ex: Toledo',
                    ),
                    const SizedBox(height: 24),

                    // Botão Salvar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveTalhao,
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

  void _saveTalhao() {
    if (_formKey.currentState!.validate()) {
      final newTalhao = TalhaoItem(
        id: widget.talhao?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        nome: _nomeController.text,
        cidade: _cidadeController.text,
      );

      widget.onSave(newTalhao);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Talhão atualizado com sucesso!'
                : 'Talhão criado com sucesso!',
          ),
          backgroundColor: VerdeEscuro,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}