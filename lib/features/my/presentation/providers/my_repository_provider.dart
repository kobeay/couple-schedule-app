import 'package:couple_schedule_app/features/my/data/repositories/my_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final myRepositoryProvider = Provider<MyRepository>((ref) {
  return MyRepository();
});
