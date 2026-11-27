import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String name;
  final Color backgroundColor;
  final Color foregroundColor;
  final ImageProvider<Object>? backgroundImage;

  const ProfileAvatar({
    super.key,
    required this.name,
    required this.backgroundColor,
    required this.foregroundColor,
    this.backgroundImage,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: backgroundColor,
          backgroundImage: backgroundImage,
          child: backgroundImage == null ? Icon(Icons.person, size: 30) : null,
        ),
        const SizedBox(height: 10),
        Text(name, style: textTheme.bodySmall),
      ],
    );
  }
}
