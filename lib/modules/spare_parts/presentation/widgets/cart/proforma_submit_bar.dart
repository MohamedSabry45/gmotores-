import 'package:flutter/material.dart';

import 'package:reservation_workshop/config/style/app_colors.dart';

class ProformaSubmitBar extends StatelessWidget {
  final bool enabled;
  final bool submitting;
  final double total;
  final VoidCallback onSubmit;

  const ProformaSubmitBar({
    super.key,
    required this.enabled,
    required this.submitting,
    required this.total,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.brandOutline.withOpacity(0.35))),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.brandDark),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${total.toStringAsFixed(2)} EGP',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      color: AppColors.brandDark,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: enabled ? onSubmit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandPrimary,
                  disabledBackgroundColor: AppColors.brandPrimary.withOpacity(0.4),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                      )
                    : const Text(
                        'Create Proforma',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
