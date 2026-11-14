import 'package:couple_schedule_app/features/schedule/data/models/schedule_type.dart';

class ScheduleListResponse {
  final int id;
  final int userId;
  final String title;
  final DateTime date;
  final String? startTime;
  final String? endTime;
  final String? memo;
  final ScheduleType type;

  const ScheduleListResponse({
    required this.id,
    required this.userId,
    required this.title,
    required this.date,
    this.startTime,
    this.endTime,
    this.memo,
    required this.type,
  });

  factory ScheduleListResponse.fromJson(Map<String, dynamic> json) {
    return ScheduleListResponse(
      id: json['id'] as int,
      userId: json['userId'] as int,
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      memo: json['memo'] as String?,
      type: ScheduleType.values.byName((json['type'] as String).toLowerCase()),
    );
  }
}
