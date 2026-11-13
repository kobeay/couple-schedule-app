import 'package:couple_schedule_app/app/widgets/couple_animation.dart';
import 'package:couple_schedule_app/app/theme/app_colors.dart';
import 'package:couple_schedule_app/features/auth/presentation/providers/user_info_provider.dart';
import 'package:couple_schedule_app/features/couple/presentation/providers/couple_provider.dart';
import 'package:couple_schedule_app/features/home/presentation/widgets/schedule_group.dart';
import 'package:couple_schedule_app/features/home/presentation/widgets/schedule_row.dart';
import 'package:couple_schedule_app/features/schedule/data/models/schedule_list_response.dart';
import 'package:couple_schedule_app/features/schedule/data/models/schedule_type.dart';
import 'package:couple_schedule_app/features/schedule/presentation/providers/monthly_schedules_provider.dart';
import 'package:couple_schedule_app/features/schedule/presentation/widgets/schedule_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final DateTime _today = DateTime.now();

  String formatScheduleTime(ScheduleListResponse schedule) {
    final startTime = schedule.startTime;
    final endTime = schedule.endTime;

    if (startTime == null) {
      return '시간 미정';
    }

    if (endTime == null) {
      return startTime.substring(0, 5);
    }

    return '${startTime.substring(0, 5)} ~ ${endTime.substring(0, 5)}';
  }

  ScheduleOwner getScheduleOwner(
    ScheduleListResponse schedule,
    int? currentUserId,
  ) {
    if (schedule.type == ScheduleType.couple) {
      return ScheduleOwner.couple;
    }

    if (schedule.userId == currentUserId) {
      return ScheduleOwner.me;
    }

    return ScheduleOwner.partner;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final couple = ref.watch(coupleProvider);

    final isConnectedCouple = couple.value?.connected == true;

    final partnerNickname = couple.value?.partnerNickname ?? '상대방';

    final monthlySchedules = ref.watch(
      monthlySchedulesProvider((year: _today.year, month: _today.month)),
    );

    final currentUserId = ref.watch(userInfoProvider).value?.id;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsetsGeometry.fromLTRB(20, 20, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isConnectedCouple)
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
                              '${_today.month}월 ${_today.day}일 ${['월', '화', '수', '목', '금', '토', '일'][_today.weekday - 1]}요일',
                              style: textTheme.bodySmall?.copyWith(
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        monthlySchedules.when(
                          loading: () {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          error: (error, stackTrace) {
                            return const Center(
                              child: Text('오늘의 일정을 불러오지 못했어요'),
                            );
                          },
                          data: (schedules) {
                            final todaySchedules =
                                schedules
                                    .where(
                                      (schedule) => DateUtils.isSameDay(
                                        schedule.date,
                                        _today,
                                      ),
                                    )
                                    .toList()
                                  ..sort((a, b) {
                                    final aTime = a.startTime;
                                    final bTime = b.startTime;

                                    if (aTime == null && bTime == null) {
                                      return 0;
                                    }
                                    if (aTime == null) return 1;
                                    if (bTime == null) return -1;

                                    return aTime.compareTo(bTime);
                                  });

                            if (todaySchedules.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  top: 5,
                                  bottom: 10,
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 12),
                                    Text(
                                      '아직 등록된 일정이 없어요',
                                      style: textTheme.bodyMedium,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '새로운 일정을 추가해 볼까요? ✨',
                                      textAlign: TextAlign.center,
                                      style: textTheme.bodySmall?.copyWith(
                                        color: AppColors.textTertiary,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            final mySchedules = todaySchedules.where((
                              schedule,
                            ) {
                              return schedule.type == ScheduleType.personal &&
                                  schedule.userId == currentUserId;
                            }).toList();

                            final partnerSchedules = todaySchedules.where((
                              schedule,
                            ) {
                              return schedule.type == ScheduleType.personal &&
                                  schedule.userId != currentUserId;
                            }).toList();

                            final coupleSchedules = todaySchedules.where((
                              schedule,
                            ) {
                              return schedule.type == ScheduleType.couple;
                            }).toList();

                            return Column(
                              children: [
                                Column(
                                  children: [
                                    if (mySchedules.isNotEmpty)
                                      ScheduleGroup(
                                        owner: ScheduleOwner.me,
                                        color: AppColors.mySchedule,
                                        partnerNickname: partnerNickname,

                                        children: [
                                          ...mySchedules.map((schedule) {
                                            return ScheduleRow(
                                              time: formatScheduleTime(
                                                schedule,
                                              ),
                                              title: schedule.title,
                                            );
                                          }),
                                        ],
                                      ),
                                    if (mySchedules.isNotEmpty &&
                                        partnerSchedules.isNotEmpty)
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        child: Divider(
                                          height: 1,
                                          color: AppColors.outline,
                                        ),
                                      ),
                                    if (partnerSchedules.isNotEmpty)
                                      ScheduleGroup(
                                        owner: ScheduleOwner.partner,
                                        color: AppColors.partnerSchedule,
                                        partnerNickname: partnerNickname,
                                        children: [
                                          ...partnerSchedules.map((schedule) {
                                            return ScheduleRow(
                                              time: formatScheduleTime(
                                                schedule,
                                              ),
                                              title: schedule.title,
                                            );
                                          }),
                                        ],
                                      ),
                                    if (coupleSchedules.isNotEmpty &&
                                        (mySchedules.isNotEmpty ||
                                            partnerSchedules.isNotEmpty))
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        child: Divider(
                                          height: 1,
                                          color: AppColors.outline,
                                        ),
                                      ),
                                    if (coupleSchedules.isNotEmpty)
                                      ScheduleGroup(
                                        owner: ScheduleOwner.couple,
                                        color: AppColors.onSharedSchedule,
                                        partnerNickname: partnerNickname,

                                        children: [
                                          ...coupleSchedules.map((schedule) {
                                            return ScheduleRow(
                                              time: formatScheduleTime(
                                                schedule,
                                              ),
                                              title: schedule.title,
                                            );
                                          }),
                                        ],
                                      ),
                                  ],
                                ),
                              ],
                            );
                          },
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
