import 'dart:async';

import 'package:couple_schedule_app/features/auth/data/models/refresh_request.dart';
import 'package:couple_schedule_app/features/auth/presentation/providers/auth_repository_provider.dart';
import 'package:couple_schedule_app/features/auth/presentation/providers/token_storage_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final logoutNotifier = AsyncNotifierProvider<LogoutNotifier, void>(
  LogoutNotifier.new,
);

class LogoutNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> logout() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      final tokenStorage = ref.read(tokenStorageProvider);

      try {
        final refreshToken = await tokenStorage.getRefreshToken();

        if (refreshToken != null) {
          final request = RefreshRequest(refreshToken: refreshToken);

          await repository.logout(request);
        }
      } catch (error) {
        debugPrint('서버 로그아웃 처리 실패: $error');
      }

      await tokenStorage.deleteToken();
    });

    if (state.hasError) {
      final error = state.error;

      if (error is DioException) {
        debugPrint('상태 코드: ${error.response?.statusCode}');
        debugPrint('서버 응답: ${error.response?.data}');
      } else {
        debugPrint('로그아웃 실패: $error');
      }
    }
  }
}
