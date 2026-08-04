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

class TalhoesPage extends StatelessWidget {
  const TalhoesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> talhoes = [
      {'nome': 'Talhão 1', 'fazenda': 'Fazenda 1'},
      {'nome': 'Talhão 2', 'fazenda': 'Fazenda 1'},
      {'nome': 'Talhão 3', 'fazenda': 'Fazenda 2'},
    ];

    return Scaffold(
      backgroundColor: Bege,
      // appBar: AppBar(
      //   title: const Text(
      //     'Talhões',
      //     style: TextStyle(
      //       fontWeight: FontWeight.bold,
      //       fontSize: 45,
      //     ),
      //   ),
      //   backgroundColor: VerdeEscuro,
      //   foregroundColor: Bege,
      //   elevation: 5,
      //   centerTitle: true,
      // ),
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
                      Icon(Icons.grass, size: 45, color: VerdeClaro),
                      const SizedBox(width: 10),
                      Text(
                        'Lista de Talhões',
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

                // Cards dos talhões - mais compactos
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
                          subtitle: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 14,
                                color: VerdeClaro,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                talhao['fazenda']!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
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

                // Rodapé mais compacto
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
    );
  }
}
