import 'package:couple_schedule_app/app/theme/app_colors.dart';
import 'package:couple_schedule_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
                ),

                const SizedBox(height: 20),

                AuthField(
                  label: '비밀번호',
                  hintText: '비밀번호를 입력해주세요.',
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                ),

                const SizedBox(height: 20),

                AuthField(
                  label: '비밀번호 확인',
                  hintText: '비밀번호를 다시 입력해주세요.',
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                ),

                const SizedBox(height: 20),

                AuthField(
                  label: '닉네임',
                  hintText: '닉네임 입력해주세요.',
                  prefixIcon: Icons.person_outline,
                ),

                const SizedBox(height: 32),

                FilledButton(onPressed: () {}, child: const Text('회원가입')),

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
    );
  }
}
