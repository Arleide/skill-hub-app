import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skillhub_app/model/servico.dart';
import 'package:skillhub_app/util/ApiUrl.dart';
import 'package:skillhub_app/util/secure_storage_service.dart';

class ServicoService {
  final String _baseUrl = '${ApiUrl.BASE_URL}servicos';

  Future<List<Servico>> fetchServicos() async {
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
      return data.map((e) => Servico.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao carregar serviços');
    }
  }
}
