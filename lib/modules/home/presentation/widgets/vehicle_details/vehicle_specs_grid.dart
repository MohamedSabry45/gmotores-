import 'package:flutter/material.dart';

import 'package:reservation_workshop/config/style/app_colors.dart';

class VehicleSpecsGrid extends StatelessWidget {
  final List<SpecItem> items;

  const VehicleSpecsGrid({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.brandOutline),
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 3.0,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _SpecTile(
            icon: item.icon,
            label: item.label,
            value: item.value,
            theme: theme,
          );
        },
      ),
    );
  }
}

class SpecItem {
  final IconData icon;
  final String label;
  final String value;

  const SpecItem({
    required this.icon,
    required this.label,
    required this.value,
  });
}

class _SpecTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ThemeData theme;

  const _SpecTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white2,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.brandOutline),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.brandPrimarySoft,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.brandOutline),
            ),
            child: Icon(icon, size: 18, color: AppColors.brandPrimary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.grey7,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppColors.brandDark,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

List<SpecItem> buildSpecs({
  required int mileageKm,
  required String transmission,
  required String fuelType,
  required int engineCapacityCc,
  required int cylinderCount,
  required String condition,
  required bool factoryPaint,
  required bool importedSpecs,
}) {
  return <SpecItem>[
    SpecItem(icon: Icons.speed, label: 'Mileage', value: '$mileageKm KM'),
    SpecItem(icon: Icons.settings, label: 'Transmission', value: transmission),
    SpecItem(icon: Icons.local_gas_station, label: 'Fuel', value: fuelType),
    SpecItem(icon: Icons.tune, label: 'Engine', value: '${engineCapacityCc}cc'),
    SpecItem(icon: Icons.blur_circular, label: 'Cylinders', value: cylinderCount.toString()),
    SpecItem(icon: Icons.history, label: 'Condition', value: condition),
    SpecItem(icon: Icons.format_paint, label: 'Factory Paint', value: factoryPaint ? 'Yes' : 'No'),
    SpecItem(icon: Icons.public, label: 'Imported', value: importedSpecs ? 'Yes' : 'No'),
  ].where((e) => e.value.trim().isNotEmpty && e.value.trim() != '0cc' && e.value.trim() != '0').toList();
}
