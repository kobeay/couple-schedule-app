import 'package:flutter/material.dart';

import 'app_colors.dart';

/// 앱에서 사용하는 공통 텍스트 스타일
abstract final class AppTextTheme {
  static const fontFamily = 'Pretendard';

  static const light = TextTheme(
    // 매우 큰 강조 텍스트
    displayLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 38,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
    ),
    displayMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
    ),
    displaySmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 26,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
    ),

    // 화면/섹션 제목
    headlineLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
    ),
    headlineMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
    ),
    headlineSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
    ),

    // 작은 제목, 강조 텍스트
    titleLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 15,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
    ),
    titleMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    titleSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),

    // 일반 본문/설명
    bodyLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
    ),
    bodyMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
    ),
    bodySmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary,
    ),

    // 버튼, 라벨 등 짧은 텍스트
    labelLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    labelMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: AppColors.textSecondary,
    ),
    labelSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 11,
      fontWeight: FontWeight.w600,
      color: AppColors.textSecondary,
    ),
  );
}
