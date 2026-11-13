import 'package:couple_schedule_app/features/schedule/presentation/widgets/schedule_card.dart';
import 'package:flutter/material.dart';

class ScheduleGroup extends StatelessWidget {
  final ScheduleOwner owner;
  final Color color;
  final List<Widget> children;
  final String partnerNickname;

  const ScheduleGroup({
    super.key,
    required this.owner,
    required this.color,
    required this.children,
    required this.partnerNickname,
  });

  @override
  Widget build(BuildContext context) {
    final name = switch (owner) {
      ScheduleOwner.me => '나',
      ScheduleOwner.partner => partnerNickname,
      ScheduleOwner.couple => '우리',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(
              name,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: color),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 14),
          child: Column(children: children),
        ),
      ],
    );
  }
}
