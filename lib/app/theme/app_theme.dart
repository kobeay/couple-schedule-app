import 'package:flutter/material.dart';

import 'app_color_scheme.dart';
import 'app_colors.dart';
import 'app_text_theme.dart';

/// 앱 전체에 적용되는 Material 3 공통 테마
abstract final class AppTheme {
  static final light = ThemeData(
    useMaterial3: true, // Material 3 사용
    // 공통 색상/텍스트 테마
    colorScheme: AppColorScheme.light,
    fontFamily: AppTextTheme.fontFamily,
    textTheme: AppTextTheme.light,

    // Scaffold 기본 화면 배경
    scaffoldBackgroundColor: AppColors.background,

    // AppBar 기본 스타일
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background, // AppBar 배경
      foregroundColor: AppColors.textPrimary, // 아이콘/텍스트 색상
      surfaceTintColor: Colors.transparent, // 스크롤 시 Material 색상 변화 제거
      elevation: 0, // 그림자 제거
      scrolledUnderElevation: 0, // 스크롤 시에도 그림자 제거
      titleTextStyle: AppTextTheme.light.headlineSmall, // AppBar 제목
    ),

    // Card 기본 스타일
    cardTheme: const CardThemeData(
      color: AppColors.surface, // 카드 배경
      surfaceTintColor: Colors.transparent,
      elevation: 0, // 그림자 제거
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)), // 카드 모서리
        side: BorderSide(color: AppColors.outline), // 카드 테두리
      ),
    ),

    // TextField / TextFormField 기본 스타일
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface, // 입력창 배경
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: TextStyle(
        color: AppColors.textTertiary, // Hint 텍스트
        fontSize: 14,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: AppColors.outline), // 평상시 테두리
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: AppColors.primary), // 입력 중 테두리
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: AppColors.destructive), // 오류 테두리
      ),
    ),

    // 주요 버튼 기본 스타일
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary, // 버튼 배경
        foregroundColor: AppColors.surface, // 버튼 텍스트/아이콘
        textStyle: AppTextTheme.light.titleLarge,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),

    // 보조 버튼 기본 스타일
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.surface, // 버튼 배경
        foregroundColor: AppColors.textPrimary, // 버튼 텍스트/아이콘
        textStyle: AppTextTheme.light.labelLarge,
        padding: const EdgeInsets.symmetric(vertical: 13),
        side: const BorderSide(color: AppColors.outline), // 버튼 테두리
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),

    // Divider 기본 스타일
    dividerTheme: const DividerThemeData(
      color: AppColors.outlineSubtle, // 영역 구분선
    ),
  );
}
