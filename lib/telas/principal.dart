import 'package:flutter/material.dart';
import 'package:safraon/variaveis.dart';
import '../services/auth_service.dart';

class PrincipalPage extends StatelessWidget {
  const PrincipalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final itens = [
      {"titulo": "Fazendas", "icone": "Imagens/ICONE_FAZENDAS.png"},
      {"titulo": "Talhões", "icone": "Imagens/ICONE_TALHAO.png"},
      {"titulo": "Aplicações", "icone": "Imagens/ICONE_DEFENSIVO.png"},
      {"titulo": "Plantio", "icone": "Imagens/ICONE_PLANTIO.png"},
      {"titulo": "Manejos", "icone": "Imagens/ICONE_MANEJO.png"},
      {"titulo": "Colheitas", "icone": "Imagens/ICONE_COLHEITA.png"},
      {"titulo": "Precipitações", "icone": "Imagens/ICONE_CHUVA.png"},
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final double w = constraints.maxWidth;
        final bool tablet = w >= 600 && w < 1024;
        final bool desktop = w >= 1024;

        late final double cardWidth;
        late final double spacing;
        late final double runSpacing;
        late final double padding;
        if (desktop) {
          cardWidth = 250;
          spacing = 50;
          runSpacing = 110;
          padding = 50;
        } else if (tablet) {
          // Tablet: 4 cards por linha, ocupando a largura disponível
          padding = 32;
          spacing = 32;
          runSpacing = 56;
          cardWidth = ((w - padding * 2 - spacing * 3) / 4)
              .floorToDouble()
              .clamp(120.0, 190.0)
              .toDouble();
        } else {
          cardWidth = 110;
          spacing = 60;
          runSpacing = 80;
          padding = 20;
        }
        // O ícone ocupa quase toda a largura do card (menos no desktop)
        final double iconeTamanho =
            desktop ? 170 : (tablet ? cardWidth - 10 : 100);

        return Scaffold(
          backgroundColor: Bege,
          appBar: AppBar(
            backgroundColor: VerdeEscuro,
            iconTheme: IconThemeData(color: BegeClaro),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: BegeClaro, // cor da borda
                      width: 2, // espessura
                    ),
                    shape: BoxShape.circle, // borda redonda
                  ),
                  child: ClipOval(
                    child: Image(
                      image: AssetImage('Imagens/logo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'SafraOn',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: BegeClaro,
                  ),
                ),
              ],
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Sair',
                onPressed: () async {
                  await AuthService().signOut();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                      (route) => false,
                    );
                  }
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Center(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: spacing,
                    runSpacing: runSpacing,
                    alignment: WrapAlignment.center,
                    children: itens.map((item) {
                      return SizedBox(
                        width: cardWidth,
                        child: MenuCard(
                          titulo: item["titulo"]!,
                          imagem: item["icone"]!,
                          onTap: () {
                            switch (item["titulo"]) {
                              case "Fazendas":
                                Navigator.pushNamed(context, '/fazendas');
                                break;
                              case "Talhões":
                                Navigator.pushNamed(context, '/talhoes');
                                break;
                              case "Aplicações":
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
                          tablet: tablet,
                          iconeTamanho: iconeTamanho,
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
  final bool tablet;
  final double iconeTamanho;

  const MenuCard({
    super.key,
    required this.titulo,
    required this.imagem,
    required this.onTap,
    required this.desktop,
    this.tablet = false,
    this.iconeTamanho = 100,
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
            width: iconeTamanho,
            height: iconeTamanho,
            decoration: BoxDecoration(
              color: VerdeEscuro,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: EdgeInsets.all(desktop ? 8 : 8),
              child: Image.asset(imagem, fit: BoxFit.contain),
            ),
          ),
          SizedBox(height: desktop ? 12 : (tablet ? 10 : 6)),
          // FittedBox reduz a fonte só se o título não couber na largura
          // do card, evitando quebra no meio da palavra (ex: Precipitações).
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              titulo,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: desktop ? 22 : (tablet ? 20 : 18),
                color: VerdeClaro,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
