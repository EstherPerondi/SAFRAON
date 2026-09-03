import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// PROVIDERS
import 'providers/fazenda_provider.dart';
import 'providers/talhao_provider.dart';
import 'providers/aplicacao_provider.dart';
import 'providers/plantio_provider.dart';
import 'providers/manejo_provider.dart';
import 'providers/colheita_provider.dart';
import 'providers/precipitacao_provider.dart';

// TELAS
import 'telas/login.dart';
import 'telas/cadastro.dart';
import 'telas/principal.dart';
import 'telas/fazendas.dart';
import 'telas/fazenda.dart';
import 'telas/talhoes.dart';
import 'telas/talhao.dart';
import 'telas/aplicacoes.dart';
import 'telas/plantios.dart';
import 'telas/manejos.dart';
import 'telas/colheitas.dart';
import 'telas/precipitacoes.dart';

import 'variaveis.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔑 COLOQUE SUAS CREDENCIAIS AQUI
  await Supabase.initialize(
    url: 'https://lqrelxniitrfhdcpbvwu.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxxcmVseG5paXRyZmhkY3Bidnd1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODU3MDYyNjksImV4cCI6MjEwMTI4MjI2OX0.ZNltZGSP_OZtjH7EE3cJqKXqoh9p7A5PP8sN5dM9hyc',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FazendaProvider()),
        ChangeNotifierProvider(create: (_) => TalhaoProvider()),
        ChangeNotifierProvider(create: (_) => AplicacaoProvider()),
        ChangeNotifierProvider(create: (_) => PlantioProvider()),
        ChangeNotifierProvider(create: (_) => ManejoProvider()),
        ChangeNotifierProvider(create: (_) => ColheitaProvider()),
        ChangeNotifierProvider(create: (_) => PrecipitacaoProvider()),
      ],
      child: MaterialApp(
        title: 'SafraOn',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: VerdeEscuro),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => LoginPage(),
          '/principal': (context) => const PrincipalPage(),
          '/fazendas': (context) => const FazendasPage(),
          '/talhoes': (context) => const TalhoesPage(),
          '/aplicacoes': (context) => const AplicacoesPage(),
          '/plantios': (context) => const PlantiosPage(),
          '/manejos': (context) => const ManejosPage(),
          '/colheitas': (context) => const ColheitasPage(),
          '/precipitacoes': (context) => const PrecipitacoesPage(),
          '/cadastro': (context) => const Cadastro(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/fazenda') {
            final args = settings.arguments as Map<String, String>;
            return MaterialPageRoute(
              builder: (context) => FazendaPage(
                fazendaId: args['fazendaId']!,
                fazendaNome: args['fazendaNome']!,
              ),
            );
          }
          if (settings.name == '/talhao') {
            final args = settings.arguments as Map<String, String>;
            return MaterialPageRoute(
              builder: (context) => TalhaoPage(
                talhaoData: {
                  'nome': args['nome']!,
                  'fazenda': args['fazenda']!,
                  'cidade': args['cidade'] ?? '',
                },
              ),
            );
          }
          return null;
        },
      ),
    );
  }
}