import 'package:couple_schedule_app/features/schedule/data/models/schedule_list_response.dart';
import 'package:couple_schedule_app/features/schedule/presentation/providers/schedule_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final monthlySchedulesProvider =
    FutureProvider.family<List<ScheduleListResponse>, ({int year, int month})>((
      ref,
      date,
    ) {
      final repository = ref.read(scheduleRepositoryProvider);

      return repository.getMonthlySchedules(date.year, date.month);
    });
