import 'package:couple_schedule_app/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MonthCalendar extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime selectedDay;
  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<DateTime> onPageChanged;

  const MonthCalendar({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
    required this.onPageChanged,
  });

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
    final theme = Theme.of(context);

    return TableCalendar(
      firstDay: DateTime(2020, 1, 1),
      lastDay: DateTime(2030, 12, 31),
      focusedDay: focusedDay,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      headerVisible: false,
      rowHeight: 55,
      daysOfWeekHeight: 55,
      selectedDayPredicate: (day) {
        return isSameDay(day, selectedDay);
      },
      onDaySelected: (selectedDay, focusedDay) {
        onDaySelected(selectedDay);
      },
      onPageChanged: onPageChanged,
      calendarStyle: const CalendarStyle(outsideDaysVisible: false),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: theme.textTheme.bodySmall!.copyWith(
          color: AppColors.textTertiary,
        ),
        weekendStyle: theme.textTheme.bodySmall!.copyWith(
          color: AppColors.textTertiary,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        dowBuilder: (context, day) {
          const weekdays = ['월', '화', '수', '목', '금', '토', '일'];

          final text = weekdays[day.weekday - 1];

          final color = day.weekday == DateTime.sunday
              ? AppColors.calendarSunday
              : day.weekday == DateTime.saturday
              ? AppColors.calendarSaturday
              : AppColors.textTertiary;

          return Center(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(color: color),
            ),
          );
        },
        defaultBuilder: (context, day, focusedDay) {
          return _buildDay(context, day, _markers[day.day] ?? const []);
        },
        selectedBuilder: (context, day, focusedDay) {
          return _buildDay(
            context,
            day,
            _markers[day.day] ?? const [],
            selected: true,
          );
        },
        todayBuilder: (context, day, focusedDay) {
          return _buildDay(context, day, _markers[day.day] ?? const []);
        },
      ),
    );
  }

  Widget _buildDay(
    BuildContext context,
    DateTime day,
    List<Color> markers, {
    bool selected = false,
  }) {
    final theme = Theme.of(context);

    final isSunday = day.weekday == DateTime.sunday;
    final isSaturday = day.weekday == DateTime.saturday;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
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
            '${day.day}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: selected
                  ? theme.colorScheme.onPrimary
                  : isSunday
                  ? AppColors.calendarSunday
                  : isSaturday
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
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
          ],
        ),
      ],
    );
  }
}
