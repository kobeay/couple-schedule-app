import 'dart:convert';

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

    if (password.length < 8 || password.length > 64) {
      return '비밀번호는 8자 이상 64자 이하로 입력해 주세요.';
    }

    if (utf8.encode(password).length > 72) {
      return '비밀번호는 72바이트를 초과할 수 없습니다.';
    }

    return null;
  }

  static String? validatePasswordConfirm(
    String? passwordConfirm,
    String password,
  ) {
    if (passwordConfirm == null || passwordConfirm.trim().isEmpty) {
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
