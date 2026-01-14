import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skillhub_app/model/servico.dart';
import 'package:skillhub_app/model/servico_oferecido.dart';
import 'package:skillhub_app/model/token_user.dart';
import 'package:skillhub_app/util/ApiUrl.dart';
import 'package:skillhub_app/util/secure_storage_service.dart';

class ServiceAvailableService {

  final String _baseUrl = '${ApiUrl.BASE_URL}servicos-oferecidos';

  Future<List<ServicoOferecido>> fetchAllServices() async {
    final token = await SecureStorageService.getAccessToken();

    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => ServicoOferecido.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load services');
    }
  }

  Future<List<ServicoOferecido>> fetchMyServices() async {
    final token = await SecureStorageService.getAccessToken();

    final response = await http.get(
      Uri.parse('$_baseUrl/meus'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => ServicoOferecido.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load services');
    }
  }

  /// 🔹 Criar novo serviço oferecido
  Future<void> createService({
    required String nome,
    required String descricao,
    required double valor,
    required Servico servicoSelecionado,
  }) async {
    final token = await SecureStorageService.getAccessToken();
    final TokenUser? user = await SecureStorageService.getLoggedUser();

    if (user == null) {
      throw Exception('Usuário não autenticado');
    }

    final body = {
      'nome': nome,
      'descricao': descricao,
      'valor': valor,
      'ativo': true,
      'servico': {'id': servicoSelecionado.id},
      'usuario': {'id': user.id},
    };

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Erro ao criar serviço oferecido');
    }
  }
}
