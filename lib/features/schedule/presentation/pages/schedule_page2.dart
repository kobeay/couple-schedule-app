import 'package:couple_schedule_app/app/theme/app_colors.dart';
import 'package:couple_schedule_app/app/widgets/app_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

/// 화면 확인용 고정 예시. 월 이동, 필터, 날짜 선택, 일정 추가는 추후 연결합니다.
class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 88),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    tooltip: '이전 달',
                    icon: const Icon(Icons.chevron_left_rounded),
                    color: AppColors.textIcon,
                  ),
                  const SizedBox(width: 16),
                  Text('2026년 9월', style: theme.textTheme.headlineMedium),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: () {},
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
                  _ScheduleFilter(label: '전체', selected: true),
                  _ScheduleFilter(label: '나'),
                  _ScheduleFilter(label: '여자친구'),
                  _ScheduleFilter(label: '우리'),
                ],
              ),
              const SizedBox(height: 16),
              const _MonthCalendar(),
              const SizedBox(height: 28),
              Text('9월 5일 토요일', style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              const _ScheduleCard(
                title: '아르바이트',
                time: '13:00 - 18:00',
                isMine: false,
              ),
              const SizedBox(height: 12),
              const _ScheduleCard(
                title: '수업',
                time: '14:00 - 15:30',
                isMine: true,
              ),
              const SizedBox(height: 12),
              const _ScheduleCard(
                title: '운동',
                time: '18:00 - 19:00',
                isMine: false,
              ),
              const SizedBox(height: 12),
              const _ScheduleCard(
                title: '친구 약속',
                time: '19:00 - 21:00',
                isMine: true,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: '일정 추가',
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        shape: const CircleBorder(),
        elevation: 4,
        child: const Icon(Icons.add_rounded, size: 30),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        selectedIndex: 1,
        onDestinationSelected: (index) {
          // TODO: 화면 이동 구현
        },
      ),
    );
  }
}

class _ScheduleFilter extends StatelessWidget {
  const _ScheduleFilter({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          backgroundColor: selected
              ? AppColors.textPrimary
              : AppColors.surfaceMuted,
          foregroundColor: selected
              ? AppColors.surface
              : AppColors.textSecondary,
          textStyle: Theme.of(context).textTheme.labelMedium,
          minimumSize: const Size(0, 38),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: const StadiumBorder(),
        ),
        child: Text(label),
      ),
    );
  }
}

class _MonthCalendar extends StatelessWidget {
  const _MonthCalendar();

  static const _weekdays = ['일', '월', '화', '수', '목', '금', '토'];

  // 시안의 날짜별 일정 표시용 색상입니다.
  static const _markers = <int, List<Color>>{
    5: [
      AppColors.mySchedule,
      AppColors.partnerSchedule,
      AppColors.sharedSchedule,
    ],
    8: [AppColors.sharedSchedule],
    12: [AppColors.partnerSchedule],
    15: [
      AppColors.mySchedule,
      AppColors.sharedSchedule,
      AppColors.partnerSchedule,
    ],
    20: [AppColors.sharedSchedule],
    25: [AppColors.mySchedule],
  };

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Row(
          children: [
            for (var column = 0; column < 7; column++)
              Expanded(
                child: Text(
                  _weekdays[column],
                  textAlign: TextAlign.center,
                  style: textTheme.bodySmall?.copyWith(
                    color: column == 0
                        ? AppColors.calendarSunday
                        : column == 6
                        ? AppColors.calendarSaturday
                        : AppColors.textTertiary,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        // 2026년 9월은 화요일부터 시작하는 30일짜리 달입니다.
        for (var week = 0; week < 5; week++)
          Row(
            children: [
              for (var column = 0; column < 7; column++)
                Expanded(
                  child: _CalendarDay(
                    day: week * 7 + column - 1,
                    column: column,
                    markers: _markers[week * 7 + column - 1] ?? const [],
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

class _CalendarDay extends StatelessWidget {
  const _CalendarDay({
    required this.day,
    required this.column,
    required this.markers,
  });

  final int day;
  final int column;
  final List<Color> markers;

  @override
  Widget build(BuildContext context) {
    if (day < 1 || day > 30) return const SizedBox(height: 44);

    final selected = day == 5;
    final theme = Theme.of(context);

    return Semantics(
      label: '9월 $day일',
      selected: selected,
      child: SizedBox(
        height: 44,
        child: Column(
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? theme.colorScheme.primary : null,
              ),
              child: Text(
                '$day',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: selected
                      ? theme.colorScheme.onPrimary
                      : column == 0
                      ? AppColors.calendarSunday
                      : column == 6
                      ? AppColors.calendarSaturday
                      : AppColors.textPrimary,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final color in markers)
                  Container(
                    width: 4,
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({
    required this.title,
    required this.time,
    required this.isMine,
  });

  final String title;
  final String time;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 6,
              height: 36,
              decoration: BoxDecoration(
                color: isMine
                    ? AppColors.mySchedule
                    : AppColors.partnerSchedule,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textTheme.titleSmall),
                  const SizedBox(height: 2),
                  Text(
                    time,
                    style: textTheme.bodySmall?.copyWith(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: isMine
                    ? AppColors.myScheduleContainer
                    : AppColors.partnerScheduleContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isMine ? '나' : '여자친구',
                style: textTheme.labelSmall?.copyWith(
                  color: isMine
                      ? AppColors.onMySchedule
                      : AppColors.onPartnerSchedule,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
