import 'package:flutter/material.dart';

import 'package:reservation_workshop/config/style/app_colors.dart';

class VehicleDescriptionSection extends StatelessWidget {
  final String description;
  final String conditionNotes;

  const VehicleDescriptionSection({
    super.key,
    required this.description,
    required this.conditionNotes,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (description.trim().isEmpty && conditionNotes.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.brandOutline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900),
          ),
          if (description.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.grey7,
                height: 1.4,
              ),
            ),
          ],
          if (conditionNotes.trim().isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              'Condition notes',
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w900, color: AppColors.brandDark),
            ),
            const SizedBox(height: 6),
            Text(
              conditionNotes,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.grey7,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
