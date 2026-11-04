import 'dart:async';

import 'package:couple_schedule_app/features/couple/presentation/providers/couple_provider.dart';
import 'package:couple_schedule_app/features/couple/presentation/providers/couple_repository_provider.dart';
import 'package:couple_schedule_app/features/couple/presentation/providers/received_invitations_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final coupleInvitationActionProvider =
    AsyncNotifierProvider<CoupleInvitationActionNotifier, void>(
      CoupleInvitationActionNotifier.new,
    );

class CoupleInvitationActionNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> acceptInvitation(int invitationId) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(coupleRepositoryProvider);

      await repository.acceptInvitation(invitationId);
    });

    if (state.hasError) {
      final error = state.error;

      if (error is DioException) {
        debugPrint('상태 코드: ${error.response?.statusCode}');
        debugPrint('서버 응답: ${error.response?.data}');
      } else {
        debugPrint('초대 수락 실패: $error');
      }
    } else {
      ref.invalidate(receivedInvitaionsProvider);
      ref.invalidate(coupleProvider);
    }
  }

  Future<void> rejectInvitation(int invitationId) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(coupleRepositoryProvider);

      await repository.rejectInvitation(invitationId);
    });

    if (state.hasError) {
      final error = state.error;

      if (error is DioException) {
        debugPrint('상태 코드: ${error.response?.statusCode}');
        debugPrint('서버 응답: ${error.response?.data}');
      } else {
        debugPrint('초대 거절 실패: $error');
      }
    } else {
      ref.invalidate(receivedInvitaionsProvider);
    }
  }
}
