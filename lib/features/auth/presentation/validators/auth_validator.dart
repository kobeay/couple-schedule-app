import 'package:email_validator/email_validator.dart';

class AuthValidator {
  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return '이메일을 입력해주세요.';
    }

    if (!EmailValidator.validate(email.trim())) {
      return '올바른 이메일 형식을 입력해주세요.';
    }

    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.trim().isEmpty) {
      return '비밀번호를 입력해주세요.';
    }

    return null;
  }

  static String? validatePasswordConfirm(
    String? passwordConfirm,
    String password,
  ) {
    if (passwordConfirm == null || password.trim().isEmpty) {
      return '비밀번호 확인을 입력해주세요.';
    }

    if (passwordConfirm != password) {
      return '비밀번호가 일치하지 않습니다.';
    }

    return null;
  }

  static String? validateNickname(String? nickname) {
    if (nickname == null || nickname.trim().isEmpty) {
      return '닉네임을 입력해주세요.';
    }

    return null;
  }
}
