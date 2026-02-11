import 'package:dio/dio.dart';
import 'package:skillhub_app/model/servico.dart';
import 'package:skillhub_app/model/servico_oferecido.dart';
import 'package:skillhub_app/model/token_user.dart';
import 'package:skillhub_app/network/dio_client.dart';
import 'package:skillhub_app/util/secure_storage_service.dart';

class ServiceAvailableService {
  final String _baseUrl = 'servicos-oferecidos';

  final Dio _dio = DioClient.dio;

  Future<List<ServicoOferecido>> fetchAllServices() async {
    final response = await _dio.get(_baseUrl);

    if (response.statusCode == 200) {
      final List data = response.data;
      return data.map((e) => ServicoOferecido.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load services');
    }
  }

  Future<List<ServicoOferecido>> fetchMyServices() async {
    final response = await _dio.get('$_baseUrl/meus');

    if (response.statusCode == 200) {
      final List data = response.data;
      return data.map((e) => ServicoOferecido.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load services');
    }
  }

  Future<void> createService({
    required String nome,
    required String descricao,
    required double valor,
    required Servico servicoSelecionado,
  }) async {
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

    final response = await _dio.post(_baseUrl, data: body);

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Erro ao criar serviço oferecido');
    }
  }
}
