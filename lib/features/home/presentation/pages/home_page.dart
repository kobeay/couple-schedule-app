import 'package:couple_schedule_app/app/widgets/couple_animation.dart';
import 'package:couple_schedule_app/app/theme/app_colors.dart';
import 'package:couple_schedule_app/features/home/presentation/widgets/schedule_group.dart';
import 'package:couple_schedule_app/features/home/presentation/widgets/schedule_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsetsGeometry.fromLTRB(20, 20, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  margin: EdgeInsets.zero,
                  color: theme.colorScheme.primaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(
                      color: AppColors.primaryContainerOutline,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsGeometry.all(24),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '우리 함께한 지',
                                style: textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Text(
                                    '❤️',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '365일',
                                    style: textTheme.displayLarge?.copyWith(
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '2025.09.05 ~ ',
                                style: textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        const SizedBox(
                          width: 90,
                          height: 104,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              width: 120,
                              height: 100,
                              child: CoupleAnimation(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '오늘의 일정',
                                style: textTheme.headlineSmall,
                              ),
                            ),
                            Text(
                              '9월 5일 토요일',
                              style: textTheme.bodySmall?.copyWith(
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ScheduleGroup(
                          name: '나',
                          color: AppColors.mySchedule,
                          children: [
                            ScheduleRow(time: '14:00 - 15:30', title: '수업'),
                            ScheduleRow(time: '19:00 - 21:00', title: '친구 약속'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ScheduleGroup(
                          name: '여자친구',
                          color: AppColors.partnerSchedule,
                          children: [
                            ScheduleRow(time: '13:00 - 18:00', title: '아르바이트'),
                            ScheduleRow(time: '18:00 - 19:00', title: '운동'),
                          ],
                        ),
                      ],
                    ),
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
