import 'package:couple_schedule_app/app/theme/app_colors.dart';
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

                _SignUpField(
                  label: '이메일',
                  hintText: '이메일을 입력해주세요.',
                  prefixIcon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 20),

                _SignUpField(
                  label: '비밀번호',
                  hintText: '비밀번호를 입력해주세요.',
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                ),

                const SizedBox(height: 20),

                _SignUpField(
                  label: '비밀번호 확인',
                  hintText: '비밀번호를 다시 입력해주세요.',
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                ),

                const SizedBox(height: 20),

                _SignUpField(
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

class _SignUpField extends StatefulWidget {
  const _SignUpField({
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType,
    this.obscureText = false,
  });

  final String label;
  final String hintText;
  final IconData prefixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;

  @override
  State<_SignUpField> createState() => _SignUpFieldState();
}

class _SignUpFieldState extends State<_SignUpField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: textTheme.titleSmall?.copyWith(color: AppColors.textPrimary),
        ),

        const SizedBox(height: 8),

        TextFormField(
          keyboardType: widget.keyboardType,
          obscureText: _obscureText,
          decoration: InputDecoration(
            hintText: widget.hintText,

            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                widget.prefixIcon,
                size: 18,
                color: AppColors.textTertiary,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 18,
              minHeight: 18,
            ),
            suffixIcon: widget.obscureText
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    color: AppColors.textTertiary,
                    iconSize: 20,
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
