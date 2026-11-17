import 'package:couple_schedule_app/app/theme/app_colors.dart';
import 'package:couple_schedule_app/features/auth/presentation/pages/login_page.dart';
import 'package:couple_schedule_app/features/auth/presentation/providers/logout_notifier.dart';
import 'package:couple_schedule_app/features/my/presentation/widgets/setting_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppSettingsPage extends ConsumerStatefulWidget {
  const AppSettingsPage({super.key});

  @override
  ConsumerState<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends ConsumerState<AppSettingsPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final logoutState = ref.watch(logoutNotifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('앱 설정'),
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(CupertinoIcons.chevron_left),
          color: AppColors.textIcon,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('계정', style: textTheme.bodyMedium),
                const SizedBox(height: 8),
                Card(
                  child: Column(
                    children: [
                      SettingRow(
                        title: '로그아웃',
                        onTap: logoutState.isLoading
                            ? null
                            : () async {
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (dialogContext) => AlertDialog(
                                    title: Text('로그아웃을 진행할까요?'),
                                    content: Text(
                                      '현재 계정에서 로그아웃하고\n로그인 화면으로 이동해요',
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: AppColors.textSecondary,
                                        height: 1.5,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(dialogContext, false),
                                        style: TextButton.styleFrom(
                                          foregroundColor:
                                              AppColors.textSecondary,
                                        ),
                                        child: const Text('취소'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(dialogContext, true),
                                        style: TextButton.styleFrom(
                                          foregroundColor:
                                              AppColors.destructive,
                                        ),
                                        child: const Text('로그아웃'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirmed != true || !mounted) return;

                                await ref
                                    .read(logoutNotifier.notifier)
                                    .logout();

                                final result = ref.read(logoutNotifier);

                                if (!context.mounted) return;

                                if (result.hasError) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('로그아웃에 실패했어요'),
                                    ),
                                  );

                                  return;
                                }

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                  (route) => false,
                                );
                              },
                      ),
                      Divider(height: 1, thickness: 1),
                      SettingRow(title: '회원탈퇴'),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                Text('앱 정보', style: textTheme.bodyMedium),
                const SizedBox(height: 8),
                Card(
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      SettingRow(title: '앱 버전'),
                      Divider(height: 1, thickness: 1),
                      SettingRow(title: '오픈소스 라이선스'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
