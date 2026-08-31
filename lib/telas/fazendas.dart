import 'package:flutter/material.dart';
import 'package:safraon/variaveis.dart';

class FarmItem {
  final String id;
  final String name;
  final String location;
  final String area;
  final String production;
  final IconData icon;

  FarmItem({
    required this.id,
    required this.name,
    required this.location,
    required this.area,
    required this.production,
    required this.icon,
  });

  FarmItem copyWith({
    String? id,
    String? name,
    String? location,
    String? area,
    String? production,
    IconData? icon,
  }) {
    return FarmItem(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      area: area ?? this.area,
      production: production ?? this.production,
      icon: icon ?? this.icon,
    );
  }
}

class FazendasPage extends StatefulWidget {
  const FazendasPage({super.key});

  @override
  State<FazendasPage> createState() => _FazendasPageState();
}

class _FazendasPageState extends State<FazendasPage> {
  List<FarmItem> farms = [
    FarmItem(
      id: '1',
      name: 'Fazenda 1',
      location: 'São Paulo, SP',
      area: 'Área: 1.200 ha',
      production: 'Produção: Soja, Milho',
      icon: Icons.agriculture,
    ),
    FarmItem(
      id: '2',
      name: 'Fazenda 2',
      location: 'Paraná, PR',
      area: 'Área: 850 ha',
      production: 'Produção: Café, Cana',
      icon: Icons.grass,
    ),
    FarmItem(
      id: '3',
      name: 'Fazenda 3',
      location: 'Minas Gerais, MG',
      area: 'Área: 1.500 ha',
      production: 'Produção: Laranja, Eucalipto',
      icon: Icons.park,
    ),
  ];

  final List<IconData> availableIcons = [
    Icons.agriculture,
    Icons.grass,
    Icons.park,
    Icons.eco,
    Icons.local_florist,
    Icons.grain,
    Icons.forest,
    Icons.terrain,
  ];

