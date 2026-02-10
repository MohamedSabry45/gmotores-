import 'package:flutter/material.dart';

import 'package:reservation_workshop/config/style/app_colors.dart';

class BookingDropdownField<T> extends StatelessWidget {
  const BookingDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.isRequired = false,
    this.labelColor,
    this.textColor,
    this.fillColor,
    this.dropdownColor,
    this.iconColor,
  });

  final String label;
  final bool isRequired;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final Color? labelColor;
  final Color? textColor;
  final Color? fillColor;
  final Color? dropdownColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final effectiveFill = fillColor ?? const Color(0xFFE5E7EB);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: labelColor ?? AppColors.brandDark,
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              const Text(
                '*',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.red,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          dropdownColor: dropdownColor ?? effectiveFill,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: textColor ?? AppColors.brandDark,
          ),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: iconColor ?? textColor ?? AppColors.brandDark,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: effectiveFill,
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
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }
}
