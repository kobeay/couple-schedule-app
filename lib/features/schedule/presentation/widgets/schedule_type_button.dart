import 'package:flutter/material.dart';
import 'package:couple_schedule_app/app/theme/app_colors.dart';

class ScheduleTypeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isShared;
  final VoidCallback onPressed;

  const ScheduleTypeButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.isShared,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        style: TextButton.styleFrom(
          minimumSize: const Size(0, 48),
          foregroundColor: !isSelected
              ? AppColors.textSecondary
              : isShared
              ? AppColors.onSharedSchedule
              : AppColors.onMySchedule,

          backgroundColor: !isSelected
              ? AppColors.surfaceMuted
              : isShared
              ? AppColors.sharedScheduleContainer
              : AppColors.myScheduleContainer,
          textStyle: Theme.of(context).textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: !isSelected
                  ? Colors.transparent
                  : isShared
                  ? AppColors.onSharedSchedule
                  : AppColors.onMySchedule,
            ),
          ),
        ),
        onPressed: () {},
        child: Text(label),
      ),
    );
  }
}
