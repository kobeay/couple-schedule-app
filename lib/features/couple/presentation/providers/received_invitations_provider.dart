import 'package:couple_schedule_app/features/couple/data/models/couple_invitation_response.dart';
import 'package:couple_schedule_app/features/couple/presentation/providers/couple_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final receivedInvitaionsProvider =
    FutureProvider<List<CoupleInvitationResponse>>((ref) {
      final repository = ref.read(coupleRepositoryProvider);

      return repository.getReceivedInvitations();
    });
