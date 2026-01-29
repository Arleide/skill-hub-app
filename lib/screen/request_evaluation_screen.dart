import 'package:flutter/material.dart';
import 'package:skillhub_app/model/avaliacao.dart';
import 'package:skillhub_app/model/solicitacao_servico.dart';
import 'package:skillhub_app/service/evaluation_service.dart';

class RequestEvaluationScreen extends StatefulWidget {
  final SolicitacaoServico solicitacao;

  const RequestEvaluationScreen({
    super.key,
    required this.solicitacao,
  });

  @override
  State<RequestEvaluationScreen> createState() =>
      _RequestEvaluationScreenState();
}

class _RequestEvaluationScreenState extends State<RequestEvaluationScreen> {
  final EvaluationService _evaluationService = EvaluationService();
  final TextEditingController _commentController = TextEditingController();

  Avaliacao? _avaliacaoExistente;
  bool _loading = true;
  bool _readOnly = false;

  int _rating = 5;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadEvaluation();
  }

  @override
  Widget build(BuildContext context) {
    final servico = widget.solicitacao.servicoOferecido;

    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Avaliar Serviço'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Serviço
            Text(
              servico?.nome ?? 'Serviço',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              servico?.descricao ?? '',
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 24),

            /// 🔹 Nota
            const Text(
              'Nota',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(5, (index) {
                final value = index + 1;
                return _readOnly
                    ? Icon(
                  Icons.star,
                  color: value <= _rating ? Colors.amber : Colors.grey,
                )
                    : IconButton(
                  icon: Icon(
                    Icons.star,
                    color:
                    value <= _rating ? Colors.amber : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() => _rating = value);
                  },
                );
              }),
            ),

            const SizedBox(height: 24),

            /// 🔹 Comentário
            const Text(
              'Comentário',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _commentController,
              maxLines: 4,
              enabled: !_readOnly,
              decoration: const InputDecoration(
                hintText: 'Descreva sua experiência',
                border: OutlineInputBorder(),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_saving || _readOnly) ? null : _saveEvaluation,
                child: _readOnly
                    ? const Text('Avaliação já enviada')
                    : _saving
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text('Salvar Avaliação'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadEvaluation() async {
    try {
      final avaliacao = await _evaluationService
          .fetchBySolicitacaoServico(widget.solicitacao.id!);

      if (avaliacao != null) {
        _avaliacaoExistente = avaliacao;
        _rating = avaliacao.nota ?? 5;
        _commentController.text = avaliacao.comentario ?? '';
        _readOnly = true;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _saveEvaluation() async {
    setState(() => _saving = true);

    try {
      final avaliacao = Avaliacao(
        solicitacaoServico: widget.solicitacao,
        usuarioAvaliador: widget.solicitacao.usuarioSolicitante,
        nota: _rating,
        comentario: _commentController.text,
      );

      await _evaluationService.createEvaluation(avaliacao);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Avaliação enviada com sucesso')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      debugPrint(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao enviar avaliação')),
      );
    } finally {
      setState(() => _saving = false);
    }
  }
}
