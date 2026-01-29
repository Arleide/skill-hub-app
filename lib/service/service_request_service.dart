import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skillhub_app/model/solicitacao_servico.dart';
import 'package:skillhub_app/util/ApiUrl.dart';
import 'package:skillhub_app/util/secure_storage_service.dart';

class ServiceRequestService {
  final String _baseUrl = '${ApiUrl.BASE_URL}solicitacoes-servicos';

  Future<void> createRequest({
    required int usuarioSolicitanteId,
    required int usuarioPrestadorId,
    required int servicoOferecidoId,
    required DateTime dataRealizacao,
  }) async {
    final token = await SecureStorageService.getAccessToken();

    final body = {
      'usuarioSolicitante': {'id': usuarioSolicitanteId},
      'usuarioPrestador': {'id': usuarioPrestadorId},
      'servicoOferecido': {'id': servicoOferecidoId},
      'status': 'ABERTA',
      'dataRealizacao': dataRealizacao.toIso8601String(),
    };

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Erro ao solicitar serviço');
    }
  }

  Future<List<SolicitacaoServico>> fetchSentRequests() async {
    final token = await SecureStorageService.getAccessToken();

    final response = await http.get(
      Uri.parse('$_baseUrl/enviadas'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => SolicitacaoServico.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao carregar solicitações enviadas');
    }
  }

  Future<List<SolicitacaoServico>> fetchReceivedRequests() async {
    final token = await SecureStorageService.getAccessToken();

    final response = await http.get(
      Uri.parse('$_baseUrl/recebidas'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => SolicitacaoServico.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao carregar solicitações recebidas');
    }
  }

  Future<void> updateRequestStatus({
    required int requestId,
    required String status,
  }) async {
    final token = await SecureStorageService.getAccessToken();

    final response = await http.put(
      Uri.parse('$_baseUrl/$requestId/status'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar status da solicitação');
    }
  }
}
