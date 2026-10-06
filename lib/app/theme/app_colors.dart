import 'package:flutter/material.dart';

/// Couple Schedule 앱에서 사용하는 공통 색상
abstract final class AppColors {
  // 기본 배경/표면
  static const background = Color(0xFFFAF9F6); // 화면 전체 배경
  static const surface = Color(0xFFFFFFFF); // 카드, 입력창 등 흰색 표면
  static const surfaceMuted = Color(0xFFF5F3EE); // 구분이 필요한 연한 배경

  // Primary
  static const primary = Color(0xFFD2703D); // 주요 버튼, 강조 요소
  static const primaryContainer = Color(0xFFFFF6EE); // Primary 계열의 연한 배경
  static const onPrimaryContainer = Color(0xFF8A6650); // Primary 연한 배경 위 텍스트
  static const primaryContainerOutline = Color(0xFFF3E2D2); // Primary 계열 영역 테두리

  // Text
  static const textPrimary = Color(0xFF2B2A28); // 제목, 본문 등 기본 텍스트
  static const textSecondary = Color(0xFF6B6860); // 설명 등 보조 텍스트
  static const textIcon = Color(0xFF8A8778); // 뒤로가기 등 보조 아이콘
  static const textTertiary = Color(0xFFA8A399); // Hint 등 약한 텍스트
  static const textDisabled = Color(0xFFC7C2B6); // 비활성화 텍스트

  // Border
  static const outline = Color(0xFFECE8E0); // 입력창, 카드 등 기본 테두리
  static const outlineSubtle = Color(0xFFF2EFE9); // Divider 등 약한 구분선
  static const destructiveOutline = Color(0xFFECE0D8); // 삭제/위험 요소 테두리

  // 상태/기타
  static const destructive = Color(0xFFC97B6B); // 삭제, 오류 등 위험 요소
  static const navigationInactive = Color(0xFFB4AFA3); // 선택되지 않은 네비게이션 아이콘
  static const switchInactive = Color(0xFFE4E1D8); // 꺼진 Switch
  static const calendarSaturday = Color(0xFF7C93C9); // 달력 토요일
  static const calendarSunday = destructive; // 달력 일요일

  // 내 일정
  static const mySchedule = Color(0xFF6F83E6); // 내 일정 대표색
  static const onMySchedule = Color(0xFF4A5DC9); // 내 일정 연한 배경 위 텍스트
  static const myScheduleContainer = Color(0xFFE9ECFC); // 내 일정 연한 배경

  // 상대방 일정
  static const partnerSchedule = Color(0xFFE887A8); // 상대방 일정 대표색
  static const onPartnerSchedule = Color(0xFFB23D68); // 상대방 일정 연한 배경 위 텍스트
  static const partnerScheduleContainer = Color(0xFFFBEAF0); // 상대방 일정 연한 배경

  // 우리 일정
  static const sharedSchedule = Color(0xFFA987D4); // 우리 일정 대표색
  static const onSharedSchedule = Color(0xFF7A56B0); // 우리 일정 연한 배경 위 텍스트
  static const sharedScheduleContainer = Color(0xFFF1E9F8); // 우리 일정 연한 배경

  // 소셜 로그인
  static const kakao = Color(0xFFFEE500); // 카카오 로그인 버튼
}
