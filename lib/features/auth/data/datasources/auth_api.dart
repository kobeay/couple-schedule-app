import 'package:couple_schedule_app/core/network/dio_client.dart';
import 'package:couple_schedule_app/features/auth/data/models/sign_up_request.dart';
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
}
