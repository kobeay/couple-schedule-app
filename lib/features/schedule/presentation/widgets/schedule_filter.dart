import 'package:couple_schedule_app/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ScheduleFilter extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool selected;

  const ScheduleFilter({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        backgroundColor: selected ? backgroundColor : AppColors.surfaceMuted,
        foregroundColor: selected ? foregroundColor : AppColors.textSecondary,
        textStyle: theme.textTheme.labelMedium,
      ),
      child: Text(label),
    );
  }
}
