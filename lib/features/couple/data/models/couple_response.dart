class CoupleResponse {
  final bool connected;
  final String? partnerNickname;
  final DateTime? connectedAt;

  const CoupleResponse({
    required this.connected,
    required this.partnerNickname,
    required this.connectedAt,
  });

  factory CoupleResponse.fromJson(Map<String, dynamic> json) {
    return CoupleResponse(
      connected: json['connected'] as bool,
      partnerNickname: json['partnerNickname'] as String?,
      connectedAt: json['connectedAt'] == null
          ? null
          : DateTime.parse(json['connectedAt'] as String),
    );
  }
}
