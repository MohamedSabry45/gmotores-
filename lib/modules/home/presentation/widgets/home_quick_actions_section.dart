import 'package:flutter/material.dart';

import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/core/functions/localization_helper.dart';
import 'package:reservation_workshop/core/widgets/app_card.dart';

class HomeQuickActionsSection extends StatelessWidget {
  const HomeQuickActionsSection({
    super.key,
    required this.onBookNow,
    required this.onMaintenance,
  });

  final VoidCallback onBookNow;
  final VoidCallback onMaintenance;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionTile(
            title: t(context, 'home.quick_book_now', ar: 'احجز الآن', en: 'Book now'),
            icon: Icons.event_available,
            accent: const Color(0xFF16A34A),
            onTap: onBookNow,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionTile(
            title: t(context, 'home.quick_rescue', ar: 'خدمة إنقاذ', en: 'Rescue service'),
            icon: Icons.emergency_share,
            accent: AppColors.brandPrimary,
            onTap: onMaintenance,
          ),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.title,
    required this.onTap,
    required this.icon,
    required this.accent,
  });

  final String title;
  final VoidCallback onTap;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      backgroundGradient: AppColors.appBackgroundGradient,
      borderRadius: 18,
      borderColor: AppColors.gridLinesColor,
      boxShadow: const [
        BoxShadow(
          color: Color(0x14000000),
          blurRadius: 26,
          offset: Offset(0, 14),
        ),
      ],
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
                Icon(
                  isLtr(context) ? Icons.chevron_right : Icons.chevron_right,
                  size: 20,
                  color: Colors.white70,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
