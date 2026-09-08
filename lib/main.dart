import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safraon/services/supabase_service.dart';
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

// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/supabase_service.dart';
import 'providers/fazenda_provider.dart';
import 'providers/talhao_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Supabase
  await SupabaseService().init();
  
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
      ],
      child: MaterialApp(
        title: 'SafraON',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1B5E20),
          ),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const PrincipalPage(),
          '/fazendas': (context) => const FazendasPage(),
          '/talhoes': (context) => const TalhoesPage(),
          '/aplicacoes': (context) => const Placeholder(child: Text('Aplicações')),
          '/plantios': (context) => const Placeholder(child: Text('Plantios')),
          '/manejos': (context) => const Placeholder(child: Text('Manejos')),
          '/colheitas': (context) => const Placeholder(child: Text('Colheitas')),
          '/precipitacoes': (context) => const Placeholder(child: Text('Precipitações')),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}