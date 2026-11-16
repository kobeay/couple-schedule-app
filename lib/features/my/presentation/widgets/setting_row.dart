import 'package:flutter/material.dart';
import 'package:couple_schedule_app/app/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';

class SettingRow extends StatelessWidget {
  final String title;
  final String? value;
  final VoidCallback? onTap;
  final bool? isConnectedCouple;

  const SettingRow({
    super.key,
    required this.title,
    this.value,
    this.onTap,
    this.isConnectedCouple,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: isConnectedCouple == false
                    ? textTheme.bodyLarge?.copyWith(
                        color: AppColors.textDisabled,
                      )
                    : textTheme.bodyLarge,
              ),
            ),
            if (value != null) ...[
              const SizedBox(width: 12),
              Text(
                value!,
                style: textTheme.bodySmall?.copyWith(
                  color: isConnectedCouple == false
                      ? AppColors.textDisabled
                      : AppColors.textTertiary,
                ),
              ),
            ],
            const SizedBox(width: 6),
            const Icon(
              CupertinoIcons.chevron_right,
              size: 16,
              color: AppColors.textDisabled,
            ),
          ],
        ),
      ),
    );
  }
}
