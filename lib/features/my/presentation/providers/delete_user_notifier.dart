import 'dart:async';

import 'package:couple_schedule_app/features/auth/presentation/providers/token_storage_provider.dart';
import 'package:couple_schedule_app/features/my/presentation/providers/my_repository_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deleteUserNotifier = AsyncNotifierProvider<DeleteUserNotifier, void>(
  DeleteUserNotifier.new,
);

class DeleteUserNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> deleteUser() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(myRepositoryProvider);
      final tokenStorage = ref.read(tokenStorageProvider);

      await repository.deleteUser();

      await tokenStorage.deleteToken();
    });

    if (state.hasError) {
      final error = state.error;

      if (error is DioException) {
        debugPrint('상태 코드: ${error.response?.statusCode}');
        debugPrint('서버 응답: ${error.response?.data}');
      } else {
        debugPrint('회원탈퇴 실패: $error');
      }
    }
  }
}
