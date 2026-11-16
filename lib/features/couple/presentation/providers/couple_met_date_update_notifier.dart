import 'dart:async';

import 'package:couple_schedule_app/features/couple/data/models/couple_met_date_update_request.dart';
import 'package:couple_schedule_app/features/couple/presentation/providers/couple_provider.dart';
import 'package:couple_schedule_app/features/couple/presentation/providers/couple_repository_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final coupleMetDateUpdateNotifier =
    AsyncNotifierProvider<CoupleMetDateUpdateNotifier, void>(
      CoupleMetDateUpdateNotifier.new,
    );

class CoupleMetDateUpdateNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> updateMetDate(CoupleMetDateUpdateRequest request) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(coupleRepositoryProvider);

      await repository.updateMetDate(request);
    });

    if (state.hasError) {
      final error = state.error;

      if (error is DioException) {
        debugPrint('상태 코드: ${error.response?.statusCode}');
        debugPrint('서버 응답: ${error.response?.data}');
      }
    } else {
      ref.invalidate(coupleProvider);
    }
  }
}
