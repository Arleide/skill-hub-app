import 'package:flutter/material.dart';
import 'package:skillhub_app/service/auth_service.dart';
import 'package:skillhub_app/widget/custom_text_field.dart';

import '../util/dialog_helper.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmarSenhaController =
      TextEditingController();

  final AuthService service = AuthService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    nomeController.text = '';
    emailController.text = '';
    senhaController.text = '';
    confirmarSenhaController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Conta', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF0A0A0F),
      ),
      body: _body(),
    );
  }

  Widget? _body() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0A0A0F), // dark absoluto
            Color(0xFF0A0A0F), // dark absoluto
            Color(0xFF1B263B), // azul aço escuro
            Color(0xFF415A77), // azul cinz
          ],
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 120,
                  child: Image.asset('assets/images/logo_icon.png'),
                ),

                const SizedBox(height: 8),

                SizedBox(
                  height: 60,
                  child: Image.asset('assets/images/logo_name.png'),
                ),

                const SizedBox(height: 35),
                CustomTextField(
                  label: 'Nome',
                  icon: Icons.person_2_outlined,
                  controller: nomeController,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'E-mail',
                  icon: Icons.email_outlined,
                  controller: emailController,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'Senha',
                  icon: Icons.lock_outline,
                  controller: senhaController,
                  isPassword: true,
                ),

                const SizedBox(height: 20),
                CustomTextField(
                  label: 'Confirme a Senha',
                  icon: Icons.lock_outline,
                  controller: confirmarSenhaController,
                  isPassword: true,
                ),

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFD0004F), Color(0xFFB0003A)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: _createAccount,
                    child: _isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Confirmar",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                  ),
                ),

                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Já tem uma conta?",
                      style: TextStyle(color: Colors.white70),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Entrar",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _createAccount() async {
    String nome = nomeController.text;
    String email = emailController.text;
    String senha = senhaController.text;
    String confirmarSenha = confirmarSenhaController.text;


    if (nome.isEmpty ||
        email.isEmpty ||
        senha.isEmpty ||
        confirmarSenha.isEmpty) {

      await showAppDialog(
        context,
        title: 'Atenção',
        message: 'Preencha todos os campos',
        isError: true,
      );
      return;
    }

    if (senha != confirmarSenha) {
      await showAppDialog(
        context,
        title: 'Erro',
        message: 'As senhas não conferem',
        isError: true,
      );
      return;
    }

    try {
      setState(() => _isLoading = true);

      await service.register(nome: nome, email: email, senha: senha);

      if (!mounted) return;

      await showAppDialog(
        context,
        title: 'Sucesso',
        message: 'Conta criada com sucesso 🎉',
        onConfirm: () {
          Navigator.pop(context);
        },
      );
    } catch (e) {
      if (!mounted) return;

      await showAppDialog(
        context,
        title: 'Erro',
        message: 'Erro ao criar conta',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
