import 'package:flutter/material.dart';
import 'package:skillhub_app/model/servico_oferecido.dart';
import 'package:skillhub_app/service/service_available_service.dart';

class ServicesAvailableScreen extends StatefulWidget {
  const ServicesAvailableScreen({super.key});

  @override
  State<ServicesAvailableScreen> createState() =>
      _ServicesAvailableScreenState();
}

class _ServicesAvailableScreenState extends State<ServicesAvailableScreen> {
  final ServiceAvailableService _service = ServiceAvailableService();

  bool loading = true;
  List<ServicoOferecido> services = [];

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (services.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum serviço disponível no momento.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final servico = services[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text(
              servico.nome ?? 'Serviço',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(servico.descricao ?? ''),
                const SizedBox(height: 8),
                Text(
                  'Oferecido por: ${servico.usuario?.nome ?? 'Usuário'}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            trailing: Text(
              'R\$ ${(servico.valor ?? 0).toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _loadServices() async {
    try {
      final result = await _service.fetchAllServices();
      setState(() {
        services = result;
        loading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      setState(() => loading = false);
    }
  }
}
