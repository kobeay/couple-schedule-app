import 'package:couple_schedule_app/features/auth/data/models/user_response.dart';
import 'package:couple_schedule_app/features/auth/presentation/providers/auth_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userInfoProvider = FutureProvider<UserResponse>((ref) async {
  final repository = ref.read(authRepositoryProvider);

  return repository.getMyInfo();
});
