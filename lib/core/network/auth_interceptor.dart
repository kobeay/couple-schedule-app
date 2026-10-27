import 'package:couple_schedule_app/core/storage/token_storage.dart';
import 'package:couple_schedule_app/features/auth/data/datasources/auth_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  final AuthApi _authApi;
  final Dio _dio;

  Future<void>? _refreshFuture;

  AuthInterceptor(this._tokenStorage, this._authApi, this._dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_isPublicAuthRequest(options.path)) {
      return handler.next(options);
    }

    final token = await _tokenStorage.getAccessToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  bool _isPublicAuthRequest(String path) {
    return path.endsWith('/api/users/login') ||
        path.endsWith('/api/users/signup') ||
        path.endsWith('/api/users/refresh');
  }

  Future<void> _refreshTokens() async {
    final refreshToken = await _tokenStorage.getRefreshToken();

    if (refreshToken == null) {
      throw StateError('Refresh Token이 없습니다.');
    }

    try {
      final tokens = await _authApi.refresh(refreshToken);

      await _tokenStorage.saveAccessToken(tokens.accessToken);
      await _tokenStorage.saveRefreshToken(tokens.refreshToken);

      debugPrint('토큰 재발급 성공');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await _tokenStorage.deleteToken();
      }

      rethrow;
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;

    if (err.response?.statusCode != 401 ||
        options.extra['retried'] == true ||
        _isPublicAuthRequest(options.path)) {
      return handler.next(err);
    }

    try {
      final oldAccessToken = options.headers['Authorization'];

      final currentAccessToken = await _tokenStorage.getAccessToken();

      if (currentAccessToken == null) {
        return handler.next(err);
      }

      if (_refreshFuture != null ||
          oldAccessToken == 'Bearer $currentAccessToken') {
        final refreshFuture = _refreshFuture ??= _refreshTokens();

        try {
          await refreshFuture;
        } finally {
          if (identical(_refreshFuture, refreshFuture)) {
            _refreshFuture = null;
          }
        }
      }

      final newAccessToken = await _tokenStorage.getAccessToken();

      if (newAccessToken == null) {
        return handler.next(err);
      }

      options.headers['Authorization'] = 'Bearer $newAccessToken';

      options.extra['retried'] = true;

      final response = await _dio.fetch<dynamic>(options);

      return handler.resolve(response);
    } catch (e) {
      debugPrint('토큰 재발급 또는 API 재요청 실패: $e');

      return handler.next(err);
    }
  }
}
