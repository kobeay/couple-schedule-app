import 'package:couple_schedule_app/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SignUpField extends StatefulWidget {
  const SignUpField({
    super.key,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType,
    this.obscureText = false,
  });

  final String label;
  final String hintText;
  final IconData prefixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;

  @override
  State<SignUpField> createState() => SignUpFieldState();
}

class SignUpFieldState extends State<SignUpField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: textTheme.titleSmall?.copyWith(color: AppColors.textPrimary),
        ),

        const SizedBox(height: 8),

        TextFormField(
          keyboardType: widget.keyboardType,
          obscureText: _obscureText,
          decoration: InputDecoration(
            hintText: widget.hintText,

            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                widget.prefixIcon,
                size: 18,
                color: AppColors.textTertiary,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 18,
              minHeight: 18,
            ),
            suffixIcon: widget.obscureText
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    color: AppColors.textTertiary,
                    iconSize: 20,
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
