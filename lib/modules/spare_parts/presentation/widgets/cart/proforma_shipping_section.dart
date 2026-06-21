import 'package:flutter/material.dart';

import 'package:reservation_workshop/config/style/app_colors.dart';

class ProformaShippingSection extends StatelessWidget {
  final TextEditingController shippingDetailsController;
  final TextEditingController shippingAddressController;
  final TextEditingController shippingStatusController;
  final TextEditingController deliveredToController;

  const ProformaShippingSection({
    super.key,
    required this.shippingDetailsController,
    required this.shippingAddressController,
    required this.shippingStatusController,
    required this.deliveredToController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: AppColors.brandOutline.withOpacity(0.35)),
    );

    InputDecoration decorate() {
      return InputDecoration(
        filled: true,
        fillColor: AppColors.white2,
        hintStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          color: AppColors.brandDark,
        ),
        border: baseBorder,
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.brandPrimary, width: 1.6),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.brandOutline.withOpacity(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.brandPrimarySoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.local_shipping_outlined, color: AppColors.brandPrimary),
              ),
              const SizedBox(width: 10),
              Text(
                'Shipping',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.brandDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Shipping details',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: AppColors.brandDark,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: shippingDetailsController,
            decoration: decorate(),
            style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.brandDark),
          ),
          const SizedBox(height: 12),
          const Text(
            'Shipping address',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: AppColors.brandDark,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: shippingAddressController,
            decoration: decorate(),
            style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.brandDark),
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(
                child: Text(
                  'Shipping status',
                  style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.brandDark),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Delivered to',
                  style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.brandDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: shippingStatusController,
                  decoration: decorate(),
                  style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.brandDark),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: deliveredToController,
                  decoration: decorate(),
                  style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.brandDark),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
