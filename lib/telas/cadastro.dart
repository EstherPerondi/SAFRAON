import 'package:flutter/material.dart';
import 'package:safraon/variaveis.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  @override
  final TextEditingController _nome = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _estado = TextEditingController();
  final TextEditingController _usuario = TextEditingController();
  final TextEditingController _senha = TextEditingController();
  final TextEditingController _confirmar = TextEditingController();

  bool _senhaVisivel = false;
  bool _confirmarSenhaVisivel = false;

  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: corDeFundo,
      appBar: AppBar(
        title: Text('Cadastro', style: tituloDaPg),
        backgroundColor: corDeFundo,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                validator: (_nome) {
                  if (_nome == null || _nome.isEmpty) {
                    return 'Insira seu nome completo';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 50),

              TextFormField(
                controller: _estado,
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
                validator: (_estado) {
                  if (_estado == null || _estado.isEmpty) {
                    return 'Insira estado onde estão localizadas suas fazendas';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 50),

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
                validator: (_email) {
                  if (_email == null ||
                      _email.isEmpty ||
                      !_email.contains('@')) {
                    return 'Insira seu email corretamente';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 50),

              TextFormField(
                controller: _senha,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  labelStyle: escritaForm,
                  prefixIcon: Icon(Icons.key),
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
                validator: (_senha) {
                  if (_senha == null || _senha.isEmpty) {
                    return 'Digite sua senha ';
                  }
                  if (_senha.length < 6) {
                    return 'Mínimo de 6 caracteres';
                  }
                  if (!RegExp(r'[A-Z]').hasMatch(_senha)) {
                    return 'Necessário de letras maiúscula';
                  }
                  if (!RegExp(r'[a-z]').hasMatch(_senha)) {
                    return 'Necessário de letra minúscula';
                  }
                  if (!RegExp(r'[0-9]').hasMatch(_senha)) {
                    return 'Necessário números';
                  }
                  if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(_senha)) {
                    return 'Necessário caracrtere especial Ex:!@#%^&*(),.?":{}|<>';
                  }
                  return 'null';
                },
              ),
              const SizedBox(height: 50),

              TextFormField(
                controller: _confirmar,
                decoration: InputDecoration(
                  labelText: 'Confirmar Senha',
                  labelStyle: escritaForm,
                  prefixIcon: Icon(Icons.key),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _senhaVisivel ? Icons.visibility : Icons.visibility_off,
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
                obscureText: !_senhaVisivel,
                validator: (_confirmar) {
                  if (_confirmar == null || _confirmar.isEmpty) {
                    return 'Digite sua senha para confirmar ';
                  }
                  if (_confirmar != _senha.text) {
                    return 'As senhas não coincidem';
                  }

                  return 'null';
                },
              ),
              const SizedBox(height: 50),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cadastro Realizado com sucesso!'),
                        ),
                      );
                    }
                  }, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bcCadastro,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    )
                  ),
                  child: Text('Cadastrar',
                  style: tituloDaPg,),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
