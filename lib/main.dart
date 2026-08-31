import 'package:flutter/material.dart';
import 'package:safraon/telas/aplicacao.dart';
import 'package:safraon/telas/aplicacoes.dart';
import 'package:safraon/telas/clima.dart';
import 'package:safraon/telas/colheita.dart';
import 'package:safraon/telas/colheitas.dart';
import 'package:safraon/telas/manejos.dart';
import 'package:safraon/telas/plantios.dart';
import 'package:safraon/telas/precipitacao.dart';
import 'package:safraon/telas/cadastro.dart';
import 'package:safraon/telas/fazendas.dart';
import 'package:safraon/telas/login.dart';
import 'package:safraon/telas/manejo.dart';
import 'package:safraon/telas/plantio.dart';
import 'package:safraon/telas/precipitacoes.dart';
import 'package:safraon/telas/principal.dart';
import 'package:safraon/telas/talhao.dart';
import 'package:safraon/telas/talhoes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SafraOn',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      initialRoute: '/',
      routes: {
        '/principal': (context) => const PrincipalPage(),
        '/fazendas': (context) => const FazendasPage(),
        '/talhoes': (context) => const TalhoesPage(),
        '/aplicacoes': (context) => const AplicacoesPage(),
        '/plantios': (context) => const PlantiosPage(),
        '/manejos': (context) => const ManejosPage(),
        '/colheitas': (context) => const ColheitasPage(),
        '/precipitacoes': (context) => const PrecipitacoesPage(),
      },
      home: LoginPage(),
    );
  }
}
