import 'package:couple_schedule_app/core/network/dio_client.dart';
import 'package:couple_schedule_app/features/auth/data/models/login_request.dart';
import 'package:couple_schedule_app/features/auth/data/models/login_response.dart';
import 'package:couple_schedule_app/features/auth/data/models/sign_up_request.dart';
import 'package:couple_schedule_app/features/auth/data/models/user_response.dart';
import 'package:dio/dio.dart';

class AuthApi {
  final Dio _dio;

  AuthApi({Dio? dio}) : _dio = dio ?? DioClient.dio;

  Future<Response<dynamic>> signUp(SignUpRequest request) async {
    final response = await _dio.post(
      '/api/users/signup',
      data: request.toJson(),
    );

    return response;
  }

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _dio.post(
      '/api/users/login',
      data: request.toJson(),
    );

    return LoginResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<UserResponse> getMyInfo() async {
    final response = await _dio.get('/api/users/me');
    return UserResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<LoginResponse> refresh(String refreshToken) async {
    final response = await _dio.post(
      '/api/users/refresh',
      data: {'refreshToken': refreshToken},
    );

    return LoginResponse.fromJson(response.data as Map<String, dynamic>);
  }
}
