import 'package:flutter/material.dart';
import 'package:skillhub_app/model/login_response.dart';
import 'package:skillhub_app/screen/create_account_screen.dart';
import 'package:skillhub_app/screen/home_screen.dart';
import 'package:skillhub_app/service/auth_service.dart';
import 'package:skillhub_app/util/custom_nav.dart';
import 'package:skillhub_app/util/dialog_helper.dart';
import 'package:skillhub_app/util/secure_storage_service.dart';
import 'package:skillhub_app/widget/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  final AuthService service = AuthService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    emailController.text = "";
    senhaController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _body());
  }

  _body() {
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
                const SizedBox(height: 10),

                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Esqueceu a senha?",
                    style: TextStyle(color: Colors.white),
                  ),
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
                    onPressed: () {
                      _login();
                    },
                    child: _isLoading
                        ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ) :
                    const Text(
                      "Entrar",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Não tem uma conta?",
                      style: TextStyle(color: Colors.white70),
                    ),

                    TextButton(
                      onPressed: () {
                        push(context, CreateAccountScreen());
                      },
                      child: const Text(
                        "Cadastre-se",
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

  _login() async {
    final email = emailController.text;
    final senha = senhaController.text;

    if (email.isEmpty || senha.isEmpty) {
      await showAppDialog(
        context,
        title: 'Atenção',
        message: 'Informe e-mail e senha',
        isError: true,
      );
      return;
    }

    try {
      setState(() => _isLoading = true);

      final LoginResponse loginResponse  = await service.login(email: email, senha: senha);

      await SecureStorageService.saveLogin(loginResponse);

      if(!mounted) return;

      push(context, HomeScreen(), replace: true);

    } catch (e) {
      if (!mounted) return;
      await showAppDialog(
        context,
        title: 'Erro',
        message: e.toString().replaceAll('Exception: ', ''),
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
