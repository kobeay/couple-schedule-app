import 'package:couple_schedule_app/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum ScheduleOwner { me, partner, couple }

class ScheduleCard extends StatelessWidget {
  final String title;
  final String time;
  final ScheduleOwner owner;

  const ScheduleCard({
    super.key,
    required this.title,
    required this.time,
    required this.owner,
  });

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
                color: switch (owner) {
                  ScheduleOwner.me => AppColors.mySchedule,
                  ScheduleOwner.partner => AppColors.partnerSchedule,
                  ScheduleOwner.couple => AppColors.sharedSchedule,
                },
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
                color: switch (owner) {
                  ScheduleOwner.me => AppColors.myScheduleContainer,
                  ScheduleOwner.partner => AppColors.partnerScheduleContainer,
                  ScheduleOwner.couple => AppColors.sharedScheduleContainer,
                },
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                switch (owner) {
                  ScheduleOwner.me => '나',
                  ScheduleOwner.partner => '여자친구',
                  ScheduleOwner.couple => '우리',
                },
                style: textTheme.labelSmall?.copyWith(
                  color: switch (owner) {
                    ScheduleOwner.me => AppColors.onMySchedule,
                    ScheduleOwner.partner => AppColors.onPartnerSchedule,
                    ScheduleOwner.couple => AppColors.onSharedSchedule,
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
