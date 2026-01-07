import 'package:flutter/material.dart';

import 'package:reservation_workshop/config/style/app_colors.dart';

class ServiceSelector extends StatelessWidget {
  const ServiceSelector({
    super.key,
    required this.label,
    required this.isRequired,
    required this.selected,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final bool isRequired;
  final String? selected;
  final List<String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              const Text(
                '*',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.brandPrimary,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: options.map((o) {
            final bool isActive = selected == o;
            final bool isFirst = o == options.first;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: isFirst ? 10 : 0),
                child: InkWell(
                  onTap: () => onChanged(o),
                  borderRadius: BorderRadius.circular(14),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.brandPrimarySoft2 : AppColors.brandSurface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isActive ? AppColors.brandPrimary : AppColors.brandOutline,
                        width: isActive ? 1.2 : 1,
                      ),
                      boxShadow: isActive
                          ? const [
                              BoxShadow(
                                color: AppColors.brandPrimarySoft2,
                                blurRadius: 18,
                                offset: Offset(0, 10),
                              ),
                            ]
                          : const [],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isFirst ? Icons.local_car_wash_outlined : Icons.build_outlined,
                          size: 18,
                          color: isActive ? AppColors.brandPrimary : AppColors.grey7,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            o,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.2,
                              fontWeight: FontWeight.w700,
                              color: isActive ? AppColors.brandDark : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
