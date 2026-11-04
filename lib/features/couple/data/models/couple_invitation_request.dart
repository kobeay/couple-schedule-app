class CoupleInvitationRequest {
  final String inviteCode;

  const CoupleInvitationRequest({required this.inviteCode});

  Map<String, dynamic> toJson() {
    return {'inviteCode': inviteCode};
  }
}
