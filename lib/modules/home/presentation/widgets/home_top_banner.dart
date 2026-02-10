import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:reservation_workshop/config/routes/routes_name.dart';

class HomeTopBanner extends StatelessWidget {
  const HomeTopBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.zero,
      child: AspectRatio(
        aspectRatio: 343 / 140,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/bannar.png',
              fit: BoxFit.cover,
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 10,
              child: Row(
                children: [
                  Expanded(
                    child: _BannerAction(
                      icon: Icons.car_repair,
                      label: 'home.spare_parts'.tr(),
                      onTap: () => Navigator.of(context).pushNamed(RoutesName.sparePartsScreen),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _BannerAction(
                      icon: Icons.directions_car,
                      label: 'home.contact_cars'.tr(),
                      onTap: () => Navigator.of(context).pushNamed(RoutesName.buyCarScreen),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BannerAction extends StatelessWidget {
  const _BannerAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.zero,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xB3000000),
            borderRadius: BorderRadius.zero,
            border: Border.all(color: const Color(0x26FFFFFF)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: Colors.white),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
