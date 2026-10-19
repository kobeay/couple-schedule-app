import 'package:couple_schedule_app/app/theme/app_colors.dart';
import 'package:couple_schedule_app/features/auth/data/models/sign_up_request.dart';
import 'package:couple_schedule_app/features/auth/presentation/providers/sign_up_provider.dart';
import 'package:couple_schedule_app/features/auth/presentation/validators/auth_validator.dart';
import 'package:couple_schedule_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _nicknameController = TextEditingController();

  @override
  void dispose() {
    _emailController.removeListener(_clearEmailServerError);

    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_clearEmailServerError);
  }

  void _clearEmailServerError() {
    if (_emailServerError != null) {
      setState(() {
        _emailServerError = null;
      });
    }
  }

  final _formKey = GlobalKey<FormState>();

  String? _emailServerError;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final signUpState = ref.watch(signUpProvider);

    ref.listen(signUpProvider, (previous, next) {
      if (previous?.isLoading == true && next is AsyncData) {
        Navigator.pop(context, true);
        return;
      }

      if (next is AsyncError) {
        final error = next.error;

        if (error is DioException) {
          debugPrint('Dio 오류 유형: ${error.type}');
          debugPrint('Dio 오류 메시지: ${error.message}');
          debugPrint('상태 코드: ${error.response?.statusCode}');
          debugPrint('서버 응답: ${error.response?.data}');
        }

        // 이메일 중복 오류
        if (error is DioException &&
            error.response?.statusCode == 400 &&
            error.response?.data == '이미 사용 중인 이메일입니다.') {
          setState(() {
            _emailServerError = '이미 사용 중인 이메일입니다.';
          });
          return;
        }

        String errorMessage = '회원가입 중 오류가 발생했습니다.';

        if (error is DioException) {
          switch (error.type) {
            case DioExceptionType.connectionTimeout:
            case DioExceptionType.sendTimeout:
            case DioExceptionType.receiveTimeout:
              errorMessage = '요청 시간이 초과되었습니다. 다시 시도해 주세요.';
              break;

            case DioExceptionType.connectionError:
              errorMessage = '서버에 연결할 수 없습니다. 인터넷 연결과 서버 상태를 확인해 주세요.';
              break;

            case DioExceptionType.badResponse:
              final statusCode = error.response?.statusCode;

              if (statusCode != null && statusCode >= 500) {
                errorMessage = '서버에 문제가 발생했습니다. 잠시 후 다시 시도해 주세요.';
              } else if (statusCode == 400) {
                errorMessage = '입력한 정보를 확인해 주세요.';
              }
              break;

            default:
              break;
          }
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          iconSize: 20,
          color: AppColors.textIcon,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsetsGeometry.fromLTRB(30, 10, 30, 40),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: [
                      Text('회원가입', style: textTheme.headlineLarge),
                      const SizedBox(height: 8),
                      Text(
                        '우리의 특별한 하루를 시작해요',
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  AuthField(
                    label: '이메일',
                    hintText: '이메일을 입력해주세요.',
                    prefixIcon: Icons.mail_outline,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    validator: AuthValidator.validateEmail,
                    errorText: _emailServerError,
                  ),

                  const SizedBox(height: 20),

                  AuthField(
                    label: '비밀번호',
                    hintText: '비밀번호를 입력해주세요.',
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                    controller: _passwordController,
                    validator: AuthValidator.validatePassword,
                  ),

                  const SizedBox(height: 20),

                  AuthField(
                    label: '비밀번호 확인',
                    hintText: '비밀번호를 다시 입력해주세요.',
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                    controller: _passwordConfirmController,
                    validator: (value) => AuthValidator.validatePasswordConfirm(
                      value,
                      _passwordController.text,
                    ),
                  ),

                  const SizedBox(height: 20),

                  AuthField(
                    label: '닉네임',
                    hintText: '닉네임 입력해주세요.',
                    prefixIcon: Icons.person_outline,
                    controller: _nicknameController,
                    validator: AuthValidator.validateNickname,
                  ),

                  const SizedBox(height: 32),

                  FilledButton(
                    onPressed: signUpState.isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              final request = SignUpRequest(
                                email: _emailController.text.trim(),
                                password: _passwordController.text,
                                passwordConfirm:
                                    _passwordConfirmController.text,
                                nickname: _nicknameController.text.trim(),
                              );

                              ref.read(signUpProvider.notifier).signUp(request);
                            }
                          },
                    child: signUpState.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('회원가입'),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '이미 계정이 있으신가요?',
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.maybePop(context),
                        child: const Text('로그인'),
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
