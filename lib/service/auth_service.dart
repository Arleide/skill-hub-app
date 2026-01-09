import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:skillhub_app/util/ApiUrl.dart';

class AuthService {
  final String url = '${ApiUrl.BASE_URL}auth/register';

  Future<void> register({
    required String nome,
    required String email,
    required String senha,
  }) async {
    try {
      final response = await http
          .post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nome': nome,
          'email': email,
          'senha': senha,
        }),
      )
          .timeout(const Duration(seconds: 5));

      print(response);
    } on SocketException {
      throw Exception('Erro de conexão. Verifique sua internet ou a API.');
    } on TimeoutException {
      throw Exception('Tempo de resposta esgotado. A API demorou demais.');
    } catch (e) {
      throw Exception('Erro inesperado: $e');
    }
  }
}