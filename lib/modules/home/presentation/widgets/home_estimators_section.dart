import 'package:flutter/material.dart';

import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/core/functions/localization_helper.dart';
import 'package:reservation_workshop/core/widgets/app_card.dart';

class HomeEstimatorsSection extends StatelessWidget {
  const HomeEstimatorsSection({
    super.key,
    required this.onRequestEstimatorNow,
  });

  final VoidCallback onRequestEstimatorNow;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      borderRadius: 18,
      borderColor: const Color(0xFFEFF1F5),
      boxShadow: const [
        BoxShadow(
          color: Color(0x14000000),
          blurRadius: 26,
          offset: Offset(0, 14),
        ),
      ],
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t(context, 'home.estimators_title', ar: 'المقايسات', en: 'Estimators'),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  t(context, 'home.estimators_cta', ar: 'اطلب مقايسة الآن', en: 'Request an estimator'),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey7,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    onPressed: onRequestEstimatorNow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brandPrimary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      t(context, 'home.estimators_cta', ar: 'اطلب مقايسة الآن', en: 'Request an estimator'),
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.brandPrimarySoft,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.receipt_long,
              color: AppColors.brandPrimary,
              size: 34,
            ),
          ),
        ],
      ),
    );
  }
}
