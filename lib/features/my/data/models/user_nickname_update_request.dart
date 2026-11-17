class UserNicknameUpdateRequest {
  final String nickname;

  const UserNicknameUpdateRequest({required this.nickname});

  Map<String, dynamic> toJson() {
    return {'nickname': nickname};
  }
}
