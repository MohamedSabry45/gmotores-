import 'package:flutter/material.dart';
import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/modules/main/presentation/widgets/notification_card.dart';

class BookingDetailsCard extends StatelessWidget {
  const BookingDetailsCard({
    super.key,
    required this.model,
    required this.onBack,
    required this.onConfirm,
    this.canConfirm = true,
  });

  final NotificationCardModel? model;
  final VoidCallback onBack;
  final VoidCallback onConfirm;
  final bool canConfirm;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // 🔥 مهم
      child: Center(
        child: Container(
          width: 320,
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// ===== HEADER =====
              Container(
                height: 46,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFF1E2937),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: const Text(
                  'تفاصيل الحجز',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),

              /// ===== CONTENT =====
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                child: Column(
                  children: [
                    _DetailRow('التاريخ:', model?.dateTime),
                    _gap(),
                    _DetailRow('الخدمة:', model?.service),
                    _gap(),
                    _DetailRow('الماركة:', model?.car),
                    _gap(),
                    _DetailRow('الموديل:', model?.carModel),
                    _gap(),
                    _DetailRow('رقم اللوحة:', model?.plate),
                    _gap(),
                    _DetailRow('الموقع:', model?.branch),
                    _gap(),
                    _DetailRow('الملاحظات:', model?.area),
                  ],
                ),
              ),

              const Divider(height: 1, color: Color(0xFFE5E7EB)),

              /// ===== CUSTOMER INFO =====
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Column(
                  children: [
                    _DetailRow('الاسم:', model?.name),
                    _gap(),
                    _DetailRow('الهاتف:', model?.phone),
                  ],
                ),
              ),

              /// ===== ACTIONS =====
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: onBack,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E2937),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'رجوع',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: canConfirm ? onConfirm : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6B7280),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'تأكيد',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
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
    );
  }

  Widget _gap() => const SizedBox(height: 12);
}

/// ===== ROW ITEM =====
class _DetailRow extends StatelessWidget {
  const _DetailRow(this.label, this.value);

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.grey7,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value?.isNotEmpty == true ? value! : '-',
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
