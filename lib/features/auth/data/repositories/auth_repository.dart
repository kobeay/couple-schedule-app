import 'package:couple_schedule_app/core/storage/token_storage.dart';
import 'package:couple_schedule_app/features/auth/data/datasources/auth_api.dart';
import 'package:couple_schedule_app/features/auth/data/models/login_request.dart';
import 'package:couple_schedule_app/features/auth/data/models/login_response.dart';
import 'package:couple_schedule_app/features/auth/data/models/sign_up_request.dart';
import 'package:couple_schedule_app/features/auth/data/models/user_response.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  final AuthApi _authApi;
  final TokenStorage _tokenStorage;

  AuthRepository({AuthApi? authApi, TokenStorage? tokenStorage})
    : _authApi = authApi ?? AuthApi(),
      _tokenStorage = tokenStorage ?? TokenStorage();

  Future<void> signUp(SignUpRequest request) async {
    await _authApi.signUp(request);
  }

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _authApi.login(request);

    await _tokenStorage.saveAccessToken(response.accessToken);
    await _tokenStorage.saveRefreshToken(response.refreshToken);

    return response;
  }

  Future<bool> checkAuthLogin() async {
    final token = await _tokenStorage.getAccessToken();

    if (token == null) {
      return false;
    }

    try {
      await _authApi.getMyInfo();

      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await _tokenStorage.deleteToken();

        return false;
      }

      rethrow;
    }
  }

  Future<UserResponse> getMyInfo() async {
    return await _authApi.getMyInfo();
  }
}
