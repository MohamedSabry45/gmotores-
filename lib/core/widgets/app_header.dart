import 'package:flutter/material.dart';

import 'package:reservation_workshop/config/style/app_colors.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    required this.title,
    required this.onBack,
    this.trailing,
  });

  final String title;
  final VoidCallback onBack;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onBack,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.brandSurface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.brandOutline),
              ),
              child: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.brandDark),
            ),
          ),
          const Spacer(),
          Column(
            children: [
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              SizedBox(
                width: 28,
                height: 2,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: textTheme.titleMedium?.color ?? Colors.white),
                ),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(width: trailing == null ? 52 : 0),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
