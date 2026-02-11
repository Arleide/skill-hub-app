import 'package:dio/dio.dart';
import 'package:skillhub_app/network/dio_interceptor.dart';
import 'package:skillhub_app/util/ApiUrl.dart';

class DioClient {

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiUrl.BASE_URL,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      validateStatus: (status) {
        return status != null && status >= 200 && status < 300;
      },
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  static void setup() {
    dio.interceptors.add(DioInterceptor(dio));
  }
}
