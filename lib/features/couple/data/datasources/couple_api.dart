import 'package:couple_schedule_app/core/network/dio_client.dart';
import 'package:couple_schedule_app/features/couple/data/models/couple_response.dart';
import 'package:dio/dio.dart';

class CoupleApi {
  final Dio _dio;

  CoupleApi({Dio? dio}) : _dio = dio ?? DioClient.dio;

  Future<CoupleResponse> getMyCouple() async {
    final response = await _dio.get('/api/couples/me');

    return CoupleResponse.fromJson(response.data as Map<String, dynamic>);
  }
}
