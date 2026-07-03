import 'package:flutter/material.dart';

class TalhoesPage extends StatelessWidget {
  const TalhoesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> talhoes = [
      {
        "talhao": "Talhão 1",
        "fazenda": "Fazenda 1",
      },
      {
        "talhao": "Talhão 2",
        "fazenda": "Fazenda 1",
      },
      {
        "talhao": "Talhão 3",
        "fazenda": "Fazenda 2",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5EFD6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),

              const Text(
                "Talhões",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 35),

              Expanded(
                child: ListView.builder(
                  itemCount: talhoes.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            talhoes[index]["talhao"]!,
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            talhoes[index]["fazenda"]!,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}