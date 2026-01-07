import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;
import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/config/routes/routes_name.dart';
import 'package:reservation_workshop/core/network/local/cache_helper.dart';
import 'package:reservation_workshop/core/utils/strings/prefkeys.dart';
import 'package:reservation_workshop/core/widgets/logo_image_widget.dart';
import 'package:reservation_workshop/modules/customer/domain/entities/customer_car.dart';
import 'package:reservation_workshop/modules/main/presentation/tabs/booking_tab_view.dart';
import 'package:reservation_workshop/modules/main/presentation/tabs/estimators_tab_view.dart';
import 'package:reservation_workshop/modules/main/presentation/tabs/maintenance_tab_view.dart';
import 'package:reservation_workshop/modules/menu/presentation/widgets/menu_drawer.dart';
import 'package:reservation_workshop/modules/notifications/presentation/cubit/maintenance_notifications_cubit.dart';
import 'package:reservation_workshop/modules/notifications/presentation/cubit/maintenance_notifications_state.dart';
import 'package:reservation_workshop/modules/branch/presentation/cubits/branch_cubit/branch_cubit.dart';
import 'package:reservation_workshop/modules/customer/presentation/cubits/customer_info_cubit/customer_info_cubit.dart';
import 'package:reservation_workshop/modules/customer/presentation/cubits/customer_info_cubit/customer_info_state.dart';
import 'package:reservation_workshop/modules/job_estimators/presentation/cubits/create_job_estimator_cubit/create_job_estimator_cubit.dart';
import 'package:reservation_workshop/modules/job_estimators/presentation/cubits/job_estimators_cubit.dart';
import 'package:reservation_workshop/modules/job_estimators/presentation/widgets/create_job_estimator_dialog.dart';
import 'package:reservation_workshop/modules/service/presentation/cubits/service_cubit/service_cubit.dart';

class RequestsTabsScreen extends StatefulWidget {
  const RequestsTabsScreen({super.key});

  @override
  State<RequestsTabsScreen> createState() => _RequestsTabsScreenState();
}

