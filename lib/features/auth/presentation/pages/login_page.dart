import 'package:couple_schedule_app/app/theme/app_colors.dart';
import 'package:couple_schedule_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:couple_schedule_app/features/auth/presentation/widgets/login_couple_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final linkStyle = TextButton.styleFrom(
      minimumSize: Size.zero,
      padding: EdgeInsets.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      textStyle: textTheme.bodySmall,
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsetsGeometry.fromLTRB(24, 20, 24, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    const LoginCoupleAnimation(),

                    const SizedBox(height: 10),

                    Text('함께하는', style: textTheme.headlineLarge),

                    const SizedBox(height: 10),

                    Text('소중한 하루', style: textTheme.headlineLarge),

                    const SizedBox(height: 10),

                    Text(
                      '우리의 일상을 더 특별하게',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Column(
                  children: [
                    AuthField(
                      hintText: '이메일을 입력해주세요.',
                      prefixIcon: Icons.mail_outline,
                    ),

                    const SizedBox(height: 12),

                    AuthField(
                      hintText: '비밀번호를 입력해주세요.',
                      prefixIcon: Icons.lock_outline,
                      obscureText: true,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    style: linkStyle.copyWith(
                      foregroundColor: const WidgetStatePropertyAll(
                        AppColors.textTertiary,
                      ),
                    ),
                    child: const Text('비밀번호 찾기'),
                  ),
                ),

                const SizedBox(height: 24),

                FilledButton(onPressed: () {}, child: const Text('로그인')),

                const SizedBox(height: 24),

                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.outline)),
                    Padding(
                      padding: const EdgeInsetsGeometry.symmetric(
                        horizontal: 10,
                      ),
                      child: Text(
                        '또는',
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textDisabled,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: AppColors.outline)),
                  ],
                ),

                const SizedBox(height: 24),

                Column(
                  children: [
                    // TODO: 소셜 로그인 버튼 크기 및 스타일 최종 조정
                    GestureDetector(
                      onTap: () {
                        // TODO: Google 로그인
                      },
                      child: Image.asset(
                        'assets/images/google_sign_in.png',
                        height: 48,
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 10),

                    GestureDetector(
                      onTap: () {
                        // TODO: Google 로그인
                      },
                      child: Image.asset(
                        'assets/images/kakao_login_en_medium.png',
                        height: 48,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '계정이 없으신가요?',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(width: 5),
                    TextButton(
                      onPressed: () {},
                      style: linkStyle.copyWith(
                        textStyle: WidgetStatePropertyAll(
                          textTheme.labelMedium,
                        ),
                        foregroundColor: WidgetStatePropertyAll(
                          theme.colorScheme.primary,
                        ),
                      ),
                      child: const Text('회원가입'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
