import 'dart:async';

import 'package:couple_schedule_app/features/auth/presentation/providers/user_info_provider.dart';
import 'package:couple_schedule_app/features/my/data/models/user_nickname_update_request.dart';
import 'package:couple_schedule_app/features/my/presentation/providers/my_repository_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nicknameUpdateNotifier =
    AsyncNotifierProvider<NicknameUpdateNotifier, void>(
      NicknameUpdateNotifier.new,
    );

class NicknameUpdateNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> updateNickname(UserNicknameUpdateRequest request) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(myRepositoryProvider);

      await repository.updateNickname(request);
    });

    if (state.hasError) {
      final error = state.error;

      if (error is DioException) {
        debugPrint('상태 코드: ${error.response?.statusCode}');
        debugPrint('서버 응답: ${error.response?.data}');
      } else {
        debugPrint('내 프로필 정보 수정 실패: $error');
      }
    } else {
      ref.invalidate(userInfoProvider);
    }
  }
}
