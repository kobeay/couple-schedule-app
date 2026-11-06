import 'package:couple_schedule_app/features/schedule/data/datasources/schedule_api.dart';
import 'package:couple_schedule_app/features/schedule/data/models/schedule_create_request.dart';

class ScheduleRepository {
  final ScheduleApi _scheduleApi;

  ScheduleRepository({ScheduleApi? scheduleApi})
    : _scheduleApi = scheduleApi ?? ScheduleApi();

  Future<void> createSchedule(ScheduleCreateRequest request) {
    return _scheduleApi.createSchedule(request);
  }
}
