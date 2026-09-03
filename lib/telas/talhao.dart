import 'package:flutter/material.dart';
import 'package:safraon/telas/aplicacao.dart';
import 'package:safraon/telas/clima.dart';
import 'package:safraon/telas/colheita.dart';
import 'package:safraon/telas/manejo.dart';
import 'package:safraon/telas/plantio.dart';
import 'package:safraon/telas/precipitacao.dart';
import 'package:safraon/variaveis.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Talhão',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const TalhaoPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TalhaoPage extends StatelessWidget {
  final Map<String, String>? talhaoData;
  
  const TalhaoPage({super.key, this.talhaoData});

  @override
  Widget build(BuildContext context) {
    final nome = talhaoData?['nome'] ?? 'Talhão';
    final fazenda = talhaoData?['fazenda'] ?? 'Fazenda';
    final cidade = talhaoData?['cidade'] ?? '';
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Bege),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          nome,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Bege,
          ),
        ),
        centerTitle: true,
        backgroundColor: VerdeEscuro,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Bege),
            onPressed: () {
              _showOptionsMenu(context);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Bege,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _buildHeaderInfo(nome, fazenda),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: [
                    _buildModuleCard(
                      icon: Icons.grass,
                      title: 'Plantios',
                      subtitle: 'Gerenciar plantio',
                      color: VerdeClaro,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PlantioPage()),
                        );
                      },
                    ),
                    _buildModuleCard(
                      icon: Icons.build,
                      title: 'Manejos',
                      subtitle: 'Práticas de manejo',
                      color: VerdeClaro,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ManejoPage()),
                        );
                      },
                    ),
                    _buildModuleCard(
                      icon: Icons.spa,
                      title: 'Aplicações',
                      subtitle: 'Insumos e defensivos',
                      color: VerdeClaro,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AplicacaoPage()),
                        );
                      },
                    ),
                    _buildModuleCard(
                      icon: Icons.agriculture,
                      title: 'Colheitas',
                      subtitle: 'Planejamento e execução',
                      color: VerdeClaro,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ColheitaPage()),
                        );
                      },
                    ),
                    _buildModuleCard(
                      icon: Icons.water_drop,
                      title: 'Precipitações',
                      subtitle: 'Histórico de chuvas',
                      color: VerdeClaro,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PrecipitacaoPage()),
                        );
                      },
                    ),
                    _buildModuleCard(
                      icon: Icons.wb_sunny,
                      title: 'Clima',
                      subtitle: 'Previsão e condições atuais',
                      color: VerdeClaro,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ClimaPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildQuickStats(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderInfo(String nome, String fazenda) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BegeClaro,
        borderRadius: BorderRadius.circular(16),
        // boxShadow: [
        //   // BoxShadow(
        //   //   color: Colors.orange[50],
        //   //   spreadRadius: 2,
        //   //   blurRadius: 8,
        //   //   offset: const Offset(0, 4),
        //   // ),
        // ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.lightGreen[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.terrain,
              color: VerdeClaro,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nome,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: VerdeEscuro,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 14,
                      color: VerdeClaro,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$fazenda',
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
    );
  }

  Widget _buildModuleCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.green[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: VerdeEscuro,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: VerdeEscuro,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: VerdeClaro,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
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
          _buildStatItem(Icons.calendar_today, 'Última', 'Atualização', '10/07/2026'),
          _buildDivider(),
          _buildStatItem(Icons.emoji_nature, 'Área', 'Total', '45,6 ha'),
          _buildDivider(),
          _buildStatItem(Icons.bar_chart, 'Produtividade', 'Estimada', '4.200 kg/ha'),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label1, String label2, String value) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: VerdeEscuro,
        ),
        const SizedBox(height: 4),
        Text(
          label1,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade500,
          ),
        ),
        Text(
          label2,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: VerdeClaro,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40,
      color: BegeClaro,
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.edit, color: VerdeEscuro),
                title: Text('Editar Talhão', style: TextStyle(color: VerdeEscuro)),
                onTap: () {
                  Navigator.pop(context);
                  // Aqui você pode adicionar a lógica de edição
                },
              ),
              ListTile(
                leading: Icon(Icons.share, color: VerdeEscuro),
                title: Text('Compartilhar', style: TextStyle(color: VerdeEscuro)),
                onTap: () {
                  Navigator.pop(context);
                  // Aqui você pode adicionar a lógica de compartilhamento
                },
              ),
              ListTile(
                leading: Icon(Icons.history, color: VerdeEscuro),
                title: Text('Histórico', style: TextStyle(color: VerdeEscuro)),
                onTap: () {
                  Navigator.pop(context);
                  // Aqui você pode adicionar a lógica de histórico
                },
              ),
              ListTile(
                leading: Icon(Icons.delete_outline, color: Colors.red.shade700),
                title: Text('Excluir', style: TextStyle(color: Colors.red.shade700)),
                onTap: () {
                  Navigator.pop(context);
                  // Aqui você pode adicionar a lógica de exclusão
                },
              ),
            ],
          ),
        );
      },
    );
  }
}