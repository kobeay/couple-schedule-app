import 'package:couple_schedule_app/app/theme/app_colors.dart';
import 'package:couple_schedule_app/features/auth/presentation/providers/user_info_provider.dart';
import 'package:couple_schedule_app/features/couple/presentation/providers/couple_provider.dart';
import 'package:couple_schedule_app/features/schedule/data/models/schedule_list_response.dart';
import 'package:couple_schedule_app/features/schedule/data/models/schedule_type.dart';
import 'package:couple_schedule_app/features/schedule/presentation/pages/schedule_form_page.dart';
import 'package:couple_schedule_app/features/schedule/presentation/providers/monthly_schedules_provider.dart';
import 'package:couple_schedule_app/features/schedule/presentation/widgets/month_calendar.dart';
import 'package:couple_schedule_app/features/schedule/presentation/widgets/schedule_card.dart';
import 'package:couple_schedule_app/features/schedule/presentation/widgets/schedule_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ScheduleFilterType { all, me, partner, couple }

class SchedulePage extends ConsumerStatefulWidget {
  const SchedulePage({super.key});

  @override
  ConsumerState<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends ConsumerState<SchedulePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  ScheduleFilterType _selectedFilter = ScheduleFilterType.all;

  void _previousMonth() {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
    });
  }

  ScheduleOwner getScheduleOwner(
    ScheduleListResponse schedule,
    int currentUserId,
  ) {
    if (schedule.type == ScheduleType.couple) {
      return ScheduleOwner.couple;
    }

    if (schedule.userId == currentUserId) {
      return ScheduleOwner.me;
    }

    return ScheduleOwner.partner;
  }

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

  bool matchesScheduleFilter(
    ScheduleListResponse schedule,
    int? currentUserId,
  ) {
    switch (_selectedFilter) {
      case ScheduleFilterType.all:
        return true;

      case ScheduleFilterType.me:
        return schedule.type == ScheduleType.personal &&
            schedule.userId == currentUserId;

      case ScheduleFilterType.partner:
        return schedule.type == ScheduleType.personal &&
            schedule.userId != currentUserId;

      case ScheduleFilterType.couple:
        return schedule.type == ScheduleType.couple;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final monthlySchedules = ref.watch(
      monthlySchedulesProvider((
        year: _focusedDay.year,
        month: _focusedDay.month,
      )),
    );

    final currentUserId = ref.watch(userInfoProvider).value?.id;

    final couple = ref.watch(coupleProvider);

    final isConnectedCouple = couple.value?.connected == true;

    final partnerNickname = couple.value?.partnerNickname ?? '상대방';

    final calendarSchedules = (monthlySchedules.value ?? [])
        .where((schedule) => matchesScheduleFilter(schedule, currentUserId))
        .toList();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: '일정 추가',
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        shape: const CircleBorder(),
        onPressed: () async {
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder: (context) => ScheduleFormPage(),
              fullscreenDialog: true,
            ),
          );

          if (!context.mounted) return;

          if (result == true) {
            ref.invalidate(monthlySchedulesProvider);
          }
        },
        child: const Icon(Icons.add_rounded, size: 30),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 88),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: _previousMonth,
                      tooltip: '이전 달',
                      icon: const Icon(Icons.chevron_left_rounded),
                      color: AppColors.textIcon,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '${_focusedDay.year}년 ${_focusedDay.month}월',
                      style: theme.textTheme.headlineMedium,
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: _nextMonth,
                      tooltip: '다음 달',
                      icon: const Icon(Icons.chevron_right_rounded),
                      color: AppColors.textIcon,
                    ),
                  ],
                ),

                const SizedBox(height: 2),

                if (isConnectedCouple)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ScheduleFilter(
                        label: '전체',
                        backgroundColor: AppColors.textPrimary,
                        foregroundColor: AppColors.surface,
                        selected: _selectedFilter == ScheduleFilterType.all,
                        onPressed: () {
                          setState(() {
                            _selectedFilter = ScheduleFilterType.all;
                          });
                        },
                      ),
                      ScheduleFilter(
                        label: '나',
                        backgroundColor: AppColors.myScheduleContainer,
                        foregroundColor: AppColors.onMySchedule,
                        selected: _selectedFilter == ScheduleFilterType.me,
                        onPressed: () {
                          setState(() {
                            _selectedFilter = ScheduleFilterType.me;
                          });
                        },
                      ),
                      ScheduleFilter(
                        label: partnerNickname,
                        backgroundColor: AppColors.partnerScheduleContainer,
                        foregroundColor: AppColors.onPartnerSchedule,
                        selected: _selectedFilter == ScheduleFilterType.partner,
                        onPressed: () {
                          setState(() {
                            _selectedFilter = ScheduleFilterType.partner;
                          });
                        },
                      ),
                      ScheduleFilter(
                        label: '우리',
                        backgroundColor: AppColors.sharedScheduleContainer,
                        foregroundColor: AppColors.onSharedSchedule,
                        selected: _selectedFilter == ScheduleFilterType.couple,
                        onPressed: () {
                          setState(() {
                            _selectedFilter = ScheduleFilterType.couple;
                          });
                        },
                      ),
                    ],
                  ),

                //const SizedBox(height: 16),
                MonthCalendar(
                  focusedDay: _focusedDay,
                  selectedDay: _selectedDay,
                  onDaySelected: (selectedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = selectedDay;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
                  schedules: calendarSchedules,
                  currentUserId: currentUserId,
                ),

                const SizedBox(height: 20),

                Text(
                  '${_selectedDay.month}월 ${_selectedDay.day}일 ${['월', '화', '수', '목', '금', '토', '일'][_selectedDay.weekday - 1]}요일',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 12),

                monthlySchedules.when(
                  loading: () {
                    return const Center(child: CircularProgressIndicator());
                  },
                  error: (error, stackTrace) {
                    return const Center(child: Text('일정을 불러오지 못했어요'));
                  },
                  data: (schedules) {
                    if (currentUserId == null) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final selectedSchedules =
                        schedules
                            .where(
                              (schedule) =>
                                  DateUtils.isSameDay(
                                    schedule.date,
                                    _selectedDay,
                                  ) &&
                                  matchesScheduleFilter(
                                    schedule,
                                    currentUserId,
                                  ),
                            )
                            .toList()
                          ..sort((a, b) {
                            final aTime = a.startTime;
                            final bTime = b.startTime;

                            if (aTime == null && bTime == null) return 0;
                            if (aTime == null) return 1;
                            if (bTime == null) return -1;

                            return aTime.compareTo(bTime);
                          });

                    if (selectedSchedules.isEmpty) {
                      return const Column(
                        children: [
                          SizedBox(height: 20),
                          Center(child: Text('등록된 일정이 없어요')),
                        ],
                      );
                    }

                    return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...selectedSchedules.map((schedule) {
                            final owner = getScheduleOwner(
                              schedule,
                              currentUserId,
                            );

                            return Column(
                              children: [
                                ScheduleCard(
                                  title: schedule.title,
                                  time: formatScheduleTime(schedule),
                                  owner: owner,
                                  partnerNickname: partnerNickname,
                                  isConnectedCouple: isConnectedCouple,
                                  onTap: owner == ScheduleOwner.partner
                                      ? null
                                      : () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ScheduleFormPage(
                                                    isEditing: true,
                                                  ),
                                            ),
                                          );
                                        },
                                ),
                                const Divider(
                                  height: 1,
                                  color: AppColors.outline,
                                  indent: 16,
                                  endIndent: 16,
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
