import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String name;
  final Color backgroundColor;
  final Color foregroundColor;

  const ProfileAvatar({
    super.key,
    required this.name,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: backgroundColor,
          child: Text(
            name,
            style: textTheme.headlineMedium?.copyWith(color: foregroundColor),
          ),
        ),
        const SizedBox(height: 8),
        Text(name, style: textTheme.bodySmall),
      ],
    );
  }
}
