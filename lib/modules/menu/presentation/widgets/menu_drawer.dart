import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;

import 'package:reservation_workshop/config/routes/routes_name.dart';
import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/modules/customer/presentation/cubits/customer_info_cubit/customer_info_cubit.dart';
import 'package:reservation_workshop/modules/customer/presentation/cubits/customer_info_cubit/customer_info_state.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SafeArea(
        child: Directionality(
          textDirection: context.locale.languageCode == 'ar' ? ui.TextDirection.rtl : ui.TextDirection.ltr,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 62,
                      height: 62,
                      decoration: const BoxDecoration(
                        color: AppColors.brandPrimarySoft,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person_outline, size: 34, color: Colors.black54),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BlocBuilder<CustomerInfoCubit, CustomerInfoState>(
                            builder: (context, state) {
                              final name = state is CustomerInfoSuccess ? state.info.name : 'User';
                              return Text(
                                name,
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                              );
                            },
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'menu.user'.tr(),
                            style: const TextStyle(color: Colors.black54, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _MenuItem(
                      title: 'menu.account'.tr(),
                      icon: Icons.person,
                      onTap: () => _go(context, RoutesName.menuAccountScreen),
                    ),
                     _MenuItem(
                      title: 'menu.add_booking'.tr(),
                      icon: Icons.add_circle_outline,
                      onTap: () {
                        Navigator.of(context).maybePop();
                        Navigator.of(context).pushNamed(RoutesName.mainScreen, arguments: 2);
                      },
                    ),
                    _MenuItem(
                      title: 'menu.estimator_request'.tr(),
                      icon: Icons.receipt_long_outlined,
                      onTap: () {
                        Navigator.of(context).maybePop();
                        Navigator.of(context).pushNamed(RoutesName.mainScreen, arguments: 0);
                      },
                    ),
                    _MenuItem(
                      title: 'menu.my_car'.tr(),
                      icon: Icons.directions_car_filled_outlined,
                      onTap: () => _go(context, RoutesName.chooseCarScreen),
                    ),
                    
                    
                    _MenuItem(
                      title: 'menu.about_vag'.tr(),
                      icon: Icons.location_on_outlined,
                      onTap: () => _go(context, RoutesName.menuAboutSkodaScreen),
                    ),
                    _MenuItem(
                      title: 'menu.rescue'.tr(),
                      icon: Icons.support_agent,
                      onTap: () => _go(context, RoutesName.menuRescueScreen),
                    ),
                    _MenuItem(
                      title: 'menu.contact'.tr(),
                      icon: Icons.headphones,
                      onTap: () => _go(context, RoutesName.menuContactScreen),
                    ),
                    _MenuItem(
                      title: 'menu.branches'.tr(),
                      icon: Icons.info_outline,
                      onTap: () => _go(context, RoutesName.menuAboutCenterScreen),
                    ),

                    _MenuItem(
                      title: 'menu.points'.tr(),
                      icon: Icons.workspace_premium_outlined,
                      onTap: () => _go(context, RoutesName.menuLoyaltyPointsScreen),
                    ),
                    
                    _MenuItem(
                      title: 'menu.change_language'.tr(),
                      icon: Icons.language,
                      onTap: () => _go(context, RoutesName.menuChangeLanguageScreen),
                    ),
                   
                    _MenuItem(
                      title: 'menu.logout'.tr(),
                      icon: Icons.logout,
                      onTap: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: Text('menu.logout_title'.tr()),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                  child: Text('menu.no'.tr()),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                  child: Text('menu.yes'.tr()),
                                ),
                              ],
                            );
                          },
                        );
                        if (confirmed == true) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            RoutesName.loginScreen,
                            (route) => false,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          _SocialCircle(icon: Icons.call),
                          _SocialCircle(icon: Icons.public),
                          _SocialCircle(icon: Icons.work),
                          _SocialCircle(icon: Icons.play_arrow),
                          _SocialCircle(icon: Icons.camera_alt),
                          _SocialCircle(icon: Icons.share),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Center(
                      child: Text(
                        'App Version 1.0.0',
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _go(BuildContext context, String route) {
    Navigator.of(context).maybePop();
    Navigator.of(context).pushNamed(route);
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({required this.title, required this.icon, required this.onTap});

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      trailing: Container(
        width: 34,
        height: 34,
        decoration: const BoxDecoration(
          color: AppColors.brandPrimarySoft,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: AppColors.brandPrimary),
      ),
    );
  }
}

class _SocialCircle extends StatelessWidget {
  const _SocialCircle({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: const BoxDecoration(
        color: AppColors.brandPrimarySoft,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 18, color: AppColors.brandPrimary),
    );
  }
}
