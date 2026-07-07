import 'package:flutter/material.dart';
import 'package:safraon/variaveis.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final itens = [
      {"titulo": "Fazendas", "icone": "Imagens/ICONE_FAZENDAS.png"},
      {"titulo": "Talhões", "icone": "Imagens/ICONE_TALHAO.png"},
      {"titulo": "Últimas\nAplicações", "icone": "Imagens/ICONE_DEFENSIVO.png"},
      {"titulo": "Plantio", "icone": "Imagens/ICONE_PLANTIO.png"},
      {"titulo": "Manejos", "icone": "Imagens/ICONE_MANEJO.png"},
      {"titulo": "Colheita", "icone": "Imagens/ICONE_COLHEITA.png"},
      {
        "titulo": "Características\nclimáticas",
        "icone": "Imagens/ICONE_CARACTERISTICAS_CLIMATICAS.png",
      },
      {"titulo": "Precipitações", "icone": "Imagens/ICONE_CHUVA.png"},
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool desktop = constraints.maxWidth >= 900;

        return Scaffold(
          backgroundColor: Bege,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(desktop ? 70 : 20),
              child: GridView.builder(
                itemCount: itens.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: desktop ? 4 : 2,
                  crossAxisSpacing: desktop ? 35 : 20,
                  mainAxisSpacing: desktop ? 35 : 25,
                  childAspectRatio: desktop ? 1.0 : 0.78,
                ),
                itemBuilder: (context, index) {
                  return MenuCard(
                    titulo: itens[index]["titulo"]!,
                    imagem: itens[index]["icone"]!,
                    onTap: () {},
                    desktop: desktop,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class MenuCard extends StatelessWidget {
  final String titulo;
  final String imagem;
  final VoidCallback onTap;
  final bool desktop;

  const MenuCard({
    super.key,
    required this.titulo,
    required this.imagem,
    required this.onTap,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: desktop ? 170 : 100,
            height: desktop ? 170 : 100,
            decoration: BoxDecoration(
              color: VerdeClaro,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: EdgeInsets.all(desktop ? 18 : 8),
              child: Image.asset(imagem, fit: BoxFit.contain),
            ),
          ),

          SizedBox(height: desktop ? 12 : 6),

          Text(
            titulo,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: desktop ? 22 : 18,
              color: VerdeClaro,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
