import 'package:couple_schedule_app/app/theme/app_colors.dart';
import 'package:couple_schedule_app/features/auth/presentation/providers/user_info_provider.dart';
import 'package:couple_schedule_app/features/couple/presentation/pages/couple_management_page.dart';
import 'package:couple_schedule_app/features/couple/presentation/providers/couple_provider.dart';
import 'package:couple_schedule_app/features/my/presentation/pages/met_date_page.dart';
import 'package:couple_schedule_app/features/my/presentation/pages/profile_edit_page.dart';
import 'package:couple_schedule_app/features/my/presentation/widgets/profile_avatar.dart';
import 'package:couple_schedule_app/features/my/presentation/widgets/setting_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyPage extends ConsumerStatefulWidget {
  const MyPage({super.key});

  @override
  ConsumerState<MyPage> createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final couple = ref.watch(coupleProvider);
    final isConnectedCouple = couple.value?.connected == true;

    final metDate = couple.value?.metDate;
    final metDateText = !isConnectedCouple || metDate == null
        ? '설정 안 됨'
        : '${metDate.year}-${metDate.month.toString().padLeft(2, '0')}-${metDate.day.toString().padLeft(2, '0')}';

    final partnerNickname = couple.value?.partnerNickname ?? '상대방';

    final user = ref.watch(userInfoProvider);
    final nickname = user.value?.nickname ?? '나';
    final email = user.value?.email ?? '';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsGeometry.fromLTRB(20, 20, 20, 32),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isConnectedCouple) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ProfileAvatar(
                                name: nickname,
                                backgroundColor: AppColors.myScheduleContainer,
                                foregroundColor: AppColors.onMySchedule,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 18),
                                child: Text(
                                  '❤️',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              ProfileAvatar(
                                name: partnerNickname,
                                backgroundColor:
                                    AppColors.partnerScheduleContainer,
                                foregroundColor: AppColors.onPartnerSchedule,
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Text(
                            metDate == null
                                ? '우리가 만난 날짜를 설정해 주세요'
                                : '$metDateText부터 함께',
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                Card(
                  margin: EdgeInsets.zero,
                  child: Column(
                    children: [
                      SettingRow(
                        title: '내 프로필',
                        value: nickname,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProfileEditPage(
                                nickname: nickname,
                                email: email,
                              ),
                            ),
                          );
                        },
                      ),
                      Divider(height: 1, thickness: 1),
                      SettingRow(
                        title: '우리가 만난 날짜',
                        value: metDateText,
                        isConnectedCouple: isConnectedCouple,
                        onTap: couple.isLoading
                            ? null
                            : isConnectedCouple
                            ? () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (context) => const MetDatePage(),
                                  ),
                                );
                              }
                            : () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('커플 연결 후 이용할 수 있어요'),
                                  ),
                                );
                              },
                      ),
                      Divider(height: 1, thickness: 1),
                      SettingRow(
                        title: '커플 연결 관리',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (context) =>
                                  const CoupleManagementPage(),
                            ),
                          );
                        },
                      ),
                      Divider(height: 1, thickness: 1),
                      SettingRow(title: '알림 설정', value: '켜짐'),
                      Divider(height: 1, thickness: 1),
                      SettingRow(title: '앱 설정'),
                      Divider(height: 1, thickness: 1),
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
