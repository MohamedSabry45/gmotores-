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
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: fixIcon == null
            ? null
            : IconTheme(
                data: const IconThemeData(color: Colors.white70),
                child: fixIcon!,
              ),
        filled: true,
        fillColor: const Color(0xFF0F172A),
        hintStyle: const TextStyle(color: Colors.white54, fontWeight: FontWeight.w600),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
