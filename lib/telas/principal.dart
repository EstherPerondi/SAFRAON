import 'package:flutter/material.dart';
import 'package:safraon/variaveis.dart';
class PrincipalPage extends StatelessWidget {
  const PrincipalPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    final itens = [
      {"titulo": "Fazendas", "icone": "Imagens/ICONE_FAZENDAS.png"},
      {"titulo": "Talhões", "icone": "Imagens/ICONE_TALHAO.png"},
      {"titulo": "Últimas\nAplicações", "icone": "Imagens/ICONE_DEFENSIVO.png"},
      {"titulo": "Plantio", "icone": "Imagens/ICONE_PLANTIO.png"},
      {"titulo": "Manejos", "icone": "Imagens/ICONE_MANEJO.png"},
      {"titulo": "Colheitas", "icone": "Imagens/ICONE_COLHEITA.png"},
      {"titulo": "Precipitações", "icone": "Imagens/ICONE_CHUVA.png"},
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool desktop = constraints.maxWidth >= 800;
        final double cardWidth = desktop ? 250 : 110;
        final double spacing = desktop ? 50 : 60;
        final double padding = desktop ? 50 : 20;
        
        int cardsPerRow = (constraints.maxWidth - padding * 2 + spacing) ~/ (cardWidth + spacing);
        if (cardsPerRow < 1) cardsPerRow = 1;
        
        return Scaffold(
          backgroundColor: Bege,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Center(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: spacing,
                    runSpacing: desktop ? 110 : 80,
                    alignment: WrapAlignment.center,
                    children: itens.map((item) {
                      return SizedBox(
                        width: cardWidth,
                        child: MenuCard(
                          titulo: item["titulo"]!,
                          imagem: item["icone"]!,
                          onTap: () {
                            switch(item["titulo"]) {
                              case "Fazendas":
                                Navigator.pushNamed(context, '/fazendas');
                                break;
                              case "Talhões":
                                Navigator.pushNamed(context, '/talhoes');
                                break;
                              case "Últimas\nAplicações":
                                Navigator.pushNamed(context, '/aplicacoes');
                                break;
                              case "Plantio":
                                Navigator.pushNamed(context, '/plantios');
                                break;
                              case "Manejos":
                                Navigator.pushNamed(context, '/manejos');
                                break;
                              case "Colheitas":
                                Navigator.pushNamed(context, '/colheitas');
                                break;
                              case "Precipitações":
                                Navigator.pushNamed(context, '/precipitacoes');
                                break;
                            }
                          },
                          desktop: desktop,
                        ),
                      );
                    }).toList(),
                  ),
                ),
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
              color: VerdeEscuro,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: EdgeInsets.all(desktop ? 8 : 8),
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