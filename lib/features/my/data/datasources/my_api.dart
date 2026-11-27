import 'package:couple_schedule_app/core/network/dio_client.dart';
import 'package:couple_schedule_app/features/my/data/models/user_nickname_update_request.dart';
import 'package:dio/dio.dart';

class MyApi {
  final Dio _dio;

  MyApi({Dio? dio}) : _dio = dio ?? DioClient.dio;

  Future<void> updateNickname(UserNicknameUpdateRequest request) async {
    await _dio.patch('/api/users/me/nickname', data: request.toJson());
  }

  Future<void> deleteUser() async {
    await _dio.delete('/api/users/me');
  }

  Future<void> registerProfileImage(String filePath) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });

    await _dio.post('/api/users/me/profile-image', data: formData);
  }
}
