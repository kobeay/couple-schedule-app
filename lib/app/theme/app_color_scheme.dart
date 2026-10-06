import 'package:flutter/material.dart';

import 'app_colors.dart';

/// 앱 색상을 Material 3의 의미별 색상 역할에 연결
abstract final class AppColorScheme {
  static const light = ColorScheme(
    brightness: Brightness.light, // 라이트 테마
    // 앱의 주요 강조 색상
    primary: AppColors.primary,
    onPrimary: AppColors.surface, // Primary 위의 텍스트/아이콘
    primaryContainer: AppColors.primaryContainer, // Primary 계열의 연한 영역
    onPrimaryContainer: AppColors.onPrimaryContainer, // 해당 영역 위 텍스트
    // Secondary - 내 일정
    secondary: AppColors.mySchedule,
    onSecondary: AppColors.surface,
    secondaryContainer: AppColors.myScheduleContainer,
    onSecondaryContainer: AppColors.onMySchedule,

    // Tertiary - 우리 일정
    tertiary: AppColors.sharedSchedule,
    onTertiary: AppColors.surface,
    tertiaryContainer: AppColors.sharedScheduleContainer,
    onTertiaryContainer: AppColors.onSharedSchedule,

    // 오류/삭제
    error: AppColors.destructive,
    onError: AppColors.surface, // 오류 색상 위의 텍스트/아이콘
    // 카드, 입력창 등의 표면
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary, // Surface 위 기본 텍스트
    surfaceContainerHighest: AppColors.surfaceMuted, // 구분용 연한 표면
    onSurfaceVariant: AppColors.textSecondary, // 보조 텍스트
    // 테두리/구분선
    outline: AppColors.outline,
    outlineVariant: AppColors.outlineSubtle,
  );
}
