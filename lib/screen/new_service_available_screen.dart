import 'package:flutter/material.dart';
import 'package:skillhub_app/model/servico.dart';
import 'package:skillhub_app/service/service_available_service.dart';
import 'package:skillhub_app/service/servico_service.dart';
import 'package:skillhub_app/util/dialog_helper.dart';

class NewServiceAvailableScreen extends StatefulWidget {
  const NewServiceAvailableScreen({super.key});

  @override
  State<NewServiceAvailableScreen> createState() =>
      _NewServiceAvailableScreenState();
}

class _NewServiceAvailableScreenState extends State<NewServiceAvailableScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController valorController = TextEditingController();

  final ServiceAvailableService _serviceAvailableService =
      ServiceAvailableService();

  final ServicoService _servicoService = ServicoService();

  List<Servico> servicos = [];
  Servico? servicoSelecionado;

  bool loading = false;
  bool loadingServicos = true;

  @override
  void initState() {
    super.initState();
    _loadServicos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _body());
  }

  Widget? _body() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Novo Serviço',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white
        ),
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
      body: loadingServicos
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _input(label: 'Service name', controller: nomeController),
                    const SizedBox(height: 16),
                    _input(
                      label: 'Description',
                      controller: descricaoController,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    _input(
                      label: 'Price (R\$)',
                      controller: valorController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    _dropdownServicos(),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: loading ? null : _salvar,
                        child: loading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Save service'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _input({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: (value) =>
          value == null || value.isEmpty ? 'Required field' : null,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _dropdownServicos() {
    return DropdownButtonFormField<Servico>(
      value: servicoSelecionado,
      items: servicos
          .map((s) => DropdownMenuItem(value: s, child: Text(s.nome ?? '')))
          .toList(),
      onChanged: (value) {
        setState(() {
          servicoSelecionado = value;
        });
      },
      validator: (value) => value == null ? 'Select a service' : null,
      decoration: InputDecoration(
        labelText: 'Service type',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _loadServicos() async {
    try {
      final result = await _servicoService.fetchServicos();
      setState(() {
        servicos = result;
        loadingServicos = false;
      });
    } catch (e) {
      loadingServicos = false;
      debugPrint(e.toString());
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    if (servicoSelecionado == null) {
      await showAppDialog(
        context,
        title: 'Atenção',
        message: 'Serviço é obrigatórios',
        isError: true,
      );
      return;
    }

    try {
      setState(() => loading = true);

      await _serviceAvailableService.createService(
        nome: nomeController.text,
        descricao: descricaoController.text,
        valor: double.parse(valorController.text.replaceAll(',', '.')),
        servicoSelecionado: servicoSelecionado!,
      );

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {

      await showAppDialog(
        context,
        title: 'Erro',
        message: 'Erro ao salvar$e',
        isError: true,
      );

    } finally {
      setState(() => loading = false);
    }
  }
}
