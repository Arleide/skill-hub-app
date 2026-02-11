import 'package:dio/dio.dart';
import 'package:skillhub_app/service/auth_service.dart';
import 'package:skillhub_app/util/secure_storage_service.dart';

class DioInterceptor extends Interceptor {
  final Dio dio;
  final AuthService _authService = AuthService();

  bool _isRefreshing = false;
  final List<Function> _queue = [];

  DioInterceptor(this.dio);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.path.contains('/auth/refresh')) {
      options.headers.remove('Authorization');
      handler.next(options);
      return;
    }

    final token = await SecureStorageService.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {

    if ((err.response?.statusCode == 401 || err.response?.statusCode == 403) &&
        !err.requestOptions.path.contains('/auth/refresh')) {

      if (_isRefreshing) {
        return Future(() {
          _queue.add(() async {
            final newToken = await SecureStorageService.getAccessToken();
            err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
            final response = await dio.fetch(err.requestOptions);
            handler.resolve(response);
          });
        });
      }

      _isRefreshing = true;

      try {
        final refreshed = await _authService.refreshToken();

        if (refreshed) {
          final newToken = await SecureStorageService.getAccessToken();
          print('TOKEN ATUALIZADO');
          for (var callback in _queue) {
            callback();
          }
          _queue.clear();

          err.requestOptions.headers['Authorization'] = 'Bearer $newToken';

          final response = await dio.fetch(err.requestOptions);
          return handler.resolve(response);
        }
      } catch (_) {
        await SecureStorageService.clear();
      } finally {
        _isRefreshing = false;
      }
    }
    handler.next(err);
  }
}
