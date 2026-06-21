import 'package:flutter/material.dart';

import 'package:reservation_workshop/config/style/app_colors.dart';

import '../../../domain/entities/vehicle_details.dart';

class VehicleSellerCard extends StatelessWidget {
  final VehicleSeller seller;

  const VehicleSellerCard({
    super.key,
    required this.seller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.brandOutline),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.white2,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.brandOutline),
            ),
            child: const Icon(Icons.person_outline, color: AppColors.brandDark),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  seller.name,
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(
                  seller.mobile,
                  style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.grey7),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.brandPrimarySoft,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.brandOutline),
            ),
            child: Text(
              seller.type,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: AppColors.brandPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
