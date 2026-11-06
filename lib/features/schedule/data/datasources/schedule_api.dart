import 'package:couple_schedule_app/core/network/dio_client.dart';
import 'package:couple_schedule_app/features/schedule/data/models/schedule_create_request.dart';
import 'package:dio/dio.dart';

class ScheduleApi {
  final Dio _dio;

  ScheduleApi({Dio? dio}) : _dio = dio ?? DioClient.dio;

  Future<void> createSchedule(ScheduleCreateRequest request) async {
    await _dio.post('/api/schedules', data: request.toJson());
  }
}
