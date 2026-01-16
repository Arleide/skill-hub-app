import 'package:flutter/material.dart';
import 'package:skillhub_app/model/solicitacao_servico.dart';
import 'package:skillhub_app/service/service_request_service.dart';

class RequestsSentScreen extends StatefulWidget {
  const RequestsSentScreen({super.key});

  @override
  State<RequestsSentScreen> createState() => _RequestsSentScreenState();
}

class _RequestsSentScreenState extends State<RequestsSentScreen> {
  final ServiceRequestService _service = ServiceRequestService();

  bool loading = true;
  List<SolicitacaoServico> requests = [];

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (requests.isEmpty) {
      return const Center(
        child: Text('Você ainda não enviou solicitações'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final req = requests[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(req.servicoOferecido?.nome ?? 'Serviço'),
            subtitle: Text(
              'Prestador: ${req.usuarioPrestador?.nome ?? ''}',
            ),
            trailing: Chip(
              label: Text(req.status ?? ''),
            ),
          ),
        );
      },
    );

  }

  Future<void> _loadRequests() async {
    try {
      final result = await _service.fetchSentRequests();
      setState(() {
        requests = result;
        loading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      setState(() => loading = false);
    }
  }
}
