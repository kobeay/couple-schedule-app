import 'package:couple_schedule_app/app/theme/app_colors.dart';
import 'package:couple_schedule_app/features/auth/data/models/login_request.dart';
import 'package:couple_schedule_app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:couple_schedule_app/features/auth/presentation/pages/token_test_page.dart';
import 'package:couple_schedule_app/features/auth/presentation/providers/login_provider.dart';
import 'package:couple_schedule_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:couple_schedule_app/app/widgets/couple_animation.dart';
import 'package:couple_schedule_app/features/main/presentation/pages/main_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

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

    final loginState = ref.watch(loginProvider);

    ref.listen(loginProvider, (previous, next) {
      if (previous?.isLoading == true &&
          next is AsyncData &&
          next.value != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      }

      if (next is AsyncError) {
        final error = next.error;

        if (error is DioException) {
          debugPrint('Dio 오류 유형: ${error.type}');
          debugPrint('Dio 오류 메시지: ${error.message}');
          debugPrint('상태 코드: ${error.response?.statusCode}');
          debugPrint('서버 응답: ${error.response?.data}');
        }

        String message = '로그인 중 오류가 발생했습니다.';

        if (error is DioException) {
          if (error.response?.statusCode == 400) {
            message = '이메일 또는 비밀번호가 올바르지 않습니다.';
          } else if (error.type == DioExceptionType.connectionTimeout) {
            message = '서버 연결 시간이 초과되었습니다.';
          }
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsetsGeometry.fromLTRB(24, 20, 24, 40),
            child: Form(
              key: _formKey,
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
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                      ),

                      const SizedBox(height: 12),

                      AuthField(
                        hintText: '비밀번호를 입력해주세요.',
                        prefixIcon: Icons.lock_outline,
                        obscureText: true,
                        controller: _passwordController,
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
                    onPressed: loginState.isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              final request = LoginRequest(
                                email: _emailController.text.trim(),
                                password: _passwordController.text,
                              );

                              ref.read(loginProvider.notifier).login(request);
                            }
                          },
                    child: loginState.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('로그인'),
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
                        onPressed: () async {
                          final result = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpPage(),
                            ),
                          );

                          if (!context.mounted) return;

                          if (result == true) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('회원가입이 완료되었습니다. 로그인해 주세요.'),
                              ),
                            );
                          }
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
      ),
    );
  }
}