  @override
Widget build(BuildContext context) {
  return Scaffold(
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
            image: AssetImage('Imagens/ICONE_FAZENDAS.png'),
            width: 35,
            height: 35,
            fit: BoxFit.cover,
            color: BegeClaro,
          ),
          const SizedBox(width: 8),
          Text(
            'Fazendas',
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
    body: Container(
      decoration: BoxDecoration(color: Bege),
      child: Column(
        children: [
          Expanded(
            child: farms.isEmpty
                ? _buildEmptyState()
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        ...farms.map(
                          (farm) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildFarmCard(context, farm),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: VerdeEscuro,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  color: BegeClaro,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Total: ${farms.length} fazenda${farms.length > 1 ? 's' : ''} cadastrada${farms.length > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: BegeClaro,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () => _showFarmForm(context, null),
      backgroundColor: VerdeEscuro,
      child: Icon(Icons.add, color: Bege, size: 30),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
  );
}

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.agriculture, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'Nenhuma fazenda cadastrada',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Clique no botão + para adicionar',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  Widget _buildFarmCard(BuildContext context, FarmItem farm) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: BegeClaro,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(farm.icon, color: VerdeEscuro, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          farm.name,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: VerdeEscuro,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: VerdeClaro,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              farm.location,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, color: Colors.grey),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(child: _buildInfoChip(Icons.crop_free, farm.area)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildInfoChip(Icons.eco, farm.production)),
                  TextButton.icon(
                    onPressed: () {
                      _showFarmDetails(context, farm);
                    },
                    icon: Icon(Icons.visibility, size: 18, color: VerdeEscuro),
                    label: Text(
                      'Ver detalhes',
                      style: TextStyle(color: VerdeEscuro),
                    ),
                    style: TextButton.styleFrom(foregroundColor: VerdeEscuro),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.edit, color: VerdeClaro, size: 20),
                    onPressed: () => _showFarmForm(context, farm),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: Vermelho, size: 20),
                    onPressed: () => _deleteFarm(farm.id),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Colors.transparent),
      child: Row(
        children: [
          Icon(icon, size: 20, color: VerdeEscuro),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showFarmForm(BuildContext context, FarmItem? farm) {
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
            child: FarmFormModal(
              farm: farm,
              availableIcons: availableIcons,
              onSave: (newFarm) {
                setState(() {
                  if (farm == null) {
                    farms.add(newFarm);
                  } else {
                    final index = farms.indexWhere((f) => f.id == farm.id);
                    if (index != -1) {
                      farms[index] = newFarm;
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

  void _deleteFarm(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Excluir Fazenda', style: TextStyle(color: VerdeEscuro)),
          content: const Text('Tem certeza que deseja excluir esta fazenda?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  farms.removeWhere((f) => f.id == id);
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

  void _showFarmDetails(BuildContext context, FarmItem farm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(farm.name, style: TextStyle(color: VerdeEscuro)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Detalhes da fazenda:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '• Localização: ${farm.location}',
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 4),
              Text(
                '• ${farm.area}',
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 4),
              Text(
                '• ${farm.production}',
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: VerdeEscuro),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}

class FarmFormModal extends StatefulWidget {
  final FarmItem? farm;
  final List<IconData> availableIcons;
  final Function(FarmItem) onSave;

  const FarmFormModal({
    super.key,
    this.farm,
    required this.availableIcons,
    required this.onSave,
  });

  @override
  State<FarmFormModal> createState() => _FarmFormModalState();
}

class _FarmFormModalState extends State<FarmFormModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _areaController;
  late TextEditingController _productionController;
  late IconData _selectedIcon;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.farm != null;
    _nameController = TextEditingController(text: widget.farm?.name ?? '');
    _locationController = TextEditingController(
      text: widget.farm?.location ?? '',
    );
    _areaController = TextEditingController(
      text:
          widget.farm?.area.replaceAll('Área: ', '').replaceAll(' ha', '') ??
          '',
    );
    _productionController = TextEditingController(
      text: widget.farm?.production.replaceAll('Produção: ', '') ?? '',
    );
    _selectedIcon = widget.farm?.icon ?? widget.availableIcons.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _areaController.dispose();
    _productionController.dispose();
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
                  _isEditing ? 'Editar Fazenda' : 'Nova Fazenda',
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
                    _buildFormField(
                      label: 'Nome da Fazenda',
                      controller: _nameController,
                      icon: Icons.agriculture,
                      hint: 'Ex: Fazenda Boa Vista',
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Localização',
                      controller: _locationController,
                      icon: Icons.location_on,
                      hint: 'Ex: São Paulo, SP',
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Área (hectares)',
                      controller: _areaController,
                      icon: Icons.crop_free,
                      hint: 'Ex: 1200',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Produção',
                      controller: _productionController,
                      icon: Icons.eco,
                      hint: 'Ex: Soja, Milho',
                    ),
                    const SizedBox(height: 16),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ícone',
                          style: TextStyle(
                            color: VerdeClaro,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: widget.availableIcons.map((icon) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedIcon = icon;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: _selectedIcon == icon
                                      ? VerdeEscuro
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _selectedIcon == icon
                                        ? VerdeEscuro
                                        : Colors.grey.shade300,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  icon,
                                  color: _selectedIcon == icon
                                      ? Bege
                                      : VerdeClaro,
                                  size: 24,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveFarm,
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
          if (label == 'Área (hectares)' && double.tryParse(value) == null) {
            return 'Digite um número válido';
          }
          return null;
        },
      ),
    );
  }

  void _saveFarm() {
    if (_formKey.currentState!.validate()) {
      final newFarm = FarmItem(
        id: widget.farm?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        location: _locationController.text,
        area: 'Área: ${_areaController.text} ha',
        production: 'Produção: ${_productionController.text}',
        icon: _selectedIcon,
      );

      widget.onSave(newFarm);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Fazenda atualizada com sucesso!'
                : 'Fazenda criada com sucesso!',
          ),
          backgroundColor: VerdeEscuro,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
