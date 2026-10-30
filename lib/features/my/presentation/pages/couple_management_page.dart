import 'package:couple_schedule_app/app/theme/app_colors.dart';
import 'package:couple_schedule_app/features/auth/presentation/providers/user_info_provider.dart';
import 'package:couple_schedule_app/features/couple/presentation/providers/couple_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CoupleManagementPage extends ConsumerStatefulWidget {
  const CoupleManagementPage({super.key});

  @override
  ConsumerState<CoupleManagementPage> createState() =>
      _CoupleManagementPageState();
}

class _CoupleManagementPageState extends ConsumerState<CoupleManagementPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final userInfo = ref.watch(userInfoProvider);
    final coupleInfo = ref.watch(coupleProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('커플 연결 관리'),
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
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                coupleInfo.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) =>
                      const Text('커플 정보를 불러오지 못했습니다.'),
                  data: (couple) {
                    if (!couple.connected) {
                      return Card(
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Text(
                            '아직 연결된 상대방이 없어요.',
                            style: textTheme.titleMedium,
                          ),
                        ),
                      );
                    }

                    final nickname = couple.partnerNickname ?? '상대방';

                    return Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor:
                                  AppColors.partnerScheduleContainer,
                              child: Text(
                                nickname.characters.first,
                                style: textTheme.labelLarge?.copyWith(
                                  color: AppColors.onPartnerSchedule,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$nickname님과 연결됨',
                                    style: textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 2),

                                  Text(
                                    couple.connectedAt == null
                                        ? '연결 날짜 정보 없음'
                                        : '${couple.connectedAt!.year}.${couple.connectedAt!.month.toString().padLeft(2, '0')}.${couple.connectedAt!.day.toString().padLeft(2, '0')}',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: AppColors.textTertiary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            const SizedBox(
                              width: 8,
                              height: 8,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: AppColors.sharedSchedule,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),
                Text(
                  '내 초대 코드',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        userInfo.when(
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          data: (user) => Text(
                            user.inviteCode,
                            textAlign: TextAlign.center,
                            style: textTheme.displayMedium?.copyWith(
                              letterSpacing: 4,
                            ),
                          ),
                          error: (error, stackTrace) => Text(
                            '초대 코드를 불러오지 못했습니다.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 14),
                        FilledButton(
                          onPressed: userInfo.asData == null
                              ? null
                              : () async {
                                  await Clipboard.setData(
                                    ClipboardData(
                                      text: userInfo.asData!.value.inviteCode,
                                    ),
                                  );

                                  if (!context.mounted) return;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('초대 코드가 복사되었습니다.'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                          child: const Text('코드 복사'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '코드를 상대방에게 공유하면 커플로 연결할 수 있어요. 연결을 해제하면 서로의 일정이 더 이상 공유되지 않아요.',
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textTertiary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.background,
                    foregroundColor: AppColors.destructive,
                    side: const BorderSide(color: AppColors.destructiveOutline),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text('커플 연결 해제'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
