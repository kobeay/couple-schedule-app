import 'package:couple_schedule_app/features/schedule/data/repositories/schedule_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final scheduleRepositoryProvider = Provider<ScheduleRepository>((ref) {
  return ScheduleRepository();
});
