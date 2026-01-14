import 'package:flutter/material.dart';
import 'package:skillhub_app/model/servico_oferecido.dart';
import 'package:skillhub_app/screen/login_screen.dart';
import 'package:skillhub_app/screen/new_service_available_screen.dart';
import 'package:skillhub_app/service/service_available_service.dart';
import 'package:skillhub_app/util/custom_nav.dart';
import 'package:skillhub_app/util/secure_storage_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = '';
  String email = '';

  bool loading = true;
  List<ServicoOferecido> meusServicos = [];

  final ServiceAvailableService _service = ServiceAvailableService();

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadServicos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _body());
  }

  _body() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          const SizedBox(height: 24),
          _actions(),
          const SizedBox(height: 24),
          _servicosSection(),
        ],
      ),
    );
  }

  Widget _header() {
    return Column(
      children: [
        Center(
          child: CircleAvatar(
            radius: 48,
            backgroundColor: Colors.grey.shade800,
            child: const Icon(Icons.person, size: 48, color: Colors.white),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(email, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _actions() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.exit_to_app),
            label: const Text('Sair'),
            onPressed: _logout,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Novo Serviço'),
            onPressed: () async {

              final result = await push(
                context,
                const NewServiceAvailableScreen(),
              );

              if (result == true) {
                _loadServicos();
              }

            },
          ),
        ),
      ],
    );
  }



  /// 🔹 Seção de serviços oferecidos
  Widget _servicosSection() {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (meusServicos.isEmpty) {
      return const Center(
        child: Text(
          'Você ainda não cadastrou serviços.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Meus Serviços',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: meusServicos.length,
          itemBuilder: (context, index) {
            final servico = meusServicos[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(servico.nome ?? 'Serviço sem nome'),
                subtitle: Text(servico.descricao ?? ''),
                trailing: Text(
                  'R\$ ${(servico.valor ?? 0).toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  _loadUser() async {
    final user = await SecureStorageService.getLoggedUser();

    if (user != null) {
      setState(() {
        name = user.name;
        email = user.email;
      });
    }
  }

  Future<void> _loadServicos() async {
    try {
      final result = await _service.fetchMyServices();
      setState(() {
        meusServicos = result;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
        debugPrint(e.toString());
      });
    }
  }

  Future<void> _logout() async {
    await SecureStorageService.clear();
    push(context, const LoginScreen(), replace: true);
  }
}
