import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    required this.hintText,
    required this.controller,
    this.validator,
    this.obscureText = false,
    this.maxLines,
    this.fixIcon,
    this.textDirection,
  });

  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final int? maxLines;
  final Widget? fixIcon;
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      maxLines: maxLines ?? 1,
      textDirection: textDirection,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: fixIcon,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
