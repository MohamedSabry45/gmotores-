import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:reservation_workshop/core/components/toasters.dart';
import 'dart:ui' as ui;
import 'package:url_launcher/url_launcher.dart';

import 'package:reservation_workshop/modules/menu/data/models/business_location_model.dart';
import 'package:reservation_workshop/modules/menu/presentation/cubits/business_location_cubit/business_location_cubit.dart';
import 'package:reservation_workshop/modules/menu/presentation/cubits/business_location_cubit/business_location_state.dart';

import 'package:reservation_workshop/constants/app_constants.dart';
import 'package:reservation_workshop/config/routes/routes_name.dart';
import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/core/network/local/cache_helper.dart';
import 'package:reservation_workshop/core/utils/strings/prefkeys.dart';
import 'package:reservation_workshop/modules/customer/domain/entities/customer_car.dart';
import 'package:reservation_workshop/modules/customer/presentation/cubits/customer_info_cubit/customer_info_cubit.dart';
import 'package:reservation_workshop/modules/customer/presentation/cubits/customer_info_cubit/customer_info_state.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({super.key});

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  int? _selectedCarId;
  String? _selectedCarLabel;
  bool _isGuest = false;

  @override
  void initState() {
    super.initState();
    _loadGuestMode();
    _loadSelectedCar();
    BusinessLocationCubit.get(context).fetchBusinessLocation();
  }

  Future<void> _loadGuestMode() async {
    final isGuest = await CacheHelper.getDataAsync<bool>(key: PrefKeys.kIsGuestMode) ?? false;
    if (!mounted) return;
    setState(() {
      _isGuest = isGuest;
    });
  }

  Future<void> _loadSelectedCar() async {
    final carId = await CacheHelper.getDataAsync<int>(key: PrefKeys.kSelectedCarId);
    final carLabel = await CacheHelper.getDataAsync<String>(key: PrefKeys.kSelectedCarLabel);
    if (!mounted) return;
    setState(() {
      _selectedCarId = carId;
      _selectedCarLabel = carLabel;
    });
  }

  Future<void> _guardGuest(VoidCallback action) async {
    if (_isGuest) {
      if (!mounted) return;
      Navigator.of(context).maybePop();
      Navigator.of(context).pushNamedAndRemoveUntil(
        RoutesName.enterMobileScreen,
        (route) => false,
      );
      return;
    }
    action();
  }

  String _carLabel(CustomerCar car) {
    final plate = (car.plateNumber ?? '').trim();
    return '${car.device} ${car.model} ${plate.isEmpty ? '' : plate}'.trim();
  }

  Future<void> _persistSelectedCar(CustomerCar car) async {
    await CacheHelper.saveData(key: PrefKeys.kSelectedCarId, value: car.id);
    await CacheHelper.saveData(key: PrefKeys.kSelectedCarLabel, value: _carLabel(car));
    await CacheHelper.saveData(key: PrefKeys.kSelectedCarLogo, value: (car.carLogo ?? '').trim());
  }

  Future<void> _openCarPicker({required List<CustomerCar> cars}) async {
    if (cars.isEmpty) return;

    final picked = await showModalBottomSheet<CustomerCar>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'cars.title'.tr(),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: cars.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final car = cars[index];
                      final isSelected = _selectedCarId != null ? car.id == _selectedCarId : false;
                      return InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => Navigator.pop(ctx, car),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.brandPrimarySoft2 : const Color(0xFFF7F7F9),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: AppColors.brandPrimarySoft,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(Icons.directions_car_filled_outlined, color: AppColors.brandPrimary),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${car.device} ${car.model}'.trim(),
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      (car.plateNumber ?? '').trim().isEmpty ? car.carType : (car.plateNumber ?? '').trim(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.grey7,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                const Icon(Icons.check_circle, color: AppColors.brandPrimary)
                              else
                                const Icon(Icons.chevron_left, color: AppColors.grey7),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );

    if (picked == null) return;
    await _persistSelectedCar(picked);
    if (!mounted) return;
    setState(() {
      _selectedCarId = picked.id;
      _selectedCarLabel = _carLabel(picked);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isRtl = context.locale.languageCode == 'ar';
    return SizedBox(
      width: width * 0.92,
      child: Drawer(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: SafeArea(
          child: Directionality(
            textDirection: isRtl ? ui.TextDirection.rtl : ui.TextDirection.ltr,
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.appBackgroundGradient,
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 90,
                    bottom: -30,
                    left: isRtl ? 0 : null,
                    right: isRtl ? null : 0,
                    child: IgnorePointer(
                      child: Opacity(
                        opacity: 0.95,
                        child: ClipRect(
                          child: Align(
                            alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
                            widthFactor: 0.5,
                            child: Image(
                              image: const AssetImage('assets/images/car.png'),
                              width: 320,
                              fit: BoxFit.cover,
                              alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 62,
                              height: 62,
                              decoration: const BoxDecoration(
                                color: AppColors.itemsBackground,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.person_outline, size: 34, color: Colors.white70),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: BlocBuilder<CustomerInfoCubit, CustomerInfoState>(
                                          builder: (context, state) {
                                            String name;
                                            if (_isGuest) {
                                              name = 'common.guest'.tr();
                                            } else if (state is CustomerInfoSuccess) {
                                              name = state.info.name.trim();
                                              if (name.isEmpty) name = 'menu.user'.tr();
                                            } else {
                                              name = 'menu.user'.tr();
                                            }
                                            return Text(
                                              name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                  ),
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      InkWell(
                                        onTap: () {
                                          final current = context.locale.languageCode;
                                          context.setLocale(Locale(current == 'ar' ? 'en' : 'ar'));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                          child: Text(
                                            isRtl ? 'En' : 'العربية',
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  BlocBuilder<CustomerInfoCubit, CustomerInfoState>(
                                    builder: (context, state) {
                                      final cars = state is CustomerInfoSuccess ? state.info.cars : const <CustomerCar>[];
                                      final selectedFromList = _selectedCarId != null
                                          ? cars.where((c) => c.id == _selectedCarId).toList()
                                          : const <CustomerCar>[];
                                      final cachedLabel = (_selectedCarLabel ?? '').trim();
                                      final selectedCarLabel =
                                          selectedFromList.isNotEmpty ? _carLabel(selectedFromList.first) : cachedLabel;

                                      return InkWell(
                                        onTap: () => _openCarPicker(cars: cars),
                                        borderRadius: BorderRadius.circular(12),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(Icons.directions_car_filled_outlined, size: 16, color: Colors.white70),
                                              const SizedBox(width: 6),
                                              Flexible(
                                                child: Text(
                                                  selectedCarLabel.isEmpty ? 'home.select_car'.tr() : selectedCarLabel,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                        color: Colors.white54,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.white70),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: Colors.white10),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),
                          children: [
                             _MenuItem(
                              title: 'menu.about_vag'.tr(),
                              icon: Icons.location_on_outlined,
                              onTap: () => _go(context, RoutesName.menuAboutSkodaScreen),
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
                              title: 'menu.maintenance'.tr(),
                              icon: Icons.build_outlined,
                              onTap: () {
                                Navigator.of(context).maybePop();
                                Navigator.of(context).pushNamed(RoutesName.mainScreen, arguments: 1);
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
                              title: 'menu.invoices'.tr(),
                              icon: Icons.receipt_outlined,
                              onTap: () {
                                Navigator.of(context).maybePop();
                                Navigator.of(context).pushNamed(RoutesName.mainScreen, arguments: 3);
                              },
                            ),
                            const SizedBox(height: 8),
                           
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
                              title: 'menu.points'.tr(),
                              icon: Icons.workspace_premium_outlined,
                              onTap: () => _guardGuest(() => _go(context, RoutesName.menuLoyaltyPointsScreen)),
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
                                  AppConstants.token = null;
                                  await CacheHelper.removeData(key: PrefKeys.kAccessToken);
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    RoutesName.enterMobileScreen,
                                    (route) => false,
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 12),
                            BlocBuilder<BusinessLocationCubit, BusinessLocationState>(
                              builder: (context, state) {
                                BusinessLocation? location;
                                bool isLoading = state is BusinessLocationLoading;

                                if (state is BusinessLocationSuccess) {
                                  location = state.location;
                                }

                                final socialItems = _buildSocialItems(location, isLoading: isLoading);

                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 2),
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    alignment: WrapAlignment.center,
                                    children: socialItems.isNotEmpty
                                        ? socialItems
                                        : [
                                            // Default icons when no data - show message when tapped
                                            _SocialCircle(
                                              icon: Icons.call,
                                              isLoading: isLoading,
                                              onTap: isLoading ? null : () => Toasters.show('contact.phone_not_available'.tr()),
                                            ),
                                            _SocialCircle(
                                              icon: Icons.facebook,
                                              isLoading: isLoading,
                                              onTap: isLoading ? null : () => Toasters.show('common.cannot_open'.tr()),
                                            ),
                                            _SocialCircle(
                                              icon: Icons.camera_alt,
                                              isLoading: isLoading,
                                              onTap: isLoading ? null : () => Toasters.show('common.cannot_open'.tr()),
                                            ),
                                            _SocialCircle(
                                              icon: Icons.public,
                                              isLoading: isLoading,
                                              onTap: isLoading ? null : () => Toasters.show('common.cannot_open'.tr()),
                                            ),
                                            _SocialCircle(
                                              icon: Icons.share,
                                              isLoading: isLoading,
                                              onTap: isLoading ? null : () => Toasters.show('common.cannot_open'.tr()),
                                            ),
                                          ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 18),
                            const Center(
                              child: Text(
                                'App Version 1.0.0',
                                style: TextStyle(color: Colors.white38, fontSize: 12),
                              ),
                            ),
                            const SizedBox(height: 6),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static void _go(BuildContext context, String route) {
    Navigator.of(context).maybePop();
    Navigator.of(context).pushNamed(route);
  }

  List<Widget> _buildSocialItems(BusinessLocation? location, {bool isLoading = false}) {
    // If no location data at all, return empty to use default icons
    if (location == null) {
      return [];
    }

    final items = <Widget>[];

    // Phone
    final hasMobile = location.mobile != null && location.mobile!.isNotEmpty;
    items.add(_SocialCircle(
      icon: Icons.call,
      onTap: hasMobile ? () => _callPhone(location.mobile!) : null,
      isLoading: isLoading && !hasMobile,
    ));

    // Facebook
    final hasFacebook = location.customField2 != null && location.customField2!.isNotEmpty;
    items.add(_SocialCircle(
      icon: Icons.facebook,
      onTap: hasFacebook ? () => _launchUrl(location.customField2!) : null,
      isLoading: isLoading && !hasFacebook,
    ));

    // Instagram
    final hasInstagram = location.customField1 != null && location.customField1!.isNotEmpty;
    items.add(_SocialCircle(
      icon: Icons.camera_alt,
      onTap: hasInstagram ? () => _launchUrl(location.customField1!) : null,
      isLoading: isLoading && !hasInstagram,
    ));

    // Website
    final hasWebsite = location.website != null && location.website!.isNotEmpty;
    items.add(_SocialCircle(
      icon: Icons.public,
      onTap: hasWebsite ? () => _launchUrl(location.website!) : null,
      isLoading: isLoading && !hasWebsite,
    ));

    // Share
    final hasShare = location.customField3 != null && location.customField3!.isNotEmpty;
    items.add(_SocialCircle(
      icon: Icons.share,
      onTap: hasShare ? () => _launchUrl(location.customField3!) : null,
      isLoading: isLoading && !hasShare,
    ));

    return items;
  }

  Future<void> _callPhone(String phone) async {
    final cleanedPhone = phone
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .replaceAll('(', '')
        .replaceAll(')', '');

    final Uri uri = Uri(
      scheme: 'tel',
      path: cleanedPhone,
    );

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.platformDefault,
      );

      if (!launched && mounted) {
        Toasters.show('common.cannot_open'.tr());
      }
    } catch (e) {
      debugPrint('CALL ERROR: $e');
      if (mounted) {
        Toasters.show('common.cannot_open'.tr());
      }
    }
  }

  Future<void> _launchUrl(String url) async {
    final raw = url.trim();
    debugPrint('🚀 _launchUrl called with: "$raw"');
    if (raw.isEmpty) {
      debugPrint('❌ URL is empty');
      return;
    }

    Uri uri;
    try {
      uri = Uri.parse(raw);
    } catch (e) {
      debugPrint('❌ Failed to parse URL: $e');
      if (mounted) Toasters.show('common.cannot_open'.tr());
      return;
    }

    // Normalize URLs - add https if no scheme
    if (uri.scheme.isEmpty && !raw.startsWith('tel:')) {
      uri = Uri.parse('https://$raw');
      debugPrint('🌐 Converted to HTTPS URI: $uri');
    }

    // Launch URLs (not phone numbers)
    bool launched = false;
    try {
      debugPrint('🚀 Launching URL: $uri');
      launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        // Fallback to platformDefault
        debugPrint('🔄 Trying fallback with platformDefault');
        launched = await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      debugPrint('❌ Exception during launch: $e');
      launched = false;
    }

    debugPrint('✅ Launch result: $launched');
    if (!launched && mounted) {
      Toasters.show('common.cannot_open'.tr());
    }
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({required this.title, required this.icon, required this.onTap});

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: AppColors.itemsBackground,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 22, color: AppColors.brandPrimary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
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

class _SocialCircle extends StatelessWidget {
  const _SocialCircle({required this.icon, this.onTap, this.isLoading = false});

  final IconData icon;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(19),
      child: Container(
        width: 38,
        height: 38,
        decoration: const BoxDecoration(
          color: AppColors.itemsBackground,
          shape: BoxShape.circle,
        ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white38,
                  ),
                ),
              )
            : Icon(
                icon,
                size: 18,
                color: onTap != null ? Colors.white54 : Colors.white24,
              ),
      ),
    );
  }
}
