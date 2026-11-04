import 'dart:async';

import 'package:couple_schedule_app/features/couple/presentation/providers/couple_provider.dart';
import 'package:couple_schedule_app/features/couple/presentation/providers/couple_repository_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final coupleDisconnectionNotifier =
    AsyncNotifierProvider<CoupleDisconnectionNotifier, void>(
      CoupleDisconnectionNotifier.new,
    );

class CoupleDisconnectionNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> disconnectCouple() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(coupleRepositoryProvider);

      await repository.disconnectCouple();
    });

    if (state.hasError) {
      final error = state.error;

      if (error is DioException) {
        debugPrint('상태 코드: ${error.response?.statusCode}');
        debugPrint('서버 응답: ${error.response?.data}');
      } else {
        debugPrint('커플 연결 해제 실패: $error');
      }
    } else {
      ref.invalidate(coupleProvider);
    }
  }
}
