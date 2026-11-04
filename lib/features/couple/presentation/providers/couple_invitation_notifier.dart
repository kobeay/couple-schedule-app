import 'dart:async';

import 'package:couple_schedule_app/features/couple/data/models/couple_invitation_request.dart';
import 'package:couple_schedule_app/features/couple/presentation/providers/couple_repository_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final coupleInvitationProvider =
    AsyncNotifierProvider<CoupleInvitationNotifier, void>(
      CoupleInvitationNotifier.new,
    );

class CoupleInvitationNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> sendInvitation(CoupleInvitationRequest request) async {
    state = AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(coupleRepositoryProvider);
      await repository.sendInvitation(request);
    });

    if (state.hasError) {
      final error = state.error;

      if (error is DioException) {
        debugPrint('상태 코드: ${error.response?.statusCode}');
        debugPrint('서버 응답: ${error.response?.data}');
      } else {
        debugPrint('초대 코드 요청 실패: $error');
      }
    }
  }
}
