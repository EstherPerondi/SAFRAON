import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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

// Decide, ao abrir o app, se mostra o Login ou a tela Principal,
// com base em já existir (ou não) uma sessão ativa no Supabase.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: SupabaseService().client.auth.onAuthStateChange,
      initialData: AuthState(
        AuthChangeEvent.initialSession,
        SupabaseService().client.auth.currentSession,
      ),
      builder: (context, snapshot) {
        final session = snapshot.data?.session ??
            SupabaseService().client.auth.currentSession;

        if (session != null) {
          return const PrincipalPage();
        }
        return const LoginPage();
      },
    );
  }
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
        title: 'SafraON',
        locale: const Locale('pt', 'BR'),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('pt', 'BR'),
        ],
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1B5E20),
          ),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthGate(),
          '/login': (context) => const LoginPage(),
          '/cadastro': (context) => const Cadastro(),
          '/principal': (context) => const PrincipalPage(),
          '/fazendas': (context) => const FazendasPage(),
          '/talhoes': (context) => const TalhoesPage(),
          '/aplicacoes': (context) => const AplicacoesPage(),
          '/plantios': (context) => const PlantiosPage(),
          '/manejos': (context) => const ManejosPage(),
          '/colheitas': (context) => const ColheitasPage(),
          '/precipitacoes': (context) => const PrecipitacoesPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}