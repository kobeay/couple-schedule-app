import 'package:couple_schedule_app/app/theme/app_colors.dart';
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

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsGeometry.fromLTRB(20, 20, 20, 32),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ProfileAvatar(
                              name: '민준',
                              backgroundColor: AppColors.myScheduleContainer,
                              foregroundColor: AppColors.onMySchedule,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 18),
                              child: Text('❤️', style: TextStyle(fontSize: 18)),
                            ),
                            ProfileAvatar(
                              name: '서연',
                              backgroundColor:
                                  AppColors.partnerScheduleContainer,
                              foregroundColor: AppColors.onPartnerSchedule,
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          '2025.09.05부터 함께',
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Card(
                  margin: EdgeInsets.zero,
                  child: Column(
                    children: [
                      SettingRow(title: '내 프로필', value: '민준'),
                      Divider(height: 1, thickness: 1),
                      SettingRow(title: '연결된 상대방', value: '서연'),
                      Divider(height: 1, thickness: 1),
                      SettingRow(title: '우리가 만난 날짜', value: '2025.09.05'),
                      Divider(height: 1, thickness: 1),
                      SettingRow(title: '커플 연결 관리'),
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
