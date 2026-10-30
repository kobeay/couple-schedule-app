import 'package:couple_schedule_app/features/couple/data/repositories/couple_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final coupleRepositoryProvider = Provider<CoupleRepository>((ref) {
  return CoupleRepository();
});
