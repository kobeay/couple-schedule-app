import 'dart:async';

import 'package:couple_schedule_app/features/auth/data/models/sign_up_request.dart';
import 'package:couple_schedule_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final signUpProvider = AsyncNotifierProvider<SignUpProvider, void>(
  SignUpProvider.new,
);

class SignUpProvider extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> signUp(SignUpRequest request) async {
    state = AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      await repository.signUp(request);
    });

    if (state.hasError) {
      final error = state.error;

      if (error is DioException) {
        debugPrint('상태 코드: ${error.response?.statusCode}');
        debugPrint('서버 응답: ${error.response?.data}');
      } else {
        debugPrint('회원가입 실패: $error');
      }
    }
  }
}
