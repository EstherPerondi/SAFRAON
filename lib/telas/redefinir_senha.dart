import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/supabase_service.dart';
import '../variaveis.dart';

/// Passo 2 da recuperação de senha: o usuário já tem uma sessão de
/// recuperação (código validado ou link do email aberto) e define a nova senha.
/// É exibida pelo AuthGate enquanto [recuperandoSenha] for true.
class RedefinirSenhaPage extends StatefulWidget {
  const RedefinirSenhaPage({super.key});

  @override
  State<RedefinirSenhaPage> createState() => _RedefinirSenhaPageState();
}

class _RedefinirSenhaPageState extends State<RedefinirSenhaPage> {
  final _senhaController = TextEditingController();
  final _confirmarController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _carregando = false;
  bool _senhaVisivel = false;
  bool _confirmarVisivel = false;

  // Mesmas regras da tela de cadastro
  static final RegExp _regexEspecial = RegExp(r'[!@#$%^&*(),.?\":{}|<>]');

  @override
  void dispose() {
    _senhaController.dispose();
    _confirmarController.dispose();
    super.dispose();
  }

  String? _validarSenha(String? value) {
    if (value == null || value.isEmpty) return 'Digite a nova senha';
    if (value.length < 6) return 'Mínimo de 6 caracteres';
    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Use uma letra maiúscula';
    if (!RegExp(r'[a-z]').hasMatch(value)) return 'Use uma letra minúscula';
    if (!RegExp(r'[0-9]').hasMatch(value)) return 'Use um número';
    if (!_regexEspecial.hasMatch(value)) {
      return 'Use um caractere especial (ex: ! @ # % & *)';
    }
    return null;
  }

  String? _validarConfirmacao(String? value) {
    if (value == null || value.isEmpty) return 'Confirme a nova senha';
    if (value != _senhaController.text) return 'As senhas não coincidem';
    return null;
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final messenger = ScaffoldMessenger.of(context);
    setState(() => _carregando = true);

    try {
      final auth = Supabase.instance.client.auth;
      await auth.updateUser(UserAttributes(password: _senhaController.text));

      // Encerra a sessão de recuperação: o usuário entra com a nova senha.
      await auth.signOut();
      recuperandoSenha.value = false;

      messenger.showSnackBar(
        SnackBar(
          content: const Text('Senha alterada! Entre com a nova senha.'),
          backgroundColor: VerdeEscuro,
          duration: const Duration(seconds: 4),
        ),
      );
    } on AuthException catch (e) {
      final msg = e.message.toLowerCase();
      String texto = mensagemDeErro(e);
      if (msg.contains('different from the old password') ||
          msg.contains('same_password')) {
        texto = 'A nova senha deve ser diferente da senha atual.';
      } else if (msg.contains('session') || msg.contains('jwt')) {
        texto = 'O link/código expirou. Peça uma nova recuperação de senha.';
      }
      messenger.showSnackBar(
        SnackBar(content: Text(texto), backgroundColor: Colors.red),
      );
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Erro ao conectar. Verifique sua internet.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  Future<void> _cancelar() async {
    await Supabase.instance.client.auth.signOut();
    recuperandoSenha.value = false;
  }

  InputDecoration _decoracao(String label, bool visivel, VoidCallback alternar) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: VerdeClaro, width: 2),
      ),
      prefixIcon: Icon(Icons.lock, color: VerdeEscuro),
      suffixIcon: IconButton(
        icon: Icon(
          visivel ? Icons.visibility : Icons.visibility_off,
          color: VerdeEscuro,
        ),
        onPressed: alternar,
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
                  child: Form(
                    key: _formKey,
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
                          'Nova senha',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: VerdeEscuro,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Mínimo de 6 caracteres, com letra maiúscula, '
                          'minúscula, número e caractere especial.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: VerdeEscuro, fontSize: 12),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _senhaController,
                          obscureText: !_senhaVisivel,
                          textInputAction: TextInputAction.next,
                          decoration: _decoracao(
                            'Nova senha',
                            _senhaVisivel,
                            () => setState(() => _senhaVisivel = !_senhaVisivel),
                          ),
                          validator: _validarSenha,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmarController,
                          obscureText: !_confirmarVisivel,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _salvar(),
                          decoration: _decoracao(
                            'Confirmar nova senha',
                            _confirmarVisivel,
                            () => setState(
                              () => _confirmarVisivel = !_confirmarVisivel,
                            ),
                          ),
                          validator: _validarConfirmacao,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 49,
                          child: ElevatedButton(
                            onPressed: _carregando ? null : _salvar,
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
                                    child: CircularProgressIndicator(
                                      color: Bege,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text('Salvar nova senha', style: textoBotao),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: _carregando ? null : _cancelar,
                          style: TextButton.styleFrom(
                            foregroundColor: VerdeEscuro,
                          ),
                          child: const Text('Cancelar'),
                        ),
                      ],
                    ),
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
