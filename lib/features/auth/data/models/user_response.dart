class UserResponse {
  final int id;
  final String email;
  final String nickname;
  final String inviteCode;

  const UserResponse({
    required this.id,
    required this.email,
    required this.nickname,
    required this.inviteCode,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'] as int,
      email: json['email'] as String,
      nickname: json['nickname'] as String,
      inviteCode: json['inviteCode'] as String,
    );
  }
}