class _RequestsTabsScreenState extends State<RequestsTabsScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late TabController _tabController;
  bool _controllerInitialized = false;
  bool _notificationsLoaded = false;
  bool _customerLoaded = false;

  int? _selectedCarId;
  String? _selectedCarLogo;

  int _selectedBottomIndex = 3;

  String _carLabel(CustomerCar car) {
    final plate = (car.plateNumber ?? '').trim();
    return '${car.device} ${car.model} ${plate.isEmpty ? '' : plate}'.trim();
  }

  Future<void> _persistSelectedCar(CustomerCar car) async {
    await CacheHelper.saveData(key: PrefKeys.kSelectedCarId, value: car.id);
    await CacheHelper.saveData(key: PrefKeys.kSelectedCarLabel, value: _carLabel(car));
    await CacheHelper.saveData(key: PrefKeys.kSelectedCarLogo, value: (car.carLogo ?? '').trim());
    if (!mounted) return;
    setState(() => _selectedCarLogo = (car.carLogo ?? '').trim());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_controllerInitialized) {
      final int initialIndex = (ModalRoute.of(context)?.settings.arguments as int?) ?? 2;
      _tabController = TabController(length: 3, vsync: this, initialIndex: initialIndex.clamp(0, 2));
      _tabController.addListener(() {
        if (!mounted) return;
        setState(() {});
      });
      _controllerInitialized = true;
    }

    if (!_customerLoaded) {
      _customerLoaded = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<CustomerInfoCubit>().load();
      });
    }

    CacheHelper.getDataAsync<int>(key: PrefKeys.kSelectedCarId).then((carId) {
      if (!mounted) return;
      if (carId != _selectedCarId) {
        setState(() => _selectedCarId = carId);
      }
    });

    CacheHelper.getDataAsync<String>(key: PrefKeys.kSelectedCarLogo).then((logo) {
      if (!mounted) return;
      final cleaned = (logo ?? '').trim();
      if (cleaned != (_selectedCarLogo ?? '')) {
        setState(() => _selectedCarLogo = cleaned);
      }
    });

    if (!_notificationsLoaded) {
      _notificationsLoaded = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<MaintenanceNotificationsCubit>().refresh();
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _selectTab(int index) {
    if (_tabController.index == index) return;
    setState(() {
      _tabController.index = index;
    });
  }

  Widget _buildCenterButtonChild(CustomerCar? selectedCar, {String? cachedLogo}) {
    final logoFromApi = (selectedCar?.carLogo ?? '').trim();
    final cached = (cachedLogo ?? '').trim();
    final logo = logoFromApi.isNotEmpty ? logoFromApi : cached;
    if (logo.isEmpty) {
      return const Icon(
        Icons.handshake_outlined,
        color: Colors.white,
        size: 32,
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

  Future<void> _openCreateEstimatorDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final existingBranchCubit = context.read<BranchCubit>();
        final existingCustomerCubit = context.read<CustomerInfoCubit>();
        final existingServiceCubit = context.read<ServiceCubit>();
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: existingBranchCubit),
            BlocProvider.value(value: existingCustomerCubit),
            BlocProvider.value(value: existingServiceCubit),
            BlocProvider<CreateJobEstimatorCubit>(create: (_) => CreateJobEstimatorCubit()),
          ],
          child: CreateJobEstimatorDialog(
            onCreated: () {
              final s = existingCustomerCubit.state;
              if (s is CustomerInfoSuccess) {
                context.read<JobEstimatorsCubit>().load(customerId: s.info.id);
              }
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEstimatorsTab = _controllerInitialized && _tabController.index == 0;
    return Directionality(
      textDirection: context.locale.languageCode == 'ar' ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: BlocListener<CustomerInfoCubit, CustomerInfoState>(
        listener: (context, state) async {
          if (state is CustomerInfoSuccess) {
            final cars = state.info.cars;
            if (cars.isEmpty) return;

            final cachedId = _selectedCarId;
            final exists = cachedId != null && cars.any((c) => c.id == cachedId);
            if (!exists) {
              final first = cars.first;
              setState(() => _selectedCarId = first.id);
              await _persistSelectedCar(first);
            }
          }
        },
        child: Scaffold(
          key: _scaffoldKey,
          extendBody: true,
          drawer: const MenuDrawer(),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(112),
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.brandPrimarySoft,
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
                          const Expanded(
                            child: Center(
                              child: SizedBox(
                                height: 80
                              ,
                                child: LogoImageWidget(),
                              ),
                            ),
                          ),
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
                                color: Colors.black87,
                                size: 26,
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
                  final cachedLogo = (CacheHelper.getData<String>(key: PrefKeys.kSelectedCarLogo) ?? '').trim();
                  return Center(
                    child: _buildCenterButtonChild(
                      selectedCar.isNotEmpty ? selectedCar.first : null,
                      cachedLogo: cachedLogo,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: AppColors.brandPrimarySoft,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 70,
              child: Directionality(
                textDirection: ui.TextDirection.ltr,
                child: Row(
                  children: [
                    Expanded(
                      child: IconButton(
                        onPressed: () {
                          setState(() => _selectedBottomIndex = 4);
                          Navigator.pushNamed(context, RoutesName.menuAccountScreen);
                        },
                        icon: Icon(
                          Icons.person_outline,
                          color: _selectedBottomIndex == 4 ? AppColors.brandPrimary : Colors.black54,
                          size: 28,
                        ),
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        onPressed: () {
                          setState(() => _selectedBottomIndex = 3);
                          _selectTab(1);
                        },
                        icon: Icon(
                          Icons.build_outlined,
                          color: _selectedBottomIndex == 3 ? AppColors.brandPrimary : Colors.black54,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 80),
                    Expanded(
                      child: IconButton(
                        onPressed: () {
                          setState(() => _selectedBottomIndex = 2);
                          Navigator.pushNamed(context, RoutesName.informationBookingsScreen);
                        },
                        icon: Icon(
                          Icons.assignment_outlined,
                          color: _selectedBottomIndex == 2 ? AppColors.brandPrimary : Colors.black54,
                          size: 28,
                        ),
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        onPressed: () {
                          setState(() => _selectedBottomIndex = 0);
                          Navigator.pushNamed(context, RoutesName.notificationsScreen);
                        },
                        icon: BlocBuilder<MaintenanceNotificationsCubit, MaintenanceNotificationsState>(
                          builder: (context, state) {
                            final unread = state is MaintenanceNotificationsSuccess ? state.unreadCount : 0;
                            final iconColor = _selectedBottomIndex == 0 ? AppColors.brandPrimary : Colors.black54;

                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Icon(
                                  Icons.notifications_none,
                                  color: iconColor,
                                  size: 28,
                                ),
                                if (unread > 0)
                                  Positioned(
                                    right: -2,
                                    top: -2,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.brandPrimary,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        unread > 99 ? '99+' : unread.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
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
              gradient: LinearGradient(
                colors: [Color(0xFFF7FAFF), Color(0xFFF4F7FB)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.brandPrimarySoft2,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: TabBar(
                            controller: _tabController,
                            indicator: BoxDecoration(
                              color: AppColors.brandPrimary,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.black87,
                            dividerColor: Colors.transparent,
                            indicatorSize: TabBarIndicatorSize.tab,
                            labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                            tabs: [
                              Tab(text: 'tabs.estimator_request'.tr()),
                              Tab(text: 'tabs.maintenance'.tr()),
                              Tab(text: 'tabs.booking'.tr()),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: const [
                        EstimatorsTabView(),
                        MaintenanceTabView(),
                        BookingTabView(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
