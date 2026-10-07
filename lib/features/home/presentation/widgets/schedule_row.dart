import 'package:flutter/material.dart';
import 'package:couple_schedule_app/app/theme/app_colors.dart';

class ScheduleRow extends StatelessWidget {
  final String time;
  final String title;

  const ScheduleRow({super.key, required this.time, required this.title});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(
            time,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(width: 10),
          Text(title, style: textTheme.bodyMedium),
        ],
      ),
    );
  }
}
