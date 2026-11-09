import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/supabase_service.dart';
import '../variaveis.dart';

/// Passo 1 da recuperação de senha:
///  1) o usuário informa o email e recebe um código (e um link) por email;
///  2) digita o código aqui. Se estiver correto, o Supabase abre uma sessão
///     de recuperação e o AuthGate mostra a tela [RedefinirSenhaPage].
class RecuperarSenhaPage extends StatefulWidget {
  const RecuperarSenhaPage({super.key, this.emailInicial});

  /// Email já digitado na tela de login (opcional).
  final String? emailInicial;

  @override
  State<RecuperarSenhaPage> createState() => _RecuperarSenhaPageState();
}

class _RecuperarSenhaPageState extends State<RecuperarSenhaPage> {
  final _emailController = TextEditingController();
  final _codigoController = TextEditingController();
  final _emailFormKey = GlobalKey<FormState>();
  final _codigoFormKey = GlobalKey<FormState>();

  bool _codigoEnviado = false;
  bool _carregando = false;
  int _segundosParaReenviar = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.emailInicial?.trim() ?? '';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _emailController.dispose();
    _codigoController.dispose();
    super.dispose();
  }

  String? _validarEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, insira seu email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Insira um email válido';
    }
    return null;
  }

  String? _validarCodigo(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Digite o código recebido por email';
    }
    if (value.trim().length < 6) {
      return 'O código tem pelo menos 6 dígitos';
    }
    return null;
  }

  void _mostrar(String mensagem, {bool erro = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: erro ? Colors.red : VerdeEscuro,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  String _traduzirErro(AuthException e) {
    final msg = e.message.toLowerCase();
    if (e.statusCode?.toString() == '429' ||
        msg.contains('rate limit') ||
        msg.contains('too many') ||
        msg.contains('security purposes')) {
      return 'Muitas tentativas. Aguarde alguns minutos e tente novamente.';
    }
    return e.message;
  }

  void _iniciarContagem() {
    _timer?.cancel();
    setState(() => _segundosParaReenviar = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        _segundosParaReenviar--;
        if (_segundosParaReenviar <= 0) t.cancel();
      });
    });
  }

  // Envia o email de recuperação (código + link)
  Future<void> _enviarCodigo() async {
    if (!_emailFormKey.currentState!.validate()) return;

    setState(() => _carregando = true);
    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(
        _emailController.text.trim(),
        // No navegador, o link do email volta para o próprio site.
        redirectTo: kIsWeb ? Uri.base.origin : null,
      );
      if (!mounted) return;
      setState(() => _codigoEnviado = true);
      _iniciarContagem();
      // Mensagem neutra: não revela se o email existe ou não.
      _mostrar(
        'Se o email estiver cadastrado, você receberá o código em instantes.',
        erro: false,
      );
    } on AuthException catch (e) {
      _mostrar(_traduzirErro(e));
    } catch (_) {
      _mostrar('Erro ao conectar. Verifique sua internet.');
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  // Valida o código; se ok, o AuthGate leva para a tela de nova senha
  Future<void> _confirmarCodigo() async {
    if (!_codigoFormKey.currentState!.validate()) return;

    setState(() => _carregando = true);
    // Liga antes para o AuthGate não "piscar" a tela principal.
    recuperandoSenha.value = true;
    try {
      await Supabase.instance.client.auth.verifyOTP(
        email: _emailController.text.trim(),
        token: _codigoController.text.trim(),
        type: OtpType.recovery,
      );
      if (!mounted) return;
      // Volta para a raiz (AuthGate), que mostra a RedefinirSenhaPage.
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on AuthException catch (e) {
      recuperandoSenha.value = false;
      final msg = e.message.toLowerCase();
      if (msg.contains('expired') || msg.contains('invalid')) {
        _mostrar('Código inválido ou expirado. Peça um novo código.');
      } else {
        _mostrar(_traduzirErro(e));
      }
    } catch (_) {
      recuperandoSenha.value = false;
      _mostrar('Erro ao conectar. Verifique sua internet.');
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  InputDecoration _decoracao(String label, IconData icone) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: VerdeClaro, width: 2),
      ),
      prefixIcon: Icon(icone, color: VerdeEscuro),
    );
  }

  Widget _botaoPrincipal(String texto, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 49,
      child: ElevatedButton(
        onPressed: _carregando ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: VerdeEscuro,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: _carregando
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Bege, strokeWidth: 2),
              )
            : Text(texto, style: textoBotao),
      ),
    );
  }

  Widget _passoEmail() {
    return Form(
      key: _emailFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Informe o email da sua conta. Enviaremos um código para você '
            'criar uma nova senha.',
            textAlign: TextAlign.center,
            style: TextStyle(color: VerdeEscuro),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _enviarCodigo(),
            decoration: _decoracao('Email', Icons.email),
            validator: _validarEmail,
          ),
          const SizedBox(height: 24),
          _botaoPrincipal('Enviar código', _enviarCodigo),
        ],
      ),
    );
  }

  Widget _passoCodigo() {
    final podeReenviar = _segundosParaReenviar <= 0 && !_carregando;
    return Form(
      key: _codigoFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Enviamos um código para ${_emailController.text.trim()}. '
            'Digite-o abaixo. Confira também a caixa de spam.',
            textAlign: TextAlign.center,
            style: TextStyle(color: VerdeEscuro),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _codigoController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onFieldSubmitted: (_) => _confirmarCodigo(),
            decoration: _decoracao('Código', Icons.pin),
            validator: _validarCodigo,
          ),
          const SizedBox(height: 24),
          _botaoPrincipal('Verificar código', _confirmarCodigo),
          const SizedBox(height: 8),
          TextButton(
            onPressed: podeReenviar ? _enviarCodigo : null,
            style: TextButton.styleFrom(foregroundColor: VerdeEscuro),
            child: Text(
              _segundosParaReenviar > 0
                  ? 'Reenviar código em ${_segundosParaReenviar}s'
                  : 'Reenviar código',
            ),
          ),
          TextButton(
            onPressed: _carregando
                ? null
                : () {
                    _timer?.cancel();
                    _codigoController.clear();
                    setState(() {
                      _codigoEnviado = false;
                      _segundosParaReenviar = 0;
                    });
                  },
            style: TextButton.styleFrom(foregroundColor: VerdeEscuro),
            child: const Text('Usar outro email'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('Imagens/login.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 20,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Bege.withOpacity(0.95),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500, minWidth: 300),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'Imagens/logo.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Recuperar senha',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: VerdeEscuro,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _codigoEnviado ? _passoCodigo() : _passoEmail(),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: _carregando
                            ? null
                            : () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          foregroundColor: VerdeEscuro,
                        ),
                        child: const Text('Voltar ao login'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
