import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farm Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const FarmDashboardPage(),
    );
  }
}

class FarmDashboardPage extends StatelessWidget {
  const FarmDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Modern App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.green[700],
            foregroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Dashboard Agrícola',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.green[700]!,
                      Colors.green[800]!,
                      Colors.green[900]!,
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
                tooltip: 'Notificações',
              ),
              IconButton(
                icon: const Icon(Icons.person_outline),
                onPressed: () {},
                tooltip: 'Perfil',
              ),
            ],
          ),

          // Main Content
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Welcome Card
                _buildWelcomeCard(),
                const SizedBox(height: 20),

                // Quick Stats Row
                _buildQuickStats(),
                const SizedBox(height: 24),

                // Section: Fazendas
                _buildSectionHeader('Fazendas', Icons.storefront_outlined),
                const SizedBox(height: 12),
                _buildFazendasGrid(),
                const SizedBox(height: 24),

                // Section: Talhões
                _buildSectionHeader('Talhões', Icons.grid_3x3_outlined),
                const SizedBox(height: 12),
                _buildTalhoesList(),
                const SizedBox(height: 24),

                // Section: Últimas Aplicações
                _buildSectionHeader(
                  'Últimas Aplicações',
                  Icons.history_outlined,
                ),
                const SizedBox(height: 12),
                _buildUltimasAplicacoes(),
                const SizedBox(height: 24),

                // Section: Plantio
                _buildSectionHeader('Plantio', Icons.grass_outlined),
                const SizedBox(height: 12),
                _buildPlantioCard(),
                const SizedBox(height: 24),

                // Section: Manejos
                _buildSectionHeader('Manejos', Icons.agriculture_outlined),
                const SizedBox(height: 12),
                _buildManejosGrid(),
                const SizedBox(height: 24),

                // Section: Colheita
                _buildSectionHeader('Colheita', Icons.eco_outlined),
                const SizedBox(height: 12),
                _buildColheitaCard(),
                const SizedBox(height: 24),

                // Section: Características Climáticas
                _buildSectionHeader(
                  'Características Climáticas',
                  Icons.wb_sunny_outlined,
                ),
                const SizedBox(height: 12),
                _buildClimaticas(),
                const SizedBox(height: 24),

                // Section: Precipitações
                _buildSectionHeader('Precipitações', Icons.water_drop_outlined),
                const SizedBox(height: 12),
                _buildPrecipitacoes(),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Nova Atividade'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[600]!, Colors.green[800]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(Icons.agriculture, size: 35, color: Colors.green),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bem-vindo, Agricultor!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Acompanhe suas fazendas em tempo real',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard('Fazendas', '3', Icons.storefront, Colors.blue),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard('Talhões', '12', Icons.grid_3x3, Colors.orange),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Ativas',
            '85%',
            Icons.trending_up,
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.green[700], size: 28),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {},
          child: Text('Ver todos', style: TextStyle(color: Colors.green[700])),
        ),
      ],
    );
  }

  Widget _buildFazendasGrid() {
    final farms = [
      {'name': 'Fazenda Santa Lúcia', 'area': '1.250 ha', 'cultura': 'Soja'},
      {'name': 'Fazenda Boa Esperança', 'area': '890 ha', 'cultura': 'Milho'},
      {'name': 'Fazenda Nova Aliança', 'area': '2.100 ha', 'cultura': 'Café'},
    ];

    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: farms.length,
        itemBuilder: (context, index) {
          final farm = farms[index];
          return Container(
            width: 220,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.storefront,
                      size: 40,
                      color: Colors.green[700],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        farm['name']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Área: ${farm['area']} • ${farm['cultura']}',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTalhoesList() {
    final talhoes = [
      {
        'code': 'T-01',
        'cultura': 'Soja',
        'area': '45 ha',
        'status': 'Plantado',
      },
      {
        'code': 'T-02',
        'cultura': 'Milho',
        'area': '32 ha',
        'status': 'Crescendo',
      },
      {'code': 'T-03', 'cultura': 'Café', 'area': '28 ha', 'status': 'Pronto'},
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: talhoes.length,
      separatorBuilder: (context, index) => const Divider(height: 0),
      itemBuilder: (context, index) {
        final talhao = talhoes[index];
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.crop, color: Colors.green[700]),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      talhao['code']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${talhao['cultura']} • ${talhao['area']}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Text(
                  talhao['status']!,
                  style: TextStyle(fontSize: 11, color: Colors.green[700]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUltimasAplicacoes() {
    final aplicacoes = [
      {'produto': 'Herbicida A', 'data': '10/03/2025', 'area': 'Talhão T-01'},
      {
        'produto': 'Fertilizante B',
        'data': '08/03/2025',
        'area': 'Talhão T-02',
      },
      {'produto': 'Inseticida C', 'data': '05/03/2025', 'area': 'Talhão T-03'},
    ];

    return Column(
      children: aplicacoes.map((app) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Icon(Icons.spa, color: Colors.blue[600], size: 30),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      app['produto']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      app['area']!,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Text(
                app['data']!,
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPlantioCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange[100]!, Colors.orange[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Próximo Plantio',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  'Milho safrinha',
                  style: TextStyle(color: Colors.grey[800]),
                ),
                const SizedBox(height: 4),
                Text(
                  'Data prevista: 25/03/2025',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Icon(Icons.grass, size: 50, color: Colors.orange[700]),
        ],
      ),
    );
  }

  Widget _buildManejosGrid() {
    final manejos = ['Irrigação', 'Fertilização', 'Poda', 'Controle'];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: manejos.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.agriculture, color: Colors.green[700], size: 32),
              const SizedBox(height: 8),
              Text(
                manejos[index],
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildColheitaCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Previsão de Colheita',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: 0.65,
                  backgroundColor: Colors.grey[200],
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Soja',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      '65%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Icon(Icons.eco, size: 48, color: Colors.green[700]),
        ],
      ),
    );
  }

  Widget _buildClimaticas() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8),
        ],
      ),
      child: Column(
        children: [
          _buildClimaItem(
            Icons.thermostat,
            'Temperatura',
            '28°C',
            'Sensação: 30°C',
          ),
          const Divider(),
          _buildClimaItem(Icons.air, 'Umidade', '65%', 'Vento: 12 km/h'),
          const Divider(),
          _buildClimaItem(
            Icons.wb_sunny,
            'Radiação Solar',
            '850 W/m²',
            'Índice UV: 7',
          ),
        ],
      ),
    );
  }

  Widget _buildClimaItem(
    IconData icon,
    String label,
    String value,
    String detail,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange[600], size: 30),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Text(detail, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildPrecipitacoes() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Últimos 30 dias',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '125 mm',
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Icon(Icons.water_drop, color: Colors.blue[400], size: 35),
                    const SizedBox(height: 4),
                    Text(
                      'Previsão',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const Text(
                      '30 mm',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Icon(
                      Icons.water_drop_outlined,
                      color: Colors.blue[300],
                      size: 35,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Média histórica',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const Text(
                      '110 mm',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Icon(
                      Icons.wb_twighlight,
                      color: Colors.orange[400],
                      size: 35,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Dias sem chuva',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const Text(
                      '5 dias',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
