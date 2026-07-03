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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('Imagens/plantacao-de-milho.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30.0),
            child: Center(
              child: SizedBox(
                width: 600,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    Text('Cadastro', style: tituloBar),
                    const SizedBox(height: 50),
                    // Campo Nome Completo
                    TextFormField(
                      controller: _nome,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Nome Completo',
                        prefixIcon: Icon(Icons.person, color: VerdeEscuro),
                        floatingLabelStyle: TextStyle(color: VerdeClar),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: VerdeEscuro, width: 2.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: VerdeEscuro, width: 2.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: VerdeClar, width: 2),
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

                    const SizedBox(height: 30),

                    // Campo Usuário
                    TextFormField(
                      controller: _usuario,
                      decoration: InputDecoration(
                        labelText: 'Usuário',
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: VerdeEscuro,
                        ),
                        floatingLabelStyle: TextStyle(color: VerdeClar),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: VerdeEscuro, width: 2.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: VerdeEscuro, width: 2.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: VerdeClar, width: 2),
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

                    const SizedBox(height: 30),

                    // Campo Estado
                    DropdownButtonFormField<String>(
                      value: _estado,
                      hint: const Text('Selecione seu estado.'),
                      decoration: InputDecoration(
                        labelText: 'Estado',
                        prefixIcon: Icon(
                          Icons.location_on_outlined,
                          color: VerdeEscuro,
                        ),
                        floatingLabelStyle: TextStyle(color: VerdeClar),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: VerdeEscuro, width: 2.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: VerdeEscuro, width: 2.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: VerdeClar, width: 2),
                        ),
                      ),
                      dropdownColor: VerdeClar,
                      items: estados.map((String estado) {
                        return DropdownMenuItem<String>(
                          value: estado,
                          child: Text(estado, style: TextStyle(color: Bege)),
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

                    const SizedBox(height: 30),

                    // Campo Email
                    TextFormField(
                      controller: _email,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: VerdeEscuro,
                        ),
                        floatingLabelStyle: TextStyle(color: VerdeClar),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: VerdeEscuro, width: 2.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: VerdeEscuro, width: 2.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: VerdeClar, width: 2),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
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

                    const SizedBox(height: 30),

                    // Campo Senha
                    TextFormField(
                      controller: _senha,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: Icon(Icons.key, color: VerdeEscuro),
                        floatingLabelStyle: TextStyle(color: VerdeClar),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _senhaVisivel
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: VerdeEscuro,
                          ),
                          onPressed: () {
                            setState(() {
                              _senhaVisivel = !_senhaVisivel;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: VerdeEscuro, width: 2.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: VerdeEscuro, width: 2.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: VerdeClar, width: 2),
                        ),
                      ),
                      obscureText: !_senhaVisivel,
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
                        if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                          return 'Necessário caractere especial Ex:!@#%^&*';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 30),

                    // Campo Confirmar Senha
                    TextFormField(
                      controller: _confirmar,
                      decoration: InputDecoration(
                        labelText: 'Confirmar Senha',
                        prefixIcon: Icon(Icons.key, color: VerdeEscuro),
                        floatingLabelStyle: TextStyle(color: VerdeClar),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _confirmarSenhaVisivel
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: VerdeEscuro,
                          ),
                          onPressed: () {
                            setState(() {
                              _confirmarSenhaVisivel = !_confirmarSenhaVisivel;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: VerdeEscuro, width: 2.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: VerdeEscuro, width: 2.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: VerdeClar, width: 2),
                        ),
                      ),
                      obscureText: !_confirmarSenhaVisivel,
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
                      width: 250,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Cadastro realizado com sucesso
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Cadastro realizado com sucesso!'),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              ),
                            );

                            // Após 2 segundos, volta para a tela de login
                            Future.delayed(const Duration(seconds: 2), () {
                              if (mounted) {
                                Navigator.pop(context);
                              }
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: VerdeClar,
                          foregroundColor: Bege,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('Cadastrar', style: botaoCadastr),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}