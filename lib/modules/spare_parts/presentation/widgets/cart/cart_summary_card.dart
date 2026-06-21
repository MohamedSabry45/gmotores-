import 'package:flutter/material.dart';

import 'package:reservation_workshop/config/style/app_colors.dart';

class CartSummaryCard extends StatelessWidget {
  final int totalQuantity;
  final double subtotal;
  final double total;

  const CartSummaryCard({
    super.key,
    required this.totalQuantity,
    required this.subtotal,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.brandOutline.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _Row(label: 'Items', value: '$totalQuantity'),
          const SizedBox(height: 10),
          _Row(label: 'Subtotal', value: '${subtotal.toStringAsFixed(2)} EGP'),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 10),
          _Row(
            label: 'Total',
            value: '${total.toStringAsFixed(2)} EGP',
            valueStyle: const TextStyle(
              fontWeight: FontWeight.w900,
              color: AppColors.brandDark,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const _Row({
    required this.label,
    required this.value,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            color: AppColors.brandDark,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: valueStyle ??
              const TextStyle(
                fontWeight: FontWeight.w900,
                color: AppColors.brandDark,
              ),
        ),
      ],
    );
  }
}
