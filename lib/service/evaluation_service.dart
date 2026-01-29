import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skillhub_app/model/avaliacao.dart';
import 'package:skillhub_app/util/ApiUrl.dart';
import 'package:skillhub_app/util/secure_storage_service.dart';

class EvaluationService {
  final String _baseUrl = '${ApiUrl.BASE_URL}avaliacoes';


  Future<void> createEvaluation(Avaliacao avaliacao) async {
    final token = await SecureStorageService.getAccessToken();

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(avaliacao.toJson()),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Erro ao criar avaliação');
    }
  }


  Future<Avaliacao> fetchById(int id) async {
    final token = await SecureStorageService.getAccessToken();

    final response = await http.get(
      Uri.parse('$_baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return Avaliacao.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao buscar avaliação');
    }
  }


  Future<Avaliacao?> fetchBySolicitacaoServico(int solicitacaoId) async {
    final token = await SecureStorageService.getAccessToken();

    final response = await http.get(
      Uri.parse('$_baseUrl/solicitacao/$solicitacaoId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return Avaliacao.fromJson(jsonDecode(response.body));
    }

    if (response.statusCode == 204) {
      return null;
    }

    throw Exception('Erro ao buscar avaliação da solicitação');
  }
}
