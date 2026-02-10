import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/core/functions/localization_helper.dart';
import 'package:reservation_workshop/modules/main/presentation/widgets/notification_card.dart';
import 'package:reservation_workshop/modules/bookings/presentation/cubits/bookings_cubit/bookings_cubit.dart';
import 'package:reservation_workshop/modules/bookings/presentation/cubits/bookings_cubit/bookings_state.dart';
import 'package:reservation_workshop/modules/customer/presentation/cubits/customer_info_cubit/customer_info_cubit.dart';
import 'package:reservation_workshop/modules/customer/presentation/cubits/customer_info_cubit/customer_info_state.dart';
import 'package:reservation_workshop/core/widgets/app_header.dart';

class InformationBookingsScreen extends StatelessWidget {
  const InformationBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      context.read<BookingsCubit>().load();
      context.read<CustomerInfoCubit>().load();
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.appBackgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              AppHeader(
                title: getTranslated('booking_info.title', context) ?? 'Booking information',
                onBack: () => Navigator.pop(context),
              ),
              Expanded(
                child: BlocBuilder<BookingsCubit, BookingsState>(
                  builder: (context, bookingState) {
                    if (bookingState is BookingsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (bookingState is BookingsError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            bookingState.message,
                            textAlign: TextAlign.center,
                            style: textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.grey7,
                            ),
                          ),
                        ),
                      );
                    }

                    final bookings = bookingState is BookingsSuccess ? bookingState.bookings : const [];
                    final items = bookings
                        .map(
                          (b) => NotificationCardModel(
                            workOrderNo: (b.jobSheetNo?.trim().isNotEmpty == true) ? b.jobSheetNo!.trim() : '-',
                            car: b.brand,
                            carModel: b.model,
                            plate: (b.plateNumber?.trim().isNotEmpty == true) ? b.plateNumber!.trim() : '-',
                            status: b.bookingStatus,
                            dateTime: b.bookingStart,
                            service: b.service,
                            branch: (b.location?.trim().isNotEmpty == true) ? b.location!.trim() : '-',
                            area: (b.bookingNote?.trim().isNotEmpty == true) ? b.bookingNote!.trim() : '-',
                            customer: '',
                            name: '',
                            phone: '',
                          ),
                        )
                        .toList();

                    if (items.isEmpty) {
                      return Center(
                        child: Text(
                          getTranslated('booking_info.empty', context) ?? 'No bookings',
                          style: textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.grey7,
                          ),
                        ),
                      );
                    }

                    return BlocBuilder<CustomerInfoCubit, CustomerInfoState>(
                      builder: (context, customerState) {
                        final name = customerState is CustomerInfoSuccess ? customerState.info.name : '';
                        final phone = customerState is CustomerInfoSuccess ? customerState.info.mobile : '';

                        final enriched = items
                            .map(
                              (m) => NotificationCardModel(
                                workOrderNo: m.workOrderNo,
                                customer: name,
                                car: m.car,
                                carModel: m.carModel,
                                plate: m.plate,
                                status: m.status,
                                dateTime: m.dateTime,
                                service: m.service,
                                branch: m.branch,
                                area: m.area,
                                name: name,
                                phone: phone,
                              ),
                            )
                            .toList();

                        return ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                          itemCount: enriched.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return NotificationCard(model: enriched[index]);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
