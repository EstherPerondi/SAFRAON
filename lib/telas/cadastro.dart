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
      backgroundColor: corDeFundo,
      appBar: AppBar(
        title: Text('Cadastro', style: tituloDaPg),
        backgroundColor: corDeFundo,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Voltar para tela de login
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Campo Nome Completo
              TextFormField(
                controller: _nome,
                decoration: InputDecoration(
                  labelText: 'Nome Completo',
                  labelStyle: escritaForm,
                  prefixIcon: Icon(Icons.person, color: corDeFundo),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: bcCadastro,
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

              const SizedBox(height: 50),

              // Campo Usuário (adicionado)
              TextFormField(
                controller: _usuario,
                decoration: InputDecoration(
                  labelText: 'Usuário',
                  labelStyle: escritaForm,
                  prefixIcon: Icon(Icons.person_outline, color: corDeFundo),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: bcCadastro,
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

              const SizedBox(height: 50),

              // Campo Estado
              DropdownButtonFormField<String>(
                value: _estado,
                hint: const Text('Selecione seu estado.'),
                decoration: InputDecoration(
                  labelText: 'Estado',
                  labelStyle: escritaForm,
                  prefixIcon: Icon(
                    Icons.location_on_outlined,
                    color: corDeFundo,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: bcCadastro,
                ),
                dropdownColor: bcCadastro,
                items: estados.map((String estado) {
                  return DropdownMenuItem<String>(
                    value: estado,
                    child: Text(
                      estado,
                      style: const TextStyle(color: Colors.white),
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

              const SizedBox(height: 50),

              // Campo Email
              TextFormField(
                controller: _email,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: escritaForm,
                  prefixIcon: Icon(Icons.email_outlined, color: corDeFundo),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: bcCadastro,
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

              const SizedBox(height: 50),

              // Campo Senha
              TextFormField(
                controller: _senha,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  labelStyle: escritaForm,
                  prefixIcon: Icon(Icons.key, color: corDeFundo),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _senhaVisivel ? Icons.visibility : Icons.visibility_off,
                      color: corDeFundo,
                    ),
                    onPressed: () {
                      setState(() {
                        _senhaVisivel = !_senhaVisivel;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: bcCadastro,
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

              const SizedBox(height: 50),

              // Campo Confirmar Senha
              TextFormField(
                controller: _confirmar,
                decoration: InputDecoration(
                  labelText: 'Confirmar Senha',
                  labelStyle: escritaForm,
                  prefixIcon: Icon(Icons.key, color: corDeFundo),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _confirmarSenhaVisivel
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: corDeFundo,
                    ),
                    onPressed: () {
                      setState(() {
                        _confirmarSenhaVisivel = !_confirmarSenhaVisivel;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: bcCadastro,
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

              const SizedBox(height: 50),

              // Botão Cadastrar
              SizedBox(
                width: double.infinity,
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
                    backgroundColor: bcCadastro,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Cadastrar', style: tituloDaPg),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
