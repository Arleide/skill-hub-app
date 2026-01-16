import 'package:flutter/material.dart';
import 'package:skillhub_app/model/servico_oferecido.dart';
import 'package:skillhub_app/service/service_request_service.dart';
import 'package:skillhub_app/util/dialog_helper.dart';
import 'package:skillhub_app/util/secure_storage_service.dart';
import 'package:intl/intl.dart';

class RequestServiceScreen extends StatefulWidget {
  final ServicoOferecido servico;

  const RequestServiceScreen({super.key, required this.servico});

  @override
  State<RequestServiceScreen> createState() => _RequestServiceScreenState();
}

class _RequestServiceScreenState extends State<RequestServiceScreen> {
  DateTime? selectedDate;
  bool loading = false;

  final ServiceRequestService _service = ServiceRequestService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Solicitar Serviço',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
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
        ),
      ),
      body: _body(),
    );
  }

  _body() {

    final formatter = DateFormat('dd/MM/yyyy');

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Serviço
          Text(
            widget.servico.nome ?? '',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),
          Text(widget.servico.descricao ?? ''),

          const SizedBox(height: 16),

          Text(
            'Valor: R\$ ${widget.servico.valor?.toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.green,
            ),
          ),

          const SizedBox(height: 24),

          /// Prestador
          Card(
            elevation: 5,
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text(widget.servico.usuario?.nome ?? ''),
              subtitle: const Text('Prestador do serviço'),
            ),
          ),

          const SizedBox(height: 24),

          /// Data
          OutlinedButton.icon(
            onPressed: _selectDate,
            icon: const Icon(Icons.calendar_today),
            label: Text(
              selectedDate == null
                  ? 'Escolher data'
                  : 'Data: ${formatter.format(selectedDate!)}',
            ),
          ),

          const Spacer(),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: loading ? null : _submit,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text('Solicitar Serviço'),
            ),
          ),

        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() => selectedDate = date);
    }
  }

  Future<void> _submit() async {
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione a data do serviço')),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final user = await SecureStorageService.getLoggedUser();

      if (user == null) throw Exception('Usuário não autenticado');

      await _service.createRequest(
        usuarioSolicitanteId: user.id!,
        usuarioPrestadorId: widget.servico.usuario!.id!,
        servicoOferecidoId: widget.servico.id!,
        dataRealizacao: selectedDate!,
      );

      if (!mounted) return;

      await showAppDialog(
        context,
        title: 'Sucesso!',
        message: 'Requisição enviada com sucesso',
      );

      Navigator.pop(context);

    } catch (e) {
      await showAppDialog(
          context,
          title: 'Erro',
          message: e.toString().replaceAll('Exception: ', ''),
          isError: true,
        );
    } finally {
      setState(() => loading = false);
    }
  }
}
