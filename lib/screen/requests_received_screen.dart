import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:skillhub_app/model/solicitacao_servico.dart';
import 'package:skillhub_app/service/service_request_service.dart';

class RequestsReceivedScreen extends StatefulWidget {
  const RequestsReceivedScreen({super.key});

  @override
  State<RequestsReceivedScreen> createState() => _RequestsReceivedScreenState();
}

class _RequestsReceivedScreenState extends State<RequestsReceivedScreen> {
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
        child: Text(
          'Nenhuma solicitação recebida.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final req = requests[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text(
              req.servicoOferecido?.nome ?? 'Serviço',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Text(
                  req.servicoOferecido?.descricao ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  'Solicitante: ${req.usuarioSolicitante?.nome ?? ''}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  'Data: ${_formatDate(req.dataRealizacao)}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            trailing: _buildStatusChip(req.status),
          ),
        );
      },
    );
  }

  Future<void> _loadRequests() async {
    try {
      final result = await _service.fetchReceivedRequests();
      setState(() {
        requests = result;
        loading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      setState(() => loading = false);
    }
  }

  String _formatDate(String? date) {
    if (date == null) return '-';
    final parsed = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy').format(parsed);
  }

  Widget _buildStatusChip(String? status) {
    Color color;
    String label;

    switch (status) {
      case 'ABERTA':
        color = Colors.orange;
        label = 'Aberta';
        break;
      case 'ACEITA':
        color = Colors.blue;
        label = 'Aceita';
        break;
      case 'CONCLUIDA':
        color = Colors.green;
        label = 'Concluída';
        break;
      case 'CANCELADA':
        color = Colors.red;
        label = 'Cancelada';
        break;
      default:
        color = Colors.grey;
        label = status ?? '-';
    }

    return Chip(
      label: Text(label, style: const TextStyle(color: Colors.white)),
      backgroundColor: color,
    );
  }
}
