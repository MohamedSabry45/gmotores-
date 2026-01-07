import 'package:flutter/material.dart';
import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/core/widgets/app_card.dart';
import '../../domain/entities/job_estimator.dart';

class JobEstimatorCard extends StatelessWidget {
  const JobEstimatorCard({super.key, required this.item, this.onTap});

  final JobEstimator item;
  final VoidCallback? onTap;

  _PlateParts _parsePlate(String plate) {
    final letters = StringBuffer();
    final numbers = StringBuffer();

    for (final ch in plate.runes.map(String.fromCharCode)) {
      if (RegExp(r'[0-9\u0660-\u0669]').hasMatch(ch)) {
        numbers.write(ch);
      } else if (RegExp(r'[A-Za-z\u0600-\u06FF]').hasMatch(ch)) {
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
    final plate = (item.plateNumber ?? '').trim();
    final parts =
        plate.isEmpty ? const _PlateParts(letters: '', numbers: '') : _parsePlate(plate);

    return Center(
      child: SizedBox(
        width: 320,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: AppCard(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 22),
          borderRadius: 16,
          borderColor: AppColors.brandPrimary,
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 18,
              offset: Offset(0, 10),
            ),
          ],
          child: Column(
            children: [
              /// ===== PLATE =====
              Container(
                width: 200,
                height: 92,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F8FA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE6E8EC)),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 26,
                        decoration: const BoxDecoration(
                          color: AppColors.brandPrimary,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(8),
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
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    right: BorderSide(color: Colors.black),
                                  ),
                                ),
                                child: Text(
                                  parts.numbers.isEmpty ? '-' : parts.numbers,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  parts.letters.isEmpty ? '-' : parts.letters,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              /// ===== DETAILS =====
              _InfoLine('العميل', item.customerName, bold: true),
              _InfoLine('الماركة', item.brand),
              _InfoLine('الموديل', item.model),
              _InfoLine('الفرع', item.locationName),
              _InfoLine(
                'اللون',
                item.color?.trim().isEmpty == true ? '-' : item.color,
              ),
              _InfoLine('الحالة', item.estimatorStatus),
            ],
          ),
        ),
      ),
    ));
  }
}

/// ===== INFO LINE =====
class _InfoLine extends StatelessWidget {
  final String label;
  final String? value;
  final bool bold;

  const _InfoLine(this.label, this.value, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        '$label: ${value ?? '-'}',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          height: 1.3,
          fontWeight: bold ? FontWeight.w600 : FontWeight.w500,
          color: bold ? Colors.black87 : AppColors.grey7,
        ),
      ),
    );
  }
}

class _PlateParts {
  final String letters;
  final String numbers;
  const _PlateParts({required this.letters, required this.numbers});
}
