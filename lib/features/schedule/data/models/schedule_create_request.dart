import 'package:couple_schedule_app/features/schedule/data/models/schedule_type.dart';

class ScheduleCreateRequest {
  final String title;
  final DateTime date;
  final String? startTime;
  final String? endTime;
  final String? memo;
  final ScheduleType type;

  const ScheduleCreateRequest({
    required this.title,
    required this.date,
    this.startTime,
    this.endTime,
    this.memo,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date.toIso8601String().split('T')[0],
      'startTime': startTime,
      'endTime': endTime,
      'memo': memo,
      'type': type.name.toUpperCase(),
    };
  }
}
