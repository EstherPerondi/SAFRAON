import 'package:flutter/material.dart';
import 'package:safraon/variaveis.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final TextEditingController _nome = TextEditingController();
  final TextEditingController _email = TextEditingController();
  String? _estado;
  final TextEditingController _usuario = TextEditingController();
  final TextEditingController _senha = TextEditingController();
  final TextEditingController _confirmar = TextEditingController();

  bool _senhaVisivel = false;
  bool _confirmarSenhaVisivel = false;
  bool _carregando = false;

  final _formKey = GlobalKey<FormState>();

  // Função de cadastro
  Future<void> _cadastrar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _carregando = true;
    });

    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: _email.text.trim(),
        password: _senha.text.trim(),
        data: {
          'nome': _nome.text.trim(),
          'usuario': _usuario.text.trim(),
          'estado': _estado,
        },
      );

      if (response.user != null && mounted) {
        _limparCampos();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Cadastro realizado! Verifique seu email para confirmar a conta.',
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Vermelho,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Erro ao cadastrar. Tente novamente.'),
            backgroundColor: Vermelho,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nome.dispose();
    _email.dispose();
    _usuario.dispose();
    _senha.dispose();
    _confirmar.dispose();
    super.dispose();
  }

  void _limparCampos() {
    _nome.clear();
    _email.clear();
    _usuario.clear();
    _senha.clear();
    _confirmar.clear();
    setState(() {
      _estado = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final viewInsets = MediaQuery.of(context).viewInsets;
    
    double containerWidth;
    double horizontalPadding;
    double verticalPadding;
    double titleFontSize;
    double fieldFontSize;
    double buttonWidth;
    double buttonHeight;
    
    if (screenWidth < 600) {
      // Celular
      containerWidth = screenWidth;
      horizontalPadding = 16.0;
      verticalPadding = 16.0;
      titleFontSize = 24;
      fieldFontSize = 14;
      buttonWidth = double.infinity;
      buttonHeight = 48;
    } else if (screenWidth < 900) {
      // Tablet
      containerWidth = screenWidth * 0.6;
      horizontalPadding = 24.0;
      verticalPadding = 24.0;
      titleFontSize = 26;
      fieldFontSize = 15;
      buttonWidth = 250;
      buttonHeight = 50;
    } else {
      // Computador
      containerWidth = 500;
      horizontalPadding = 32.0;
      verticalPadding = 32.0;
      titleFontSize = 28;
      fieldFontSize = 16;
      buttonWidth = 280;
      buttonHeight = 52;
    }

    return Scaffold(
      resizeToAvoidBottomInset: true, 
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('Imagens/cadastro.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (screenWidth < 600) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: viewInsets.bottom,
                ),
                physics: const ClampingScrollPhysics(),
                child: Container(
                  width: containerWidth,
                  height: screenHeight,
                  padding: EdgeInsets.all(horizontalPadding),
                  color: Bege.withOpacity(0.95),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildForm(
                        context,
                        screenWidth,
                        titleFontSize,
                        fieldFontSize,
                        buttonWidth,
                        buttonHeight,
                      ),
                      if (viewInsets.bottom > 0)
                        SizedBox(height: 50),
                    ],
                  ),
                ),
              );
            } else {
              return Row(
                children: [
                  Container(
                    width: containerWidth,
                    height: screenHeight,
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: verticalPadding,
                    ),
                    color: Bege.withOpacity(0.95),
                    child: Center(
                      child: SingleChildScrollView(
                        child: _buildForm(
                          context,
                          screenWidth,
                          titleFontSize,
                          fieldFontSize,
                          buttonWidth,
                          buttonHeight,
                        ),
                      ),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildForm(
    BuildContext context,
    double screenWidth,
    double titleFontSize,
    double fieldFontSize,
    double buttonWidth,
    double buttonHeight,
  ) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: VerdeEscuro),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),

          Text(
            'Cadastro',
            style: tituloDaPg,
          ),
          const SizedBox(height: 50),

          // Campo Nome Completo
          TextFormField(
            controller: _nome,
            textInputAction: TextInputAction.next,
            style: TextStyle(fontSize: fieldFontSize),
            decoration: InputDecoration(
              labelText: 'Nome Completo',
              labelStyle: TextStyle(fontSize: fieldFontSize),
              prefixIcon: Icon(Icons.person, color: VerdeEscuro, size: fieldFontSize + 4),
              floatingLabelStyle: TextStyle(color: VerdeClaro, fontSize: fieldFontSize),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: VerdeEscuro,
                  width: 2.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: VerdeEscuro,
                  width: 2.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: VerdeClaro,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Vermelho, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Vermelho, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: screenWidth < 600 ? 12 : 14,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Insira seu nome completo';
              }
              if (value.split(' ').length < 2) {
                return 'Insira seu nome e sobrenome';
              }
              return null;
            },
          ),
          const SizedBox(height: 25),

          // Campo Email
          TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(fontSize: fieldFontSize),
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(fontSize: fieldFontSize),
              prefixIcon: Icon(
                Icons.email_outlined,
                color: VerdeEscuro,
                size: fieldFontSize + 4,
              ),
              floatingLabelStyle: TextStyle(color: VerdeClaro, fontSize: fieldFontSize),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: VerdeEscuro,
                  width: 2.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: VerdeEscuro,
                  width: 2.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: VerdeClaro,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Vermelho, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Vermelho, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: screenWidth < 600 ? 12 : 14,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Insira seu email';
              }
              final emailRegex = RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              );
              if (!emailRegex.hasMatch(value)) {
                return 'Insira um email válido';
              }
              return null;
            },
          ),
          const SizedBox(height: 25),

          // Campo Senha
          TextFormField(
            controller: _senha,
            obscureText: !_senhaVisivel,
            style: TextStyle(fontSize: fieldFontSize),
            decoration: InputDecoration(
              labelText: 'Senha',
              labelStyle: TextStyle(fontSize: fieldFontSize),
              prefixIcon: Icon(Icons.key, color: VerdeEscuro, size: fieldFontSize + 4),
              floatingLabelStyle: TextStyle(color: VerdeClaro, fontSize: fieldFontSize),
              suffixIcon: IconButton(
                icon: Icon(
                  _senhaVisivel
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: VerdeEscuro,
                  size: fieldFontSize + 4,
                ),
                onPressed: () {
                  setState(() {
                    _senhaVisivel = !_senhaVisivel;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: VerdeEscuro,
                  width: 2.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: VerdeEscuro,
                  width: 2.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: VerdeClaro,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Vermelho, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Vermelho, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: screenWidth < 600 ? 12 : 14,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Digite sua senha';
              }
              if (value.length < 6) {
                return 'Mínimo de 6 caracteres';
              }
              if (!RegExp(r'[A-Z]').hasMatch(value)) {
                return 'Necessário letra maiúscula';
              }
              if (!RegExp(r'[a-z]').hasMatch(value)) {
                return 'Necessário letra minúscula';
              }
              if (!RegExp(r'[0-9]').hasMatch(value)) {
                return 'Necessário número';
              }
              if (!RegExp(
                r'[!@#$%^&*(),.?":{}|<>]',
              ).hasMatch(value)) {
                return 'Necessário caractere especial Ex:!@#%^&*';
              }
              return null;
            },
          ),
          const SizedBox(height: 25),

          // Campo Confirmar Senha
          TextFormField(
            controller: _confirmar,
            obscureText: !_confirmarSenhaVisivel,
            style: TextStyle(fontSize: fieldFontSize),
            decoration: InputDecoration(
              labelText: 'Confirmar Senha',
              labelStyle: TextStyle(fontSize: fieldFontSize),
              prefixIcon: Icon(Icons.key, color: VerdeEscuro, size: fieldFontSize + 4),
              floatingLabelStyle: TextStyle(color: VerdeClaro, fontSize: fieldFontSize),
              suffixIcon: IconButton(
                icon: Icon(
                  _confirmarSenhaVisivel
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: VerdeEscuro,
                  size: fieldFontSize + 4,
                ),
                onPressed: () {
                  setState(() {
                    _confirmarSenhaVisivel =
                        !_confirmarSenhaVisivel;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: VerdeEscuro,
                  width: 2.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: VerdeEscuro,
                  width: 2.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: VerdeClaro,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Vermelho, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Vermelho, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: screenWidth < 600 ? 12 : 14,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Digite sua senha para confirmar';
              }
              if (value != _senha.text) {
                return 'As senhas não coincidem';
              }
              return null;
            },
          ),
          const SizedBox(height: 40),

          // Botão Cadastrar
          SizedBox(
            width: buttonWidth,
            height: buttonHeight,
            child: ElevatedButton(
              onPressed: _carregando ? null : _cadastrar,
              style: ElevatedButton.styleFrom(
                backgroundColor: VerdeClaro,
                foregroundColor: Bege,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
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
                  : Text(
                      'Cadastrar',
                      style: textoBotao,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}