import 'package:couple_schedule_app/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AuthField extends StatefulWidget {
  final String? label;
  final String hintText;
  final IconData prefixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? errorText;

  const AuthField({
    super.key,
    this.label,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.errorText,
  });

  @override
  State<AuthField> createState() => SignUpFieldState();
}

class SignUpFieldState extends State<AuthField> {
  late bool _obscureText;

  String? _validationError;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final displayError = widget.errorText ?? _validationError;
    final hasError = displayError != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: textTheme.titleSmall?.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
        ],

        TextFormField(
          controller: widget.controller,
          validator: (value) {
            final error = widget.validator?.call(value);

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && _validationError != error) {
                setState(() {
                  _validationError = error;
                });
              }
            });

            return error;
          },
          keyboardType: widget.keyboardType,
          obscureText: _obscureText,
          decoration: InputDecoration(
            hintText: widget.hintText,

            errorStyle: const TextStyle(fontSize: 0, height: 0),

            errorMaxLines: 1,

            enabledBorder: hasError
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.destructive),
                  )
                : null,

            focusedBorder: hasError
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.destructive,
                      width: 2,
                    ),
                  )
                : null,

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.destructive),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.destructive,
                width: 2,
              ),
            ),

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

        if (displayError != null) ...[
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 16,
                color: AppColors.destructive,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  displayError,
                  style: const TextStyle(
                    color: AppColors.destructive,
                    fontSize: 12,
                    height: 1.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
