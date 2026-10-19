class SignUpRequest {
  final String email;
  final String password;
  final String passwordConfirm;
  final String nickname;

  const SignUpRequest({
    required this.email,
    required this.password,
    required this.passwordConfirm,
    required this.nickname,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'passwordConfirm': passwordConfirm,
      'nickname': nickname,
    };
  }
}
