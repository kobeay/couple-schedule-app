import 'package:couple_schedule_app/features/couple/data/datasources/couple_api.dart';
import 'package:couple_schedule_app/features/couple/data/models/couple_invitation_request.dart';
import 'package:couple_schedule_app/features/couple/data/models/couple_invitation_response.dart';
import 'package:couple_schedule_app/features/couple/data/models/couple_response.dart';

class CoupleRepository {
  final CoupleApi _coupleApi;

  CoupleRepository({CoupleApi? coupleApi})
    : _coupleApi = coupleApi ?? CoupleApi();

  Future<CoupleResponse> getMyCouple() {
    return _coupleApi.getMyCouple();
  }

  Future<void> sendInvitation(CoupleInvitationRequest request) {
    return _coupleApi.sendInvitation(request);
  }

  Future<List<CoupleInvitationResponse>> getReceivedInvitations() {
    return _coupleApi.getReceivedInvitations();
  }

  Future<void> acceptInvitation(int invitationId) {
    return _coupleApi.acceptInvitation(invitationId);
  }

  Future<void> rejectInvitation(int invitationId) {
    return _coupleApi.rejectInvitation(invitationId);
  }

  Future<void> disconnectCouple() {
    return _coupleApi.disconnectCouple();
  }
}
