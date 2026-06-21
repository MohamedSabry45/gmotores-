import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:reservation_workshop/config/style/app_colors.dart';

import '../../data/datasources/vehicle_filters_remote_datasource.dart';

class ModernDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<Map<String, String>> items;
  final ValueChanged<String?> onChanged;

  const ModernDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.tune_rounded, color: AppColors.brandPrimary, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
            dropdownColor: Colors.white,
            isExpanded: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.brandPrimary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              hintStyle: TextStyle(color: Colors.grey.shade500),
            ),
            items: items.map((item) {
              return DropdownMenuItem(
                value: item['value'],
                child: Text(
                  item[isArabic ? 'ar' : 'en']!,
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class FilterDropdown extends StatelessWidget {
  final String label;
  final FilterItem? value;
  final List<FilterItem> items;
  final ValueChanged<FilterItem?> onChanged;
  final bool isLoading;
  final bool enabled;

  const FilterDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.isLoading = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<FilterItem>(
          value: value,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          dropdownColor: Colors.white,
          isExpanded: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.brandPrimary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            hintStyle: TextStyle(color: Colors.grey.shade500),
          ),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item.name, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
            );
          }).toList(),
          onChanged: enabled ? onChanged : null,
        ),
      ],
    );
  }
}
