import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;

import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/core/widgets/app_card.dart';
import 'package:reservation_workshop/core/widgets/logo_image_widget.dart';
import 'package:reservation_workshop/modules/job_order_details/presentation/cubits/job_order_details_cubit/job_order_details_cubit.dart';
import 'package:reservation_workshop/modules/job_order_details/presentation/cubits/job_order_details_cubit/job_order_details_state.dart';

import 'job_order_details_args.dart';
import '../widgets/spare_parts_approval_widget.dart';

class JobOrderDetailsScreen extends StatelessWidget {
  const JobOrderDetailsScreen({super.key});

  Color? _tryParseHexColor(String? hex) {
    final h = hex?.trim();
    if (h == null || h.isEmpty) return null;
    var v = h;
    if (v.startsWith('#')) v = v.substring(1);
    if (v.length == 6) v = 'FF$v';
    if (v.length != 8) return null;
    final value = int.tryParse(v, radix: 16);
    if (value == null) return null;
    return Color(value);
  }

  Widget _fieldBox(String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE6E8EC)),
      ),
      child: Text(
        value.trim().isEmpty ? '-' : value,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value.trim().isEmpty ? '-' : value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.grey7,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w900,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _topBar() {
    return Container(
      height: 48,
      color: Colors.black,
      alignment: Alignment.center,
      child: const Text(
        'customerPortal',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _plateWidget(String plate) {
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

    return Container(
      width: 160,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6E8EC)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 24,
              decoration: const BoxDecoration(
                color: AppColors.brandPrimary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: const Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        'EGYPT',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
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
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 32,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Colors.black, width: 1),
                      ),
                    ),
                    child: Text(
                      numbers.toString().trim().isEmpty ? '-' : numbers.toString().trim(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 32,
                    alignment: Alignment.center,
                    child: Text(
                      letters.toString().trim().isEmpty ? '-' : letters.toString().trim(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final JobOrderDetailsArgs? detailsArgs = args is JobOrderDetailsArgs ? args : null;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      if (detailsArgs == null) return;
      context.read<JobOrderDetailsCubit>().load(
            jobOrderId: detailsArgs.jobOrderId,
            phoneLast4: detailsArgs.phoneLast4,
          );
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          _topBar(),
          Expanded(
            child: Container(
              child: BlocBuilder<JobOrderDetailsCubit, JobOrderDetailsState>(
                builder: (context, state) {
                  if (detailsArgs == null) {
                    return const Center(
                      child: Text(
                        'بيانات غير صالحة',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.grey7,
                        ),
                      ),
                    );
                  }

                  if (state is JobOrderDetailsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is JobOrderDetailsError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.grey7,
                          ),
                        ),
                      ),
                    );
                  }

                  if (state is! JobOrderDetailsSuccess) {
                    return const SizedBox.shrink();
                  }

                  final details = state.details;
                  final car = details.carInfo;
                  final statuses = [...state.statuses];
                  statuses.sort((a, b) => (a.sortOrder ?? 9999).compareTo(b.sortOrder ?? 9999));

                  return Directionality(
                    textDirection: ui.TextDirection.rtl,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 360),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 6),
                              const LogoImageWidget(),
                              const SizedBox(height: 10),
                              AppCard(
                                padding: const EdgeInsets.all(16),
                                borderRadius: 16,
                                borderColor: const Color(0xFFEFF1F5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _sectionTitle('job_order.details.customer_data'.tr()),
                                    const SizedBox(height: 8),
                                    _fieldBox(car?.name ?? '-'),
                                    const SizedBox(height: 10),
                                    _fieldBox(car?.mobile ?? '-'),
                                    const SizedBox(height: 10),
                                    _fieldBox(details.jobSheetNo),
                                    const SizedBox(height: 10),
                                    _fieldBox(car?.entryDate ?? '-'),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                              AppCard(
                                padding: const EdgeInsets.all(16),
                                borderRadius: 16,
                                borderColor: const Color(0xFFEFF1F5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _sectionTitle('job_order.details.car_data'.tr()),
                                    const SizedBox(height: 8),
                                    _fieldBox(car?.catname ?? '-'),
                                    const SizedBox(height: 10),
                                    _fieldBox(car?.model ?? '-'),
                                    const SizedBox(height: 10),
                                    _fieldBox(car?.year ?? '-'),
                                    const SizedBox(height: 10),
                                    _fieldBox(car?.chassisNumber ?? '-'),
                                    const SizedBox(height: 10),
                                    _fieldBox(car?.service ?? '-'),
                                    const SizedBox(height: 14),
                                    Center(child: _plateWidget(car?.plateNumber ?? '')),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                              AppCard(
                                padding: const EdgeInsets.all(16),
                                borderRadius: 16,
                                borderColor: const Color(0xFFEFF1F5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _sectionTitle('job_order.details.remaining_time'.tr()),
                                    const SizedBox(height: 8),
                                    _fieldBox(details.bookingStart),
                                    const SizedBox(height: 10),
                                    _fieldBox('${details.days} ${'job_order.details.units.day'.tr()}'),
                                    const SizedBox(height: 10),
                                    _fieldBox('${details.hours} ${'job_order.details.units.hour'.tr()}'),
                                    const SizedBox(height: 10),
                                    _fieldBox('${details.minutes} ${'job_order.details.units.minute'.tr()}'),
                                    const SizedBox(height: 10),
                                    _fieldBox('${details.seconds} ${'job_order.details.units.second'.tr()}'),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                              AppCard(
                                padding: const EdgeInsets.all(16),
                                borderRadius: 16,
                                borderColor: const Color(0xFFEFF1F5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _sectionTitle('job_order.details.service_stages'.tr()),
                                    const SizedBox(height: 6),
                                    SizedBox(
                                      height: (statuses.length <= 3) ? null : 198,
                                      child: ListView.separated(
                                        padding: EdgeInsets.zero,
                                        physics: statuses.length <= 3
                                            ? const NeverScrollableScrollPhysics()
                                            : const BouncingScrollPhysics(),
                                        itemCount: statuses.length,
                                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                                        itemBuilder: (context, index) {
                                          final s = statuses[index];
                                          final isActive = s.id == details.statusId;
                                          final indicatorColor = _tryParseHexColor(s.color) ?? const Color(0xFF9CA3AF);

                                          return Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF1F3F5),
                                              borderRadius: BorderRadius.circular(14),
                                              border: Border.all(color: const Color(0xFFE6E8EC)),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    s.name.trim().isEmpty ? '-' : s.name,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w800,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 22,
                                                  height: 22,
                                                  decoration: BoxDecoration(
                                                    color: isActive ? indicatorColor : Colors.transparent,
                                                    borderRadius: BorderRadius.circular(11),
                                                    border: Border.all(
                                                      color: indicatorColor,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: isActive
                                                      ? const Icon(
                                                          Icons.check,
                                                          size: 14,
                                                          color: Colors.white,
                                                        )
                                                      : null,
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                              SparePartsApprovalWidget(items: details.jobOrder),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
