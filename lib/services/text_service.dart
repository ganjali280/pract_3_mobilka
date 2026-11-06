import 'package:dio/dio.dart';

class TextService {
  final Dio _dio;

  TextService(this._dio);

  Future<String> randomFact() => _load('/facts', 'fact');

  Future<String> randomJoke() => _load('/jokes', 'joke');

  Future<String> _load(String path, String field) async {
    try {
      final response = await _dio.get(path);
      final data = response.data as List;
      if (data.isEmpty) {
        throw Exception('Пустой ответ от сервера');
      }
      return data.first[field].toString();
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      if (code == 401 || code == 403) {
        throw Exception('Неверный API-ключ или нет доступа к этому запросу');
      }
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Нет соединения с интернетом');
      }
      throw Exception('Ошибка запроса: ${code ?? e.message}');
    }
  }
}