import 'package:couple_schedule_app/features/auth/data/repositories/auth_repository.dart';
import 'package:couple_schedule_app/features/auth/presentation/providers/token_storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final tokenStorage = ref.read(tokenStorageProvider);

  return AuthRepository(tokenStorage: tokenStorage);
});
