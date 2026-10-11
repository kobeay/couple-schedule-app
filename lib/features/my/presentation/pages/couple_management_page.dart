import 'package:couple_schedule_app/app/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.partnerScheduleContainer,
                          child: Text(
                            '서연',
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
                              Text('서연님과 연결됨', style: textTheme.titleMedium),
                              const SizedBox(height: 2),

                              Text(
                                '2025.09.05',
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
                        Text(
                          '7QK92X',
                          textAlign: TextAlign.center,
                          style: textTheme.displayMedium?.copyWith(
                            letterSpacing: 4,
                          ),
                        ),
                        const SizedBox(height: 14),
                        FilledButton(
                          onPressed: () {},
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.surfaceMuted,
                            foregroundColor: AppColors.textSecondary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            textStyle: textTheme.labelLarge,
                          ),
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
