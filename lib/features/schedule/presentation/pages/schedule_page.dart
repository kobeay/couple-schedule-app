import 'package:couple_schedule_app/app/theme/app_colors.dart';
import 'package:couple_schedule_app/features/schedule/presentation/pages/schedule_form_page.dart';
import 'package:couple_schedule_app/features/schedule/presentation/widgets/month_calendar.dart';
import 'package:couple_schedule_app/features/schedule/presentation/widgets/schedule_card.dart';
import 'package:couple_schedule_app/features/schedule/presentation/widgets/schedule_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SchedulePage extends ConsumerStatefulWidget {
  const SchedulePage({super.key});

  @override
  ConsumerState<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends ConsumerState<SchedulePage> {
  DateTime _focusedDay = DateTime(2026, 9, 1);
  DateTime _selectedDay = DateTime(2026, 9, 5);

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: '일정 추가',
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        shape: const CircleBorder(),
        onPressed: () => Navigator.of(context).push<void>(
          MaterialPageRoute(
            builder: (context) => ScheduleFormPage(initialDate: _selectedDay),
            fullscreenDialog: true,
          ),
        ),
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

                const Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ScheduleFilter(
                      label: '전체',
                      backgroundColor: AppColors.textPrimary,
                      foregroundColor: AppColors.surface,
                      selected: true,
                    ),
                    ScheduleFilter(
                      label: '나',
                      backgroundColor: AppColors.myScheduleContainer,
                      foregroundColor: AppColors.onMySchedule,
                    ),
                    ScheduleFilter(
                      label: '여자친구',
                      backgroundColor: AppColors.partnerScheduleContainer,
                      foregroundColor: AppColors.onPartnerSchedule,
                    ),
                    ScheduleFilter(
                      label: '우리',
                      backgroundColor: AppColors.sharedScheduleContainer,
                      foregroundColor: AppColors.onSharedSchedule,
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
                ),

                const SizedBox(height: 20),

                Text('9월 5일 토요일', style: theme.textTheme.titleLarge),
                const SizedBox(height: 12),
                ScheduleCard(
                  title: '아르바이트',
                  time: '13:00 ~ 18:00',
                  owner: ScheduleOwner.partner,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ScheduleFormPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                ScheduleCard(
                  title: '수업',
                  time: '14:00 ~ 15:30',
                  owner: ScheduleOwner.me,
                ),
                const SizedBox(height: 12),
                ScheduleCard(
                  title: '운동',
                  time: '18:00 ~ 19:00',
                  owner: ScheduleOwner.couple,
                ),
                const SizedBox(height: 12),
                ScheduleCard(
                  title: '친구 약속',
                  time: '19:00 ~ 21:00',
                  owner: ScheduleOwner.me,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
