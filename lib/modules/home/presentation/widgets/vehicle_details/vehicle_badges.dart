import 'package:flutter/material.dart';

import 'package:reservation_workshop/config/style/app_colors.dart';

class VehicleBadges extends StatelessWidget {
  final bool isPremium;
  final bool isFeatured;

  const VehicleBadges({
    super.key,
    required this.isPremium,
    required this.isFeatured,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (isPremium)
          _Badge(
            icon: Icons.star,
            label: 'Premium',
            background: AppColors.yellow,
            foreground: Colors.black87,
          ),
        if (isFeatured)
          const _Badge(
            icon: Icons.local_fire_department,
            label: 'Featured',
            background: AppColors.brandPrimary,
            foreground: Colors.white,
          ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;

  const _Badge({
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: foreground),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 12,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}
