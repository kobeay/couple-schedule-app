class CoupleInvitationResponse {
  final int invitationId;
  final String senderNickname;
  final DateTime createdAt;

  const CoupleInvitationResponse({
    required this.invitationId,
    required this.senderNickname,
    required this.createdAt,
  });

  factory CoupleInvitationResponse.fromJson(Map<String, dynamic> json) {
    return CoupleInvitationResponse(
      invitationId: json['invitationId'] as int,
      senderNickname: json['senderNickname'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
