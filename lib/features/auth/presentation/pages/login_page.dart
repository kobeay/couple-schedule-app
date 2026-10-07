import 'package:couple_schedule_app/app/theme/app_colors.dart';
import 'package:couple_schedule_app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:couple_schedule_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:couple_schedule_app/app/widgets/couple_animation.dart';
import 'package:couple_schedule_app/features/home/presentation/pages/home_page.dart';
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
                    const CoupleAnimation(),

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

                FilledButton(
                  // 인증 연동 전 홈 화면 확인용 이동입니다.
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  ),
                  child: const Text('로그인'),
                ),

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
                    OutlinedButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/google_logo.png',
                            width: 25,
                            height: 25,
                          ),
                          const SizedBox(width: 5),
                          const Text('Google로 계속하기'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    FilledButton(
                      onPressed: () {},
                      style: theme.outlinedButtonTheme.style?.copyWith(
                        backgroundColor: const WidgetStatePropertyAll(
                          AppColors.kakao,
                        ),
                        side: const WidgetStatePropertyAll(BorderSide.none),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/kakao_logo.png',
                            width: 25,
                            height: 25,
                          ),
                          const SizedBox(width: 5),
                          const Text('카카오로 계속하기'),
                        ],
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpPage(),
                          ),
                        );
                      },
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
