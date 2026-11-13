import 'dart:async';

import 'package:couple_schedule_app/features/schedule/data/models/schedule_update_request.dart';
import 'package:couple_schedule_app/features/schedule/presentation/providers/schedule_repository_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final scheduleUpdateNotifier =
    AsyncNotifierProvider<ScheduleUpdateNotifier, void>(
      ScheduleUpdateNotifier.new,
    );

class ScheduleUpdateNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> updateSchedule(
    ScheduleUpdateRequest request,
    int scheduleId,
  ) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(scheduleRepositoryProvider);

      await repository.updateSchedule(request, scheduleId);
    });

    if (state.hasError) {
      final error = state.error;

      if (error is DioException) {
        debugPrint('상태 코드: ${error.response?.statusCode}');
        debugPrint('서버 응답: ${error.response?.data}');
      } else {
        debugPrint('일정 수정 실패: $error');
      }
    }
  }
}
