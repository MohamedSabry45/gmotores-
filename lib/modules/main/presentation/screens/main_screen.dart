import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/config/routes/routes_name.dart';
import 'package:reservation_workshop/core/components/toasters.dart';
import 'package:reservation_workshop/core/network/local/cache_helper.dart';
import 'package:reservation_workshop/core/utils/strings/prefkeys.dart';
import 'package:reservation_workshop/core/widgets/logo_image_widget.dart';
import 'package:reservation_workshop/modules/branch/domain/entities/branch.dart';
import 'package:reservation_workshop/modules/branch/presentation/cubits/branch_cubit/branch_cubit.dart';
import 'package:reservation_workshop/modules/branch/presentation/cubits/branch_cubit/branch_state.dart';
import 'package:reservation_workshop/modules/customer/domain/entities/customer_car.dart';
import 'package:reservation_workshop/modules/customer/presentation/cubits/customer_info_cubit/customer_info_cubit.dart';
import 'package:reservation_workshop/modules/customer/presentation/cubits/customer_info_cubit/customer_info_state.dart';
import 'package:reservation_workshop/modules/service/domain/entities/service.dart';
import 'package:reservation_workshop/modules/service/presentation/cubits/service_cubit/service_cubit.dart';
import 'package:reservation_workshop/modules/service/presentation/cubits/service_cubit/service_state.dart';
import 'package:reservation_workshop/modules/main/presentation/widgets/booking_dropdown_field.dart';
import 'package:reservation_workshop/modules/main/presentation/widgets/date_time_field.dart';
import 'package:reservation_workshop/modules/main/presentation/widgets/notes_field.dart';
import 'package:reservation_workshop/modules/main/presentation/widgets/submit_booking_button.dart';
import 'package:reservation_workshop/modules/main/presentation/screens/booking_details_args.dart';
import 'package:reservation_workshop/modules/main/presentation/widgets/notification_card.dart';
import 'package:reservation_workshop/core/widgets/app_card.dart';
import 'package:reservation_workshop/config/style/app_spacing.dart';
import 'package:reservation_workshop/modules/menu/presentation/widgets/menu_drawer.dart';
import 'package:reservation_workshop/modules/notifications/presentation/cubit/maintenance_notifications_cubit.dart';
import 'package:reservation_workshop/modules/notifications/presentation/cubit/maintenance_notifications_state.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int? _selectedBranchId;
  int? _selectedCarId;
  int? _selectedServiceId;
  DateTime _selectedDateTime = DateTime.now();
  final TextEditingController _notesController = TextEditingController();

  int _selectedBottomIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadSelectedCar();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<CustomerInfoCubit>().load();
      context.read<BranchCubit>().load();
      context.read<MaintenanceNotificationsCubit>().refresh();
    });
  }

  Future<void> _loadSelectedCar() async {
    final carId = await CacheHelper.getDataAsync<int>(key: PrefKeys.kSelectedCarId);
    if (!mounted) return;
    setState(() => _selectedCarId = carId);
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
      child: ColoredBox(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Image.network(
            logo,
            width: 32,
            height: 32,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.directions_car_filled_outlined,
                color: AppColors.brandPrimary,
                size: 28,
              );
            },
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.brandPrimary),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: _selectedDateTime,
    );
    if (date == null) return;

    if (!mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  String _formatDateTime(DateTime dt) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(dt.month)}/${two(dt.day)}/${dt.year} ${two(dt.hour)}:${two(dt.minute)}';
  }

  String _formatBookingStart(DateTime dt) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${dt.year}-${two(dt.month)}-${two(dt.day)}T${two(dt.hour)}:${two(dt.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MultiBlocListener(
      listeners: [
        BlocListener<CustomerInfoCubit, CustomerInfoState>(
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
        ),
        BlocListener<BranchCubit, BranchState>(
          listener: (context, state) {
            if (state is BranchError) {
              Toasters.show(state.message);
            }
          },
        ),
        BlocListener<ServiceCubit, ServiceState>(
          listener: (context, state) {
            if (state is ServiceError) {
              Toasters.show(state.message);
            }
          },
        ),
      ],
      child: Scaffold(
        key: _scaffoldKey,
        extendBody: true,
        drawer: const MenuDrawer(),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                        decoration: BoxDecoration(
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
                          height: 40,
                          child: LogoImageWidget(),
                        ),
                      ),
                    ),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
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
          decoration: const BoxDecoration(
            gradient: AppColors.appBackgroundGradient,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: IconButton(
                      onPressed: () {
                        setState(() => _selectedBottomIndex = 0);
                        Navigator.pushNamed(context, RoutesName.notificationsScreen);
                      },
                      icon: BlocBuilder<MaintenanceNotificationsCubit, MaintenanceNotificationsState>(
                        builder: (context, state) {
                          final unread = state is MaintenanceNotificationsSuccess ? state.unreadCount : 0;
                          final iconColor = _selectedBottomIndex == 0 ? Colors.white : Colors.white54;

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
                  Expanded(
                    child: IconButton(
                      onPressed: () {
                        setState(() => _selectedBottomIndex = 2);
                        Navigator.pushNamed(context, RoutesName.jobOrdersScreen);
                      },
                      icon: Icon(
                        Icons.directions_car_filled_outlined,
                        color: _selectedBottomIndex == 2 ? Colors.white : Colors.white54,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 80),
                  Expanded(
                    child: IconButton(
                      onPressed: () {
                        setState(() => _selectedBottomIndex = 3);
                        Navigator.pushNamed(context, RoutesName.jobEstimatorsScreen);
                      },
                      icon: Icon(
                        Icons.build_outlined,
                        color: _selectedBottomIndex == 3 ? Colors.white : Colors.white54,
                        size: 28,
                      ),
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      onPressed: () {
                        setState(() => _selectedBottomIndex = 4);
                        Navigator.pushNamed(context, RoutesName.menuAccountScreen);
                      },
                      icon: Icon(
                        Icons.person_outline,
                        color: _selectedBottomIndex == 4 ? Colors.white : Colors.white54,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.appBackgroundGradient,
          ),
          child: SafeArea(
            child: BlocBuilder<CustomerInfoCubit, CustomerInfoState>(
              builder: (context, state) {
                final customerName = state is CustomerInfoSuccess ? state.info.name : '';
                final cars = state is CustomerInfoSuccess ? state.info.cars : const <CustomerCar>[];

                return Column(
                  children: [
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return CustomScrollView(
                            slivers: [
                              SliverPadding(
                                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                                sliver: SliverToBoxAdapter(
                                  child: Center(
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(maxWidth: 420),
                                      child: AppCard(
                                        padding: const EdgeInsets.all(16),
                                        borderRadius: 18,
                                        backgroundColor: AppColors.brandSurface,
                                        borderColor: AppColors.brandOutline,
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0x14000000),
                                            blurRadius: 26,
                                            offset: Offset(0, 14),
                                          ),
                                        ],
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Text(
                                              customerName.trim().isEmpty ? 'مرحبا' : 'مرحبا، $customerName',
                                              style: textTheme.titleSmall?.copyWith(
                                                fontWeight: FontWeight.w800,
                                                color: AppColors.brandDark,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'احجز موعدك بسهولة',
                                              style: textTheme.bodySmall?.copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.grey7,
                                              ),
                                            ),
                                            const SizedBox(height: AppSpacing.lg),
                                            BookingDropdownField<int>(
                                              label: 'السيارة',
                                              value: _selectedCarId,
                                              items: cars
                                                  .map(
                                                    (c) => DropdownMenuItem<int>(
                                                      value: c.id,
                                                      child: Text(_carLabel(c)),
                                                    ),
                                                  )
                                                  .toList(),
                                              onChanged: (id) async {
                                                if (id == null) return;
                                                final car = cars.where((e) => e.id == id).toList();
                                                if (car.isEmpty) return;

                                                setState(() => _selectedCarId = id);
                                                await _persistSelectedCar(car.first);
                                              },
                                            ),
                                            const SizedBox(height: AppSpacing.lg),
                                            BlocBuilder<BranchCubit, BranchState>(
                                              builder: (context, branchState) {
                                                final branches = branchState is BranchSuccess ? branchState.branches : const <Branch>[];

                                                return BookingDropdownField<int>(
                                                  label: 'اختر الفرع',
                                                  isRequired: true,
                                                  value: _selectedBranchId,
                                                  items: branches
                                                      .map(
                                                        (b) => DropdownMenuItem<int>(
                                                          value: b.id,
                                                          child: Text(b.name),
                                                        ),
                                                      )
                                                      .toList(),
                                                  onChanged: (id) {
                                                    setState(() {
                                                      _selectedBranchId = id;
                                                      _selectedServiceId = null;
                                                    });

                                                    if (id == null) {
                                                      context.read<ServiceCubit>().clear();
                                                      return;
                                                    }
                                                    context.read<ServiceCubit>().load(locationId: id);
                                                  },
                                                );
                                              },
                                            ),
                                            const SizedBox(height: AppSpacing.lg),
                                            if (_selectedBranchId != null)
                                              BlocBuilder<ServiceCubit, ServiceState>(
                                                builder: (context, serviceState) {
                                                  final services = serviceState is ServiceSuccess ? serviceState.services : const <Service>[];

                                                  return Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'اختر الخدمة',
                                                            style: textTheme.bodySmall?.copyWith(
                                                              fontWeight: FontWeight.w600,
                                                              color: AppColors.brandDark,
                                                            ),
                                                          ),
                                                          const SizedBox(width: 4),
                                                          const Text(
                                                            '*',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w700,
                                                              color: AppColors.brandPrimary,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: AppSpacing.md),
                                                      GridView.count(
                                                        crossAxisCount: 2,
                                                        mainAxisSpacing: 10,
                                                        crossAxisSpacing: 10,
                                                        childAspectRatio: 2.55,
                                                        shrinkWrap: true,
                                                        physics: const NeverScrollableScrollPhysics(),
                                                        children: services
                                                            .map(
                                                              (s) => _ServiceCard(
                                                                title: s.name,
                                                                selected: _selectedServiceId == s.id,
                                                                onTap: () => setState(() => _selectedServiceId = s.id),
                                                              ),
                                                            )
                                                            .toList(),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            const SizedBox(height: AppSpacing.lg),
                                            DateTimeField(
                                              label: 'اختر التاريخ والوقت',
                                              valueText: _formatDateTime(_selectedDateTime),
                                              onPick: _pickDateTime,
                                            ),
                                            const SizedBox(height: AppSpacing.lg),
                                            NotesField(
                                              hintText: 'اوصف المشكلة...',
                                              controller: _notesController,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SliverFillRemaining(
                                hasScrollBody: false,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                  child: Center(
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(maxWidth: 420),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          const SizedBox(height: AppSpacing.lg),
                                          SubmitBookingButton(
                                            onPressed: () {
                                              final carId = _selectedCarId;
                                              final branchId = _selectedBranchId;
                                              final serviceId = _selectedServiceId;

                                              if (carId == null) {
                                                Toasters.show('اختر السيارة');
                                                return;
                                              }
                                              if (branchId == null) {
                                                Toasters.show('اختر الفرع');
                                                return;
                                              }
                                              if (serviceId == null) {
                                                Toasters.show('اختر الخدمة');
                                                return;
                                              }

                                              final customerState = context.read<CustomerInfoCubit>().state;
                                              final customerName = customerState is CustomerInfoSuccess ? customerState.info.name : '';
                                              final customerPhone = customerState is CustomerInfoSuccess ? customerState.info.mobile : '';
                                              final cars = customerState is CustomerInfoSuccess ? customerState.info.cars : const <CustomerCar>[];
                                              final selectedCar = cars.where((c) => c.id == carId).toList();

                                              final branchState = context.read<BranchCubit>().state;
                                              final branches = branchState is BranchSuccess ? branchState.branches : const <Branch>[];
                                              final selectedBranch = branches.where((b) => b.id == branchId).toList();

                                              final serviceState = context.read<ServiceCubit>().state;
                                              final services = serviceState is ServiceSuccess ? serviceState.services : const <Service>[];
                                              final selectedService = services.where((s) => s.id == serviceId).toList();

                                              final note = _notesController.text.trim();
                                              final bookingStart = _formatBookingStart(_selectedDateTime);

                                              final model = NotificationCardModel(
                                                workOrderNo: '-',
                                                customer: '',
                                                car: selectedCar.isNotEmpty ? selectedCar.first.device : '-',
                                                carModel: selectedCar.isNotEmpty ? selectedCar.first.model : '-',
                                                plate: selectedCar.isNotEmpty
                                                    ? ((selectedCar.first.plateNumber ?? '').trim().isEmpty ? '-' : selectedCar.first.plateNumber!.trim())
                                                    : '-',
                                                status: '-',
                                                dateTime: bookingStart,
                                                service: selectedService.isNotEmpty ? selectedService.first.name : '-',
                                                branch: selectedBranch.isNotEmpty ? selectedBranch.first.name : '-',
                                                area: note.isEmpty ? '-' : note,
                                                name: customerName,
                                                phone: customerPhone,
                                              );

                                              final args = BookingDetailsArgs(
                                                model: model,
                                                bookingStart: bookingStart,
                                                locationId: branchId,
                                                serviceId: serviceId,
                                                deviceId: carId,
                                                bookingNote: note,
                                              );

                                              Navigator.pushNamed(
                                                context,
                                                RoutesName.bookingDetailsScreen,
                                                arguments: args,
                                              );
                                            },
                                          ),
                                          const SizedBox(height: AppSpacing.sm),
                                          const Text(
                                            'يمكنك تعديل التفاصيل قبل التأكيد',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.grey7,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.brandPrimary : AppColors.brandSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.brandPrimary : AppColors.brandOutline,
          ),
          boxShadow: selected
              ? const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                ]
              : const [],
        ),
        child: Center(
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(
              height: 1.2,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : AppColors.brandDark,
            ),
          ),
        ),
      ),
    );
  }
}