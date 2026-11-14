import 'dart:async';

import 'package:couple_schedule_app/features/schedule/data/models/schedule_create_request.dart';
import 'package:couple_schedule_app/features/schedule/presentation/providers/monthly_schedules_provider.dart';
import 'package:couple_schedule_app/features/schedule/presentation/providers/schedule_repository_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final scheduleCreateNotifier =
    AsyncNotifierProvider<ScheduleCreateNotifier, void>(
      ScheduleCreateNotifier.new,
    );

class ScheduleCreateNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> createSchedule(ScheduleCreateRequest request) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(scheduleRepositoryProvider);

      await repository.createSchedule(request);
    });

    if (state.hasError) {
      final error = state.error;

      if (error is DioException) {
        debugPrint('상태 코드: ${error.response?.statusCode}');
        debugPrint('서버 응답: ${error.response?.data}');
      } else {
        debugPrint('일정 추가 실패: $error');
      }
    } else {
      ref.invalidate(monthlySchedulesProvider);
    }
  }
}
