class CoupleMetDateUpdateRequest {
  final DateTime metDate;

  const CoupleMetDateUpdateRequest({required this.metDate});

  Map<String, dynamic> toJson() {
    return {'metDate': metDate.toIso8601String().split('T')[0]};
  }
}
