import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;

import 'package:reservation_workshop/config/routes/routes_name.dart';
import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/core/components/dialogs/prograss_delay_dialog.dart';
import 'package:reservation_workshop/core/components/toasters.dart';
import 'package:reservation_workshop/modules/customer/domain/entities/customer_car.dart';
import 'package:reservation_workshop/modules/customer/presentation/cubits/customer_info_cubit/customer_info_cubit.dart';
import 'package:reservation_workshop/modules/customer/presentation/cubits/customer_info_cubit/customer_info_state.dart';

class MenuAccountScreen extends StatefulWidget {
  const MenuAccountScreen({super.key});

  @override
  State<MenuAccountScreen> createState() => _MenuAccountScreenState();
}

class _MenuAccountScreenState extends State<MenuAccountScreen> {
  static const double _headerHeight = 240;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<CustomerInfoCubit>().load();
    });
  }

  Widget _item({
    required IconData icon,
    required String value,
    String? hint,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 56,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.itemsBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.gridLinesColor),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  if (hint != null && hint.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      hint,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                color: AppColors.brandPrimarySoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    return BlocListener<CustomerInfoCubit, CustomerInfoState>(
      listener: (context, state) {
        if (state is CustomerInfoLoading) {
          showPrograssDelayDialog(context);
        } else {
          Navigator.of(context, rootNavigator: true).maybePop();
          if (state is CustomerInfoError) {
            Toasters.show(state.message);
          }
        }
      },
      child: Directionality(
        textDirection: isAr ? ui.TextDirection.rtl : ui.TextDirection.ltr,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.appBackgroundGradient,
                ),
              ),
              Container(
                height: _headerHeight,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.brandDark, AppColors.brandPrimary],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(60),
                  ),
                ),
              ),

              /// BACK BUTTON
              SafeArea(
                child: Align(
                  alignment: isAr ? Alignment.topRight : Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                ),
              ),

              Positioned.fill(
                top: _headerHeight - 60, 
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    children: [
                      Transform.translate(
                        offset: const Offset(0, -80),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.25),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.4),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 42,
                                color: Colors.white,
                              ),
                            ),
                            Positioned(
                              bottom: 4,
                              right: 10,
                              child: Container(
                                height: 34,
                                width: 34,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.upload,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      /// CARD WITH DATA
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.pageBackground,
                          borderRadius: BorderRadius.circular(26),
                          border: Border.all(color: AppColors.gridLinesColor),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 24,
                              offset: Offset(0, 12),
                            ),
                          ],
                        ),
                        child: BlocBuilder<CustomerInfoCubit,
                            CustomerInfoState>(
                          builder: (context, state) {
                            final name = state is CustomerInfoSuccess
                                ? state.info.name
                                : '-';
                            final phone = state is CustomerInfoSuccess
                                ? state.info.mobile
                                : '-';

                            final cars = state is CustomerInfoSuccess
                                ? state.info.cars
                                : <CustomerCar>[];

                            final carLabel = cars.isNotEmpty
                                ? '${cars.first.device} ${cars.first.model}'
                                : '-';

                            return Column(
                              children: [
                                Text(
                                  'account.title'.tr(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                _item(
                                  icon: Icons.person_outline,
                                  value: name,
                                 
                                ),
                                _item(
                                  icon: Icons.directions_car,
                                  value: carLabel,
                                ),
                                _item(
                                  icon: Icons.phone_android,
                                  value: phone,
                                ),
                                _item(
                                  icon: Icons.lock_outline,
                                  value: '********',
                                  
                                ),

                                const SizedBox(height: 6),

                                _item(
                                  icon: Icons.logout,
                                  value: 'account.logout'.tr(),
                                  onTap: () {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      RoutesName.loginScreen,
                                      (route) => false,
                                    );
                                  },
                                ),

                                const SizedBox(height: 10),

                                Text(
                                  'account.delete_account'.tr(),
                                  style: const TextStyle(
                                    color: AppColors.red7,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
