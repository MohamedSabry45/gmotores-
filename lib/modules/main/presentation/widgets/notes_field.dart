import 'package:flutter/material.dart';

import 'package:reservation_workshop/config/style/app_colors.dart';

class NotesField extends StatelessWidget {
  const NotesField({
    super.key,
    required this.hintText,
    required this.controller,
  });

  final String hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return TextFormField(
      controller: controller,
      minLines: 3,
      maxLines: 5,
      style: textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.brandDark,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xFFE5E7EB),
        hintStyle: textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.grey7,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.brandOutline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.brandOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.brandPrimary, width: 1.2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}
