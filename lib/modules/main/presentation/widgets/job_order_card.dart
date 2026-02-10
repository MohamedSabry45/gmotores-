import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/core/widgets/app_card.dart';

class JobOrderCardModel {
  final int jobOrderId;
  final String? plateNumber;
  final String jobSheetNo;
  final String status;
  final String branch;
  final String carType;
  final String? bookingDate;

  JobOrderCardModel({
    required this.jobOrderId,
    required this.plateNumber,
    required this.jobSheetNo,
    required this.status,
    required this.branch,
    required this.carType,
    required this.bookingDate,
  });
}

class JobOrderCard extends StatelessWidget {
  const JobOrderCard({super.key, required this.model, this.onTap});

  final JobOrderCardModel model;
  final VoidCallback? onTap;

  _PlateParts _parsePlate(String plate) {
    final cleaned = plate.trim();
    final letters = StringBuffer();
    final numbers = StringBuffer();

    for (final codePoint in cleaned.runes) {
      final ch = String.fromCharCode(codePoint);

      final isDigit = RegExp(r'[0-9\u0660-\u0669]').hasMatch(ch);
      if (isDigit) {
        numbers.write(ch);
        continue;
      }

      final isLetter = RegExp(r'[A-Za-z\u0600-\u06FF]').hasMatch(ch);
      if (isLetter) {
        letters.write(ch);
      }
    }

    return _PlateParts(
      letters: letters.toString(),
      numbers: numbers.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final plate = model.plateNumber?.trim() ?? '';
    final parts = plate.isEmpty ? const _PlateParts(letters: '', numbers: '') : _parsePlate(plate);

    return Center(
      child: SizedBox(
        width: 320,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: AppCard(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            borderRadius: 16,
            borderColor: AppColors.brandOutline,
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
            child: Column(
            children: [
            /// ====== CARD SMALL TABLE ======
            Container(
              width: 200,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.brandSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.brandOutline),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.brandDark, width: 1),
                ),
                child: Column(
                  children: [
                    /// HEADER
                    Container(
                      height: 26,
                      decoration: const BoxDecoration(
                        color: AppColors.brandPrimary,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                'EGYPT',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'مصر',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// BODY
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 34,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(color: AppColors.brandDark, width: 1),
                              ),
                            ),
                            child: Text(
                              (parts.numbers.trim().isEmpty ? '-' : parts.numbers.trim()),
                              style: textTheme.bodyMedium?.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: AppColors.brandDark,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 34,
                            alignment: Alignment.center,
                            child: Text(
                              (parts.letters.trim().isEmpty ? '-' : parts.letters.trim()),
                              style: textTheme.bodyMedium?.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: AppColors.brandDark,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            /// ====== TEXT DETAILS ======
            Text(
              '${'job_order.maintenance.card.operation_order_no'.tr()}: ${model.jobSheetNo}',
              style: textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.brandDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${'job_order.maintenance.card.location'.tr()}: ${model.branch.trim().isEmpty ? '-' : model.branch}',
              style: textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.grey7,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${'job_order.maintenance.card.car_type'.tr()}: ${model.carType.trim().isEmpty ? '-' : model.carType}',
              style: textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.grey7,
              ),
            ),
          ],
          ),
          ),
        ),
      ),
    );
  }
}

class _PlateParts {
  final String letters;
  final String numbers;

  const _PlateParts({
    required this.letters,
    required this.numbers,
  });
}
