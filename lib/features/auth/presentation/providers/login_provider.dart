import 'dart:async';

import 'package:couple_schedule_app/features/auth/data/models/login_request.dart';
import 'package:couple_schedule_app/features/auth/data/models/login_response.dart';
import 'package:couple_schedule_app/features/auth/presentation/providers/auth_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginProvider = AsyncNotifierProvider<LoginProvider, LoginResponse?>(
  LoginProvider.new,
);

class LoginProvider extends AsyncNotifier<LoginResponse?> {
  @override
  FutureOr<LoginResponse?> build() {
    return null;
  }

  Future<void> login(LoginRequest request) async {
    state = AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      return await repository.login(request);
    });
  }
}
