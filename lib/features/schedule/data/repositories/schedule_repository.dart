import 'package:couple_schedule_app/features/schedule/data/datasources/schedule_api.dart';
import 'package:couple_schedule_app/features/schedule/data/models/schedule_create_request.dart';
import 'package:couple_schedule_app/features/schedule/data/models/schedule_list_response.dart';

class ScheduleRepository {
  final ScheduleApi _scheduleApi;

  ScheduleRepository({ScheduleApi? scheduleApi})
    : _scheduleApi = scheduleApi ?? ScheduleApi();

  Future<void> createSchedule(ScheduleCreateRequest request) {
    return _scheduleApi.createSchedule(request);
  }

  Future<List<ScheduleListResponse>> getMonthlySchedules(int year, int month) {
    return _scheduleApi.getMonthlySchedules(year, month);
  }
}
