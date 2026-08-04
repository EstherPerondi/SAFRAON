import 'package:flutter/material.dart';
import 'package:safraon/variaveis.dart';

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

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nome.dispose();
    _email.dispose();
    _usuario.dispose();
    _senha.dispose();
    _confirmar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Largura do container baseada no tamanho da tela
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('Imagens/cadastro.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Se for celular, ocupa a tela toda, senão fica na esquerda
            if (screenWidth < 600) {
              return SingleChildScrollView(
                child: Container(
                  width: containerWidth,
                  padding: EdgeInsets.all(horizontalPadding),
                  color: Bege.withOpacity(0.95),
                  child: _buildForm(
                    context,
                    screenWidth,
                    titleFontSize,
                    fieldFontSize,
                    buttonWidth,
                    buttonHeight,
                  ),
                ),
              );
            } else {
              return Row(
                children: [
                  // Container fixo na lateral esquerda
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
                  // Espaço vazio à direita (expande para ocupar o resto)
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
          // Botão de voltar alinhado à esquerda
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
          const SizedBox(height: 30),

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
          const SizedBox(height: 20),

          // Campo Usuário
          TextFormField(
            controller: _usuario,
            style: TextStyle(fontSize: fieldFontSize),
            decoration: InputDecoration(
              labelText: 'Usuário',
              labelStyle: TextStyle(fontSize: fieldFontSize),
              prefixIcon: Icon(
                Icons.person_outline,
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
                return 'Crie um nome de usuário';
              }
              if (value.length < 3) {
                return 'Usuário deve ter pelo menos 3 caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Campo Estado
          DropdownButtonFormField<String>(
            value: _estado,
            hint: Text(
              'Selecione seu estado.',
              style: TextStyle(fontSize: fieldFontSize),
            ),
            style: TextStyle(fontSize: fieldFontSize),
            decoration: InputDecoration(
              labelText: 'Estado',
              labelStyle: TextStyle(fontSize: fieldFontSize),
              prefixIcon: Icon(
                Icons.location_on_outlined,
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
            dropdownColor: VerdeClaro,
            items: estados.map((String estado) {
              return DropdownMenuItem<String>(
                value: estado,
                child: Text(
                  estado,
                  style: TextStyle(color: Bege, fontSize: fieldFontSize),
                ),
              );
            }).toList(),
            onChanged: (String? novoEstado) {
              setState(() {
                _estado = novoEstado;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Selecione o estado onde estão localizadas suas fazendas';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

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
          const SizedBox(height: 20),

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
          const SizedBox(height: 20),

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
          const SizedBox(height: 30),

          // Botão Cadastrar
          SizedBox(
            width: buttonWidth,
            height: buttonHeight,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Cadastro realizado com sucesso!',
                      ),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                  Future.delayed(const Duration(seconds: 2), () {
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: VerdeClaro,
                foregroundColor: Bege,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Cadastrar',
                style: textoBotao
              ),
            ),
          ),
        ],
      ),
    );
  }
}