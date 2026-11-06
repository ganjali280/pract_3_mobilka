import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

const String apiKey = 'Y7Hca5fNCxYbCJ8PRwnZDdEwdY2s0ljhy09id4NC';

class AuthInterceptor extends Interceptor {
  final String token;

  AuthInterceptor(this.token);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['X-Api-Key'] = token;
    handler.next(options);
  }
}

Dio createDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.api-ninjas.com/v1',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  dio.interceptors.addAll([
    AuthInterceptor(apiKey),
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
    ),
  ]);

  return dio;
}