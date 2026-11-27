import 'dart:async';

import 'package:couple_schedule_app/features/auth/presentation/providers/user_info_provider.dart';
import 'package:couple_schedule_app/features/my/presentation/providers/my_repository_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final updateProfileImageNotifier =
    AsyncNotifierProvider<UpdateProfileImageNotifier, void>(
      UpdateProfileImageNotifier.new,
    );

class UpdateProfileImageNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> updateProfileImage(String filePath) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(myRepositoryProvider);

      await repository.updateProfileImage(filePath);
    });

    if (state.hasError) {
      final error = state.error;

      if (error is DioException) {
        debugPrint('상태 코드: ${error.response?.statusCode}');
        debugPrint('서버 응답: ${error.response?.data}');
      } else {
        debugPrint('내 프로필 이미지 수정 실패: $error');
      }
    } else {
      ref.invalidate(userInfoProvider);
    }
  }
}
