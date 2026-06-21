import 'package:flutter/material.dart';

import 'package:reservation_workshop/config/style/app_colors.dart';

import '../../domain/entities/vehicle.dart';

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;
  final VoidCallback? onTap;

  const VehicleCard({
    super.key,
    required this.vehicle,
    this.onTap,
  });

  String _formatNumber(num value) {
    final s = value.toStringAsFixed(0);
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idxFromEnd = s.length - i;
      buf.write(s[i]);
      if (idxFromEnd > 1 && idxFromEnd % 3 == 1) {
        buf.write(',');
      }
    }
    final raw = buf.toString();
    return raw.endsWith(',') ? raw.substring(0, raw.length - 1) : raw;
  }

  String _formatPrice(String raw) {
    final parsed = double.tryParse(raw) ?? double.tryParse(raw.replaceAll(',', ''));
    if (parsed == null) return raw;
    return _formatNumber(parsed);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.brandOutline),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if ((vehicle.primaryImageUrl ?? '').isNotEmpty)
                        Image.network(
                          vehicle.primaryImageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, _, __) {
                            return Image.asset('assets/images/bummy.jpg', fit: BoxFit.cover);
                          },
                        )
                      else
                        Image.asset('assets/images/bummy.jpg', fit: BoxFit.cover),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.45),
                              Colors.black.withOpacity(0.0),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            if (vehicle.isPremium)
                              _Badge(
                                icon: Icons.star,
                                label: 'Premium',
                                background: AppColors.yellow,
                                foreground: Colors.black87,
                              ),
                            if (vehicle.isFeatured)
                              const _Badge(
                                icon: Icons.local_fire_department,
                                label: 'Featured',
                                background: AppColors.brandPrimary,
                                foreground: Colors.white,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${_formatPrice(vehicle.listingPrice)} ${vehicle.currency}',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: AppColors.brandPrimary,
                            ),
                          ),
                        ),
                        _MiniStat(
                          icon: Icons.visibility_outlined,
                          text: vehicle.viewCount.toString(),
                        ),
                        const SizedBox(width: 8),
                        _MiniStat(
                          icon: Icons.favorite_border,
                          text: vehicle.favoritesCount.toString(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${vehicle.make} ${vehicle.modelName} ${vehicle.year}',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      vehicle.trimLevel.isEmpty ? vehicle.bodyType : vehicle.trimLevel,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.grey7,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (vehicle.bodyType.isNotEmpty) _PillChip(text: vehicle.bodyType),
                        if (vehicle.color.isNotEmpty) _PillChip(text: vehicle.color),
                        _PillChip(text: '${_formatNumber(vehicle.mileageKm)} KM'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 16, color: AppColors.grey7),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            vehicle.locationCity,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.grey7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PillChip extends StatelessWidget {
  final String text;

  const _PillChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white2,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.brandOutline),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 12,
          color: AppColors.brandDark,
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MiniStat({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white3,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.brandOutline),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.grey7),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: AppColors.brandDark),
          ),
        ],
      ),
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
