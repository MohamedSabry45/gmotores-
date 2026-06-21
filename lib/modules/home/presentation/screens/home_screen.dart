import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';

import 'package:reservation_workshop/core/functions/localization_helper.dart';

import 'package:reservation_workshop/config/routes/routes_name.dart';
import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/core/network/local/cache_helper.dart';
import 'package:reservation_workshop/core/utils/strings/prefkeys.dart';
import 'package:reservation_workshop/core/widgets/logo_image_widget.dart';
import 'package:reservation_workshop/modules/customer/domain/entities/customer_car.dart';
import 'package:reservation_workshop/modules/customer/presentation/cubits/customer_info_cubit/customer_info_cubit.dart';
import 'package:reservation_workshop/modules/customer/presentation/cubits/customer_info_cubit/customer_info_state.dart';
import 'package:reservation_workshop/modules/home/domain/entities/blog_post.dart';
import 'package:reservation_workshop/modules/menu/presentation/widgets/menu_drawer.dart';
import 'package:reservation_workshop/modules/bookings/presentation/cubits/bookings_cubit/bookings_cubit.dart';

import '../cubit/blog_cubit.dart';
import '../cubit/blog_state.dart';
import '../widgets/home_top_banner.dart';
import '../widgets/home_estimators_section.dart';
import '../widgets/home_last_booking_section.dart';
import '../widgets/home_news_banner_section.dart';
import '../widgets/home_quick_actions_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedBottomIndex = 1;

  int? _selectedCarId;
  String? _selectedCarLabel;
  bool _isGuest = false;

  @override
  void initState() {
    super.initState();
    _loadGuestMode();
    _loadSelectedCar();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<BlogCubit>().loadFirst(localeCode: context.locale.languageCode);
      context.read<CustomerInfoCubit>().load();
      try {
        context.read<BookingsCubit>().load();
      } catch (_) {}
    });
  }

  Future<void> _loadGuestMode() async {
    final isGuest = await _isGuestMode();
    if (!mounted) return;
    setState(() {
      _isGuest = isGuest;
    });
  }

  Future<bool> _isGuestMode() async {
    return await CacheHelper.getDataAsync<bool>(key: PrefKeys.kIsGuestMode) ?? false;
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
                        t(ctx, 'home.my_cars', ar: 'سياراتي', en: 'My cars'),
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

  Widget _buildCenterButtonChild(CustomerCar? selectedCar) {
    final logo = (selectedCar?.carLogo ?? '').trim();
    if (logo.isEmpty) {
      return ClipOval(
        child: SizedBox.expand(
          child: Image.asset(
            'assets/images/bummy.jpg',
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return ClipOval(
      child: SizedBox.expand(
        child: Image.network(
          logo,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(
                Icons.directions_car_filled_outlined,
                color: Colors.white,
                size: 28,
              ),
            );
          },
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return const Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isLtr(context) ? ui.TextDirection.ltr : ui.TextDirection.rtl,
      child: Scaffold(
        key: _scaffoldKey,
        extendBody: true,
        drawer: const MenuDrawer(),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(112),
          child: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.appBackgroundGradient,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  children: [
                    Directionality(
                      textDirection: ui.TextDirection.ltr,
                      child: Row(
                        children: [
                          if (!isLtr(context))
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, RoutesName.menuAccountScreen);
                              },
                              borderRadius: BorderRadius.circular(22),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: const BoxDecoration(
                                  color: AppColors.brandSurface,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person_outline,
                                  color: Colors.black87,
                                  size: 24,
                                ),
                              ),
                            )
                          else
                            SizedBox(
                              width: 44,
                              height: 44,
                              child: IconButton(
                                onPressed: () {
                                  _scaffoldKey.currentState?.openDrawer();
                                },
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.menu,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                            ),
                          const Expanded(
                            child: Center(
                              child: SizedBox(
                                height: 80,
                                child: LogoImageWidget(),
                              ),
                            ),
                          ),
                          if (!isLtr(context))
                            SizedBox(
                              width: 44,
                              height: 44,
                              child: IconButton(
                                onPressed: () {
                                  _scaffoldKey.currentState?.openDrawer();
                                },
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.menu,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                            )
                          else
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, RoutesName.menuAccountScreen);
                              },
                              borderRadius: BorderRadius.circular(22),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: const BoxDecoration(
                                  color: AppColors.brandSurface,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person_outline,
                                  color: Colors.black87,
                                  size: 24,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            color: AppColors.brandPrimary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x40000000),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(36),
              onTap: () {
                setState(() => _selectedBottomIndex = 1);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RoutesName.homeScreen,
                  (route) => false,
                );
              },
              child: BlocBuilder<CustomerInfoCubit, CustomerInfoState>(
                builder: (context, state) {
                  final cars = state is CustomerInfoSuccess ? state.info.cars : const <CustomerCar>[];
                  final selectedCarId = _selectedCarId;
                  final selectedCar = selectedCarId != null ? cars.where((c) => c.id == selectedCarId).toList() : const <CustomerCar>[];
                  return Center(
                    child: _buildCenterButtonChild(selectedCar.isNotEmpty ? selectedCar.first : null),
                  );
                },
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          decoration: const BoxDecoration(
            gradient: AppColors.appBackgroundGradient,
            borderRadius: BorderRadius.all(Radius.circular(32)),
            boxShadow: [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 80,
              child: Directionality(
                textDirection: ui.TextDirection.ltr,
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          width: 60,
                          height: 60,
                          child: IconButton(
                            onPressed: () {
                              setState(() => _selectedBottomIndex = 4);
                              Navigator.pushNamed(context, RoutesName.menuAccountScreen);
                            },
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              Icons.person_outline,
                              color: _selectedBottomIndex == 4 ? Colors.white : Colors.white54,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          width: 60,
                          height: 60,
                          child: IconButton(
                            onPressed: () {
                              setState(() => _selectedBottomIndex = 3);
                              Navigator.pushNamed(context, RoutesName.mainScreen, arguments: 1);
                            },
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              Icons.build_outlined,
                              color: _selectedBottomIndex == 3 ? Colors.white : Colors.white54,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 80),
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          width: 60,
                          height: 60,
                          child: IconButton(
                            onPressed: () {
                              setState(() => _selectedBottomIndex = 2);
                              Navigator.pushNamed(context, RoutesName.informationBookingsScreen);
                            },
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              Icons.assignment_outlined,
                              color: _selectedBottomIndex == 2 ? Colors.white : Colors.white54,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          width: 60,
                          height: 60,
                          child: IconButton(
                            onPressed: () {
                              setState(() => _selectedBottomIndex = 0);
                              Navigator.pushNamed(context, RoutesName.notificationsScreen);
                            },
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              Icons.notifications_none,
                              color: _selectedBottomIndex == 0 ? Colors.white : Colors.white54,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.appBackgroundGradient,
          ),
          child: SafeArea(
            top: false,
            bottom: false,
            child: BlocBuilder<CustomerInfoCubit, CustomerInfoState>(
              builder: (context, customerState) {
                final customerName = customerState is CustomerInfoSuccess ? customerState.info.name.trim() : '';
                final isGuestUser = _isGuest || customerName.isEmpty;
                final cars = customerState is CustomerInfoSuccess ? customerState.info.cars : const <CustomerCar>[];
                final cachedLabel = (_selectedCarLabel ?? '').trim();
                final selectedFromList = _selectedCarId != null ? cars.where((c) => c.id == _selectedCarId).toList() : const <CustomerCar>[];
                final selectedCarLabel = selectedFromList.isNotEmpty ? _carLabel(selectedFromList.first) : cachedLabel;

                final greetingText = isGuestUser
                    ? t(context, 'home.greeting_guest', ar: 'مرحبا، ضيف', en: 'Hello, Guest')
                    : t(
                        context,
                        'home.greeting_named',
                        ar: 'مرحبا، {}',
                        en: 'Hello, {}',
                        args: [customerName],
                      );

                return BlocBuilder<BlogCubit, BlogState>(
                  builder: (context, blogState) {
                    if (blogState is BlogLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (blogState is BlogError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            blogState.message,
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

                    final posts = blogState is BlogSuccess ? blogState.posts : const <BlogPost>[];

                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 520),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          greetingText,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        InkWell(
                                          onTap: () => _openCarPicker(cars: cars),
                                          borderRadius: BorderRadius.circular(12),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(Icons.directions_car_filled_outlined, size: 16, color: Colors.white70),
                                                const SizedBox(width: 6),
                                                Text(
                                                  selectedCarLabel.isEmpty
                                                      ? t(context, 'home.select_car', ar: 'اختر السيارة', en: 'Select car')
                                                      : selectedCarLabel,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white70,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.white70),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const HomeTopBanner(),
                              const SizedBox(height: 16),
                              HomeQuickActionsSection(
                                onBookNow: () {
                                  Navigator.pushNamed(context, RoutesName.mainScreen, arguments: 2);
                                },
                                onMaintenance: () {
                                  Navigator.pushNamed(context, RoutesName.menuRescueScreen);
                                },
                              ),
                              const SizedBox(height: 14),
                              HomeEstimatorsSection(
                                onRequestEstimatorNow: () {
                                  Navigator.pushNamed(context, RoutesName.mainScreen, arguments: 0);
                                },
                              ),
                              const SizedBox(height: 14),
                              const HomeLastBookingSection(),
                              const SizedBox(height: 18),
                              HomeNewsBannerSection(posts: posts),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
