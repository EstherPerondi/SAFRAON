import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/plantio_provider.dart';
import '../models/plantio_model.dart';
import '../services/lookup_service.dart';
import '../widgets/novo_item_dialog.dart';
import '../variaveis.dart';

class PlantiosPage extends StatefulWidget {
  const PlantiosPage({super.key});

  @override
  State<PlantiosPage> createState() => _PlantiosPageState();
}

class _PlantiosPageState extends State<PlantiosPage> {
  String? _talhaoId;
  List<LookupItem> _culturas = [];
  List<LookupItem> _adubos = [];
  List<LookupItem> _inoculantes = [];

  @override
  void initState() {
    super.initState();
    LookupService().getCulturas().then((lista) {
      if (mounted) setState(() => _culturas = lista);
    }).catchError((e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar culturas: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    });
    LookupService().getAdubos().then((lista) {
      if (mounted) setState(() => _adubos = lista);
    }).catchError((e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar adubos: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    });
    LookupService().getInoculantes().then((lista) {
      if (mounted) setState(() => _inoculantes = lista);
    }).catchError((e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar inoculantes: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map && args.containsKey('talhaoId')) {
        _talhaoId = args['talhaoId'].toString();
        context.read<PlantioProvider>().loadByTalhaoId(_talhaoId!);
      } else {
        context.read<PlantioProvider>().loadAll();
      }
    });
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
      body: Consumer<PlantioProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.plantios.isEmpty) {
            return Center(
              child: CircularProgressIndicator(color: VerdeEscuro),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Erro ao carregar plantios',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.error!,
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_talhaoId != null) {
                        provider.loadByTalhaoId(_talhaoId!);
                      } else {
                        provider.loadAll();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: VerdeEscuro,
                      foregroundColor: Bege,
                    ),
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          return Center(
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
                    if (provider.plantios.isEmpty)
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.eco,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Nenhum plantio registrado',
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
                        child: RefreshIndicator(
                          onRefresh: () {
                            if (_talhaoId != null) {
                              return provider.loadByTalhaoId(_talhaoId!);
                            } else {
                              return provider.loadAll();
                            }
                          },
                          child: ListView.builder(
                            itemCount: provider.plantios.length,
                            itemBuilder: (context, index) {
                              final plantio = provider.plantios[index];
                              return _buildPlantioCard(plantio, index);
                            },
                          ),
                        ),
                      ),

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
                            'Total de Plantios',
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
                              '${provider.plantios.length}',
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPlantioForm(context, null),
        backgroundColor: VerdeEscuro,
        foregroundColor: Bege,
        child: const Icon(Icons.add, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildPlantioCard(PlantioModel plantio, int index) {
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
                    _getCulturaIcon(plantio.cultura),
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
                        plantio.cultura,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 14, color: VerdeClaro),
                          const SizedBox(width: 4),
                          Text(
                            plantio.formattedDate,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      if (_talhaoId == null && plantio.localizacao != null)
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 14, color: VerdeClaro),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                plantio.localizacao!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
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
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _buildInfoChip(Icons.science, '${plantio.variedade}'),
                      _buildInfoChip(Icons.agriculture, '${plantio.adubo}'),
                      _buildInfoChip(Icons.scale, '${plantio.quantidadeAdubo}'),
                      _buildInfoChip(Icons.biotech, '${plantio.inoculante}'),
                      _buildInfoChip(Icons.grain, '${plantio.sementes}'),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _showPlantioForm(context, plantio),
                      color: VerdeClaro,
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

  IconData _getCulturaIcon(String cultura) {
    if (cultura.toLowerCase().contains('soja')) {
      return Icons.eco;
    } else if (cultura.toLowerCase().contains('milho')) {
      return Icons.grass;
    } else if (cultura.toLowerCase().contains('café')) {
      return Icons.coffee;
    } else {
      return Icons.spa;
    }
  }

  void _showPlantioForm(BuildContext context, PlantioModel? plantio) {
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
            child: _PlantioFormModal(
              plantio: plantio,
              talhaoId: _talhaoId,
              culturas: _culturas,
              adubos: _adubos,
              inoculantes: _inoculantes,
              onSave: (novoPlantio) {
                final provider = context.read<PlantioProvider>();
                if (plantio == null) {
                  provider.create(novoPlantio);
                } else {
                  provider.update(novoPlantio);
                }
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
                context.read<PlantioProvider>().delete(id);
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

// ============================================
// MODAL DO FORMULÁRIO DE PLANTIO
// ============================================
class _PlantioFormModal extends StatefulWidget {
  final PlantioModel? plantio;
  final String? talhaoId;
  final List<LookupItem> culturas;
  final List<LookupItem> adubos;
  final List<LookupItem> inoculantes;
  final Function(PlantioModel) onSave;

  const _PlantioFormModal({
    this.plantio,
    this.talhaoId,
    required this.culturas,
    required this.adubos,
    required this.inoculantes,
    required this.onSave,
  });

  @override
  State<_PlantioFormModal> createState() => _PlantioFormModalState();
}

class _PlantioFormModalState extends State<_PlantioFormModal> {
  final _formKey = GlobalKey<FormState>();
  final _sementesController = TextEditingController();
  final _aduboQuantidadeController = TextEditingController();
  String? _culturaId;
  String? _variedadeId;
  String? _aduboId;
  String? _inoculanteId;
  List<LookupItem> _variedades = [];
  bool _carregandoVariedades = false;
  DateTime? _selectedDate;

  bool get _isEditing => widget.plantio != null;

  @override
  void initState() {
    super.initState();
    if (widget.plantio != null) {
      _culturaId = _vazioParaNulo(widget.plantio!.culturaId);
      _variedadeId = _vazioParaNulo(widget.plantio!.variedadeId);
      _aduboId = _vazioParaNulo(widget.plantio!.aduboId);
      _inoculanteId = _vazioParaNulo(widget.plantio!.inoculanteId);
      _sementesController.text =
          widget.plantio!.quantidadeSementesPorMetro.toString();
      _aduboQuantidadeController.text =
          widget.plantio!.quantidadeAduboPorAlqueire.toString();
      _selectedDate = widget.plantio!.data;
      if (_culturaId != null) _carregarVariedades(_culturaId!);
    } else {
      _selectedDate = DateTime.now();
    }
  }

  String? _vazioParaNulo(String? id) => (id == null || id.isEmpty) ? null : id;

  // Só usa o id como valor do dropdown se ele existir na lista de opções
  // (evita campo em branco/erro enquanto a lista ainda está carregando).
  String? _idValido(String? id, List<LookupItem> lista) {
    if (id == null || id.isEmpty) return null;
    return lista.any((item) => item.id == id) ? id : null;
  }

  Future<void> _carregarVariedades(String culturaId) async {
    setState(() => _carregandoVariedades = true);
    try {
      final lista = await LookupService().getVariedades(culturaId: culturaId);
      if (mounted) {
        setState(() {
          _variedades = lista;
          _carregandoVariedades = false;
          // Se a variedade selecionada não pertence mais à cultura escolhida, limpa.
          if (_variedadeId != null && !lista.any((v) => v.id == _variedadeId)) {
            _variedadeId = null;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _carregandoVariedades = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar variedades: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _sementesController.dispose();
    _aduboQuantidadeController.dispose();
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
                  _isEditing ? 'Editar Plantio' : 'Novo Plantio',
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
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildCulturaDropdown(),
                    const SizedBox(height: 16),
                    _buildDateField(),
                    const SizedBox(height: 16),
                    _buildVariedadeDropdown(),
                    const SizedBox(height: 16),
                    _buildAduboDropdown(),
                    const SizedBox(height: 16),
                    _buildInoculanteDropdown(),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Sementes por metro',
                      controller: _sementesController,
                      icon: Icons.grain,
                      hint: 'Ex: 12.5',
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Adubo por alqueire',
                      controller: _aduboQuantidadeController,
                      icon: Icons.agriculture,
                      hint: 'Ex: 300',
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _savePlantio,
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

  Widget _buildCulturaDropdown() {
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
      child: DropdownButtonFormField<String>(
        value: _idValido(_culturaId, widget.culturas),
        decoration: InputDecoration(
          labelText: 'Cultura',
          labelStyle: TextStyle(color: VerdeClaro, fontWeight: FontWeight.w600),
          prefixIcon: Icon(Icons.eco, color: VerdeClaro),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(16),
        ),
        items: [
          ...widget.culturas
              .map((c) => DropdownMenuItem(value: c.id, child: Text(c.nome))),
          buildAdicionarNovoDropdownItem('+ Adicionar nova cultura...'),
        ],
        onChanged: (value) async {
          if (value == kAdicionarNovoValor) {
            final novaCultura = await showNovoItemDialog(
              context: context,
              titulo: 'Nova Cultura',
              label: 'Nome da cultura',
              hint: 'Ex: Soja',
              onCriar: (nome, extras) => LookupService().createCultura(nome),
            );
            if (novaCultura != null) {
              setState(() {
                widget.culturas.add(novaCultura);
                _culturaId = novaCultura.id;
              });
              _carregarVariedades(novaCultura.id);
            }
            return;
          }
          setState(() => _culturaId = value);
          if (value != null) _carregarVariedades(value);
        },
        validator: (value) =>
            value == null || value.isEmpty ? 'Selecione a cultura' : null,
      ),
    );
  }

  Widget _buildVariedadeDropdown() {
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
      child: DropdownButtonFormField<String>(
        value: _idValido(_variedadeId, _variedades),
        decoration: InputDecoration(
          labelText: _carregandoVariedades
              ? 'Carregando variedades...'
              : 'Variedade',
          labelStyle: TextStyle(color: VerdeClaro, fontWeight: FontWeight.w600),
          prefixIcon: Icon(Icons.science, color: VerdeClaro),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(16),
        ),
        items: [
          ..._variedades
              .map((v) => DropdownMenuItem(value: v.id, child: Text(v.nome))),
          if (_culturaId != null)
            buildAdicionarNovoDropdownItem('+ Adicionar nova variedade...'),
        ],
        onChanged: _culturaId == null
            ? null
            : (value) async {
                if (value == kAdicionarNovoValor) {
                  final novaVariedade = await showNovoItemDialog(
                    context: context,
                    titulo: 'Nova Variedade',
                    label: 'Nome da variedade',
                    hint: 'Ex: TMG 7062',
                    camposExtras: const [
                      CampoExtra(
                        chave: 'fabricante',
                        label: 'Fabricante',
                        hint: 'Ex: TMG',
                      ),
                    ],
                    onCriar: (nome, extras) => LookupService().createVariedade(
                      nome,
                      _culturaId!,
                      fabricante: extras['fabricante'],
                    ),
                  );
                  if (novaVariedade != null) {
                    setState(() {
                      _variedades.add(novaVariedade);
                      _variedadeId = novaVariedade.id;
                    });
                  }
                  return;
                }
                setState(() => _variedadeId = value);
              },
        validator: (value) =>
            value == null || value.isEmpty ? 'Selecione a variedade' : null,
      ),
    );
  }

  Widget _buildAduboDropdown() {
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
      child: DropdownButtonFormField<String>(
        value: _idValido(_aduboId, widget.adubos),
        decoration: InputDecoration(
          labelText: 'Adubo',
          labelStyle: TextStyle(color: VerdeClaro, fontWeight: FontWeight.w600),
          prefixIcon: Icon(Icons.agriculture, color: VerdeClaro),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(16),
        ),
        items: [
          ...widget.adubos
              .map((a) => DropdownMenuItem(value: a.id, child: Text(a.nome))),
          buildAdicionarNovoDropdownItem('+ Adicionar novo adubo...'),
        ],
        onChanged: (value) async {
          if (value == kAdicionarNovoValor) {
            final novoAdubo = await showNovoItemDialog(
              context: context,
              titulo: 'Novo Adubo',
              label: 'Nome do adubo',
              hint: 'Ex: NPK 04-30-10',
              camposExtras: const [
                CampoExtra(
                  chave: 'fabricante',
                  label: 'Fabricante',
                  hint: 'Ex: Yara',
                ),
              ],
              onCriar: (nome, extras) => LookupService().createAdubo(
                nome,
                fabricante: extras['fabricante'],
              ),
            );
            if (novoAdubo != null) {
              setState(() {
                widget.adubos.add(novoAdubo);
                _aduboId = novoAdubo.id;
              });
            }
            return;
          }
          setState(() => _aduboId = value);
        },
        validator: (value) =>
            value == null || value.isEmpty ? 'Selecione o adubo' : null,
      ),
    );
  }

  Widget _buildInoculanteDropdown() {
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
      child: DropdownButtonFormField<String>(
        value: _idValido(_inoculanteId, widget.inoculantes),
        decoration: InputDecoration(
          labelText: 'Inoculante (opcional)',
          labelStyle: TextStyle(color: VerdeClaro, fontWeight: FontWeight.w600),
          prefixIcon: Icon(Icons.biotech, color: VerdeClaro),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(16),
        ),
        items: [
          ...widget.inoculantes
              .map((i) => DropdownMenuItem(value: i.id, child: Text(i.nome))),
          buildAdicionarNovoDropdownItem('+ Adicionar novo inoculante...'),
        ],
        onChanged: (value) async {
          if (value == kAdicionarNovoValor) {
            final novoInoculante = await showNovoItemDialog(
              context: context,
              titulo: 'Novo Inoculante',
              label: 'Nome do inoculante',
              hint: 'Ex: Bradyrhizobium',
              camposExtras: const [
                CampoExtra(
                  chave: 'fabricante',
                  label: 'Fabricante',
                  hint: 'Ex: Simbiose',
                ),
                CampoExtra(
                  chave: 'dosagemRecomendada',
                  label: 'Dosagem recomendada',
                  hint: 'Ex: 100',
                  tipo: TipoCampoExtra.numero,
                ),
              ],
              onCriar: (nome, extras) {
                final dosagemTexto = extras['dosagemRecomendada'];
                return LookupService().createInoculante(
                  nome,
                  fabricante: extras['fabricante'],
                  dosagemRecomendada: dosagemTexto == null
                      ? null
                      : double.tryParse(dosagemTexto.replaceAll(',', '.')),
                );
              },
            );
            if (novoInoculante != null) {
              setState(() {
                widget.inoculantes.add(novoInoculante);
                _inoculanteId = novoInoculante.id;
              });
            }
            return;
          }
          setState(() => _inoculanteId = value);
        },
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
          labelStyle: TextStyle(
            color: VerdeClaro,
            fontWeight: FontWeight.w600,
          ),
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

  Widget _buildDateField() {
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
      child: InkWell(
        onTap: _selectDate,
        borderRadius: BorderRadius.circular(12),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'Data',
            labelStyle: TextStyle(
              color: VerdeClaro,
              fontWeight: FontWeight.w600,
            ),
            prefixIcon: Icon(Icons.calendar_today, color: VerdeClaro),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(16),
          ),
          child: Text(
            _selectedDate != null
                ? '${_selectedDate!.day.toString().padLeft(2, '0')}/'
                    '${_selectedDate!.month.toString().padLeft(2, '0')}/'
                    '${_selectedDate!.year}'
                : 'Selecione uma data',
            style: TextStyle(
              fontSize: 16,
              color: _selectedDate != null ? Colors.black87 : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('pt', 'BR'),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _savePlantio() {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final novoPlantio = PlantioModel(
        id: widget.plantio?.id ?? '',
        talhaoId: widget.talhaoId ?? widget.plantio?.talhaoId ?? '',
        culturaId: _culturaId!,
        variedadeId: _variedadeId!,
        aduboId: _aduboId!,
        inoculanteId: _inoculanteId,
        data: _selectedDate!,
        quantidadeSementesPorMetro: double.parse(_sementesController.text),
        quantidadeAduboPorAlqueire: double.parse(_aduboQuantidadeController.text),
      );

      widget.onSave(novoPlantio);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Plantio atualizado com sucesso!'
                : 'Plantio criado com sucesso!',
          ),
          backgroundColor: VerdeEscuro,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}