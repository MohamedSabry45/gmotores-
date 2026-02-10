import 'package:flutter/material.dart';

import 'package:reservation_workshop/config/routes/routes_name.dart';
import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/core/functions/localization_helper.dart';
import 'package:reservation_workshop/core/widgets/app_card.dart';
import 'package:reservation_workshop/core/widgets/status_chip.dart';

class NotificationCardModel {
  NotificationCardModel({
    required this.workOrderNo,
    required this.customer,
    required this.car,
    required this.carModel,
    required this.plate,
    required this.status,
    required this.dateTime,
    required this.service,
    required this.branch,
    required this.area,
    required this.name,
    required this.phone,
  });

  final String workOrderNo;
  final String customer;
  final String car;
  final String carModel;
  final String plate;
  final String status;
  final String dateTime;
  final String service;
  final String branch;
  final String area;
  final String name;
  final String phone;
}

class NotificationCard extends StatelessWidget {
  const NotificationCard({super.key, required this.model});

  final NotificationCardModel model;

  ({
    Color cardColor,
    Color cardBorder,
    Color chipColor,
    Color chipTextColor,
    String statusText,
  }) _statusStyle(String status) {
    final s = status.trim().toLowerCase();

    if (s == 'booked') {
      return (
        cardColor: const Color(0xFFF7FFFB),
        cardBorder: const Color(0xFFE0F2F1),
        chipColor: const Color(0xFFDFF5F3),
        chipTextColor: const Color(0xFF2C7A7B),
        statusText: 'booking_status.booked',
      );
    }

    if (s == 'waiting') {
      return (
        cardColor: const Color(0xFFF5F8FF),
        cardBorder: const Color(0xFFD9E6FF),
        chipColor: const Color(0xFFE6EEFF),
        chipTextColor: const Color(0xFF1D4ED8),
        statusText: 'booking_status.waiting',
      );
    }

    if (s == 'request') {
      return (
        cardColor: const Color(0xFFFFFBEB),
        cardBorder: const Color(0xFFFDE68A),
        chipColor: const Color(0xFFFFF1C7),
        chipTextColor: const Color(0xFFB45309),
        statusText: 'booking_status.request',
      );
    }

    return (
      cardColor: Colors.white,
      cardBorder: const Color(0xFFE6E8EC),
      chipColor: const Color(0xFFEFF1F5),
      chipTextColor: Colors.black87,
      statusText: status.trim().isEmpty ? '-' : status,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final style = _statusStyle(model.status);
    final statusLabel = getTranslated(style.statusText, context) ?? style.statusText;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.pushNamed(
            context,
            RoutesName.bookingDetailsScreen,
            arguments: model,
          );
        },
        child: AppCard(
          padding: const EdgeInsets.all(14),
          backgroundColor: style.cardColor,
          borderColor: style.cardBorder,
          borderRadius: 14,
          child: Column(
            children: [
              _RowItem(
                label: getTranslated('booking_card.work_order_no', context) ?? 'Work order no.',
                value: model.workOrderNo,
                valueColor: AppColors.brandPrimary,
              ),
              const SizedBox(height: 10),
              _RowItem(label: getTranslated('booking_card.customer', context) ?? 'Customer', value: model.customer),
              const SizedBox(height: 10),
              _RowItem(label: getTranslated('booking_card.brand', context) ?? 'Brand', value: model.car),
              const SizedBox(height: 10),
              _RowItem(label: getTranslated('booking_card.plate', context) ?? 'Plate number', value: model.plate),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      getTranslated('booking_card.booking_status', context) ?? 'Booking status',
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.grey7,
                      ),
                    ),
                  ),
                  StatusChip(
                    label: statusLabel,
                    background: style.chipColor,
                    foreground: style.chipTextColor,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _RowItem(label: getTranslated('booking_card.booking_date', context) ?? 'Booking date', value: model.dateTime),
            ],
          ),
        ),
      ),
    );
  }
}

class _RowItem extends StatelessWidget {
  const _RowItem({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.grey7,
            ),
          ),
        ),
        Text(
          value,
          style: textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: valueColor ?? AppColors.brandDark,
          ),
        ),
      ],
    );
  }
}
