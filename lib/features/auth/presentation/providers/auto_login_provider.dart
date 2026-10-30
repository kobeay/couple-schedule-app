import 'dart:async';

import 'package:couple_schedule_app/features/auth/presentation/providers/auth_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final autoLoginProvider = AsyncNotifierProvider<AutoLoginProvider, bool>(
  AutoLoginProvider.new,
);

class AutoLoginProvider extends AsyncNotifier<bool> {
  @override
  FutureOr<bool> build() async {
    final repository = ref.read(authRepositoryProvider);

    return await repository.checkAuthLogin();
  }
}
