import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:reservation_workshop/modules/bookings/presentation/cubits/add_booking_cubit/add_booking_cubit.dart';
import 'package:reservation_workshop/modules/bookings/presentation/cubits/add_booking_cubit/add_booking_state.dart';
import 'package:reservation_workshop/modules/main/presentation/screens/booking_details_args.dart';
import 'package:reservation_workshop/modules/main/presentation/widgets/notification_card.dart';
import 'package:reservation_workshop/modules/main/presentation/widgets/booking_details_card.dart';
import 'package:reservation_workshop/core/widgets/app_header.dart';

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({super.key});

  Future<void> _showResultDialog(
    BuildContext context, {
    required String title,
    required String message,
    required bool popScreenAfter,
  }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
            ),
            content: Text(
              message.trim().isEmpty ? '-' : message,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  if (popScreenAfter) {
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  'حسناً',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    final BookingDetailsArgs? bookingArgs = args is BookingDetailsArgs ? args : null;
    final NotificationCardModel? model = bookingArgs?.model ?? (args is NotificationCardModel ? args : null);

    final canConfirm = bookingArgs != null;

    return Scaffold(
      body: BlocConsumer<AddBookingCubit, AddBookingState>(
        listener: (context, state) {
          if (state is AddBookingSuccess) {
            _showResultDialog(
              context,
              title: 'تم تأكيد الحجز',
              message: state.message,
              popScreenAfter: true,
            );
          }
          if (state is AddBookingError) {
            _showResultDialog(
              context,
              title: 'فشل تأكيد الحجز',
              message: state.message,
              popScreenAfter: false,
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AddBookingLoading;

          return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF7FAFF), Color(0xFFF4F7FB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              AppHeader(
                title: 'تفاصيل الحجز',
                onBack: () => Navigator.pop(context),
              ),
              Expanded(
                child: Center(
                  child: BookingDetailsCard(
                    model: model,
                    canConfirm: canConfirm,
                    onBack: () => Navigator.pop(context),
                    onConfirm: () {
                      if (!canConfirm || bookingArgs == null) {
                        return;
                      }
                      if (isLoading) {
                        return;
                      }

                      context.read<AddBookingCubit>().addBooking(
                            bookingStart: bookingArgs.bookingStart,
                            locationId: bookingArgs.locationId,
                            bookingNote: bookingArgs.bookingNote,
                            serviceId: bookingArgs.serviceId,
                            deviceId: bookingArgs.deviceId,
                          );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
        },
      ),
    );
  }
}
