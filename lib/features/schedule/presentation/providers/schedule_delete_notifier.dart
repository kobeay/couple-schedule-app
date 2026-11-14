import 'dart:async';

import 'package:couple_schedule_app/features/schedule/presentation/providers/monthly_schedules_provider.dart';
import 'package:couple_schedule_app/features/schedule/presentation/providers/schedule_repository_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final scheduleDeleteNotifier =
    AsyncNotifierProvider<ScheduleDeleteNotifier, void>(
      ScheduleDeleteNotifier.new,
    );

class ScheduleDeleteNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> deleteSchedule(int scheduleId) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(scheduleRepositoryProvider);

      await repository.deleteSchedule(scheduleId);
    });

    if (state.hasError) {
      final error = state.error;

      if (error is DioException) {
        debugPrint('상태 코드: ${error.response?.statusCode}');
        debugPrint('서버 응답: ${error.response?.data}');
      }
    } else {
      ref.invalidate(monthlySchedulesProvider);
    }
  }
}
