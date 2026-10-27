import 'package:couple_schedule_app/core/network/auth_interceptor.dart';
import 'package:couple_schedule_app/core/storage/token_storage.dart';
import 'package:couple_schedule_app/features/auth/data/datasources/auth_api.dart';
import 'package:dio/dio.dart';

class DioClient {
  static final BaseOptions _options = BaseOptions(
    baseUrl: 'http://127.0.0.1:8080',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    contentType: Headers.jsonContentType,
  );

  static final Dio dio = Dio(_options);

  static final Dio refreshDio = Dio(_options);

  static void initialize() {
    dio.interceptors.add(
      AuthInterceptor(TokenStorage(), AuthApi(dio: refreshDio), dio),
    );
  }
}
