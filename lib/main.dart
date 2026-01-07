import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;

import 'package:reservation_workshop/config/routes/routes_name.dart';
import 'package:reservation_workshop/config/style/app_theme.dart';
import 'package:reservation_workshop/core/components/toasters.dart';
import 'package:reservation_workshop/core/network/local/cache_helper.dart';
import 'package:reservation_workshop/core/utils/strings/prefkeys.dart';
import 'package:reservation_workshop/modules/auth/presentation/cubits/auth_cubit/auth_cubit.dart';
import 'package:reservation_workshop/modules/auth/presentation/cubits/auth_otp_cubit/auth_otp_cubit.dart';
import 'package:reservation_workshop/modules/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:reservation_workshop/modules/auth/presentation/cubits/register_cubit/register_cubit.dart';
import 'package:reservation_workshop/modules/auth/presentation/cubits/shift_cubit/shift_cubit.dart';
import 'package:reservation_workshop/modules/auth/presentation/screens/complete_profile_screen.dart';
import 'package:reservation_workshop/modules/auth/presentation/screens/enter_mobile_screen.dart';
import 'package:reservation_workshop/modules/auth/presentation/screens/login_screen.dart';
import 'package:reservation_workshop/modules/auth/presentation/screens/otp_verification_screen.dart';
import 'package:reservation_workshop/modules/auth/presentation/screens/register_screen.dart';
import 'package:reservation_workshop/modules/branch/presentation/cubits/branch_cubit/branch_cubit.dart';
import 'package:reservation_workshop/modules/customer/presentation/cubits/customer_info_cubit/customer_info_cubit.dart';
import 'package:reservation_workshop/modules/main/presentation/cubits/app_cubit/app_cubit.dart';
import 'package:reservation_workshop/modules/main/presentation/screens/job_orders_screen.dart';
import 'package:reservation_workshop/modules/main/presentation/screens/booking_details_screen.dart';
import 'package:reservation_workshop/modules/main/presentation/screens/information%20booking%20_screen.dart';
import 'package:reservation_workshop/modules/main/presentation/screens/requests_tabs_screen.dart';
import 'package:reservation_workshop/modules/menu/presentation/screens/menu_rescue_screen.dart';
import 'package:reservation_workshop/modules/startup/presentation/startup_decider_screen.dart';
import 'package:reservation_workshop/modules/startup/presentation/fullscreen_splash_screen.dart';
import 'package:reservation_workshop/modules/customer/presentation/screens/choose_car_screen.dart';
import 'package:reservation_workshop/modules/customer/presentation/screens/add_car_screen.dart';
import 'package:reservation_workshop/modules/service/presentation/cubits/service_cubit/service_cubit.dart';
import 'package:reservation_workshop/modules/job_orders/presentation/cubits/job_orders_cubit/job_orders_cubit.dart';
import 'package:reservation_workshop/modules/job_order_details/presentation/cubits/job_order_details_cubit/job_order_details_cubit.dart';
import 'package:reservation_workshop/modules/job_order_details/presentation/screens/job_order_details_screen.dart';
import 'package:reservation_workshop/modules/job_estimators/presentation/screens/job_estimator_details_screen.dart';
import 'package:reservation_workshop/modules/bookings/presentation/cubits/add_booking_cubit/add_booking_cubit.dart';
import 'package:reservation_workshop/modules/bookings/presentation/cubits/bookings_cubit/bookings_cubit.dart';
import 'package:reservation_workshop/modules/job_estimators/presentation/cubits/job_estimators_cubit.dart';
import 'package:reservation_workshop/modules/job_estimators/presentation/screens/job_estimators_screen.dart';
import 'package:reservation_workshop/modules/home/presentation/screens/home_screen.dart';
import 'package:reservation_workshop/modules/home/presentation/cubit/blog_cubit.dart';
import 'package:reservation_workshop/modules/menu/presentation/screens/menu_about_center_screen.dart';
import 'package:reservation_workshop/modules/menu/presentation/screens/menu_about_skoda_screen.dart';
import 'package:reservation_workshop/modules/menu/presentation/screens/menu_account_screen.dart';
import 'package:reservation_workshop/modules/menu/presentation/screens/menu_change_language_screen.dart';
import 'package:reservation_workshop/modules/menu/presentation/screens/menu_contact_screen.dart';
import 'package:reservation_workshop/modules/menu/presentation/screens/menu_logout_screen.dart';
import 'package:reservation_workshop/modules/notifications/presentation/cubit/maintenance_notifications_cubit.dart';
import 'package:reservation_workshop/modules/notifications/presentation/screens/maintenance_notifications_screen.dart';
import 'package:reservation_workshop/modules/loyalty_points/presentation/cubit/loyalty_points_cubit.dart';
import 'package:reservation_workshop/modules/loyalty_points/presentation/screens/loyalty_points_screen.dart';
import 'package:reservation_workshop/modules/startup/presentation/first_language_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await CacheHelper.init();

  final savedCode = await CacheHelper.getDataAsync<String>(key: PrefKeys.kLocaleCode);
  final normalized = (savedCode ?? '').trim().toLowerCase();
  final initialLocale = normalized == 'en' ? const Locale('en') : const Locale('ar');

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      startLocale: initialLocale,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget { 
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => AuthCubit()),
        BlocProvider<AuthOtpCubit>(create: (_) => AuthOtpCubit()),
        BlocProvider<AppCubit>(create: (_) => AppCubit()),
        BlocProvider<ShiftCubit>(create: (_) => ShiftCubit()),
      ],
      child: MaterialApp(
        scaffoldMessengerKey: Toasters.messengerKey,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        builder: (context, child) {
          final isAr = context.locale.languageCode == 'ar';
          return Directionality(
            textDirection: isAr ? ui.TextDirection.rtl : ui.TextDirection.ltr,
            child: child ?? const SizedBox.shrink(),
          );
        },
        home: const FullscreenSplashScreen(),
        routes: {
          '/fullscreen_splash': (_) => const FullscreenSplashScreen(),
          '/startup': (_) => const StartupDeciderScreen(),
          RoutesName.firstLanguageScreen: (_) => const FirstLanguageScreen(),
          RoutesName.enterMobileScreen: (_) => const EnterMobileScreen(),
          RoutesName.otpVerificationScreen: (_) => const OtpVerificationScreen(),
          RoutesName.completeProfileScreen: (_) => const CompleteProfileScreen(),
          RoutesName.loginScreen: (_) => BlocProvider<LoginCubit>(
                create: (_) => LoginCubit(),
                child: const LoginScreen(),
              ),
          RoutesName.registerScreen: (_) => BlocProvider<RegisterCubit>(
                create: (_) => RegisterCubit(),
                child: const RegisterScreen(),
              ),
          RoutesName.chooseCarScreen: (_) => BlocProvider<CustomerInfoCubit>(
                create: (_) => CustomerInfoCubit(),
                child: const ChooseCarScreen(),
              ),
          RoutesName.addCarScreen: (_) => const AddCarScreen(),
          RoutesName.homeScreen: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider<BlogCubit>(create: (_) => BlogCubit()),
                  BlocProvider<CustomerInfoCubit>(create: (_) => CustomerInfoCubit()),
                  BlocProvider<BookingsCubit>(create: (_) => BookingsCubit()),
                ],
                child: const HomeScreen(),
              ),
          RoutesName.mainScreen: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider<CustomerInfoCubit>(create: (_) => CustomerInfoCubit()),
                  BlocProvider<BranchCubit>(create: (_) => BranchCubit()),
                  BlocProvider<ServiceCubit>(create: (_) => ServiceCubit()),
                  BlocProvider<JobOrdersCubit>(create: (_) => JobOrdersCubit()),
                  BlocProvider<JobEstimatorsCubit>(create: (_) => JobEstimatorsCubit()),
                  BlocProvider<MaintenanceNotificationsCubit>(create: (_) => MaintenanceNotificationsCubit()),
                ],
                child: const RequestsTabsScreen(),
              ),
          RoutesName.jobOrdersScreen: (_) => BlocProvider<JobOrdersCubit>(
                create: (_) => JobOrdersCubit(),
                child: const JobOrdersScreen(),
              ),
          RoutesName.jobOrderDetailsScreen: (_) => BlocProvider<JobOrderDetailsCubit>(
                create: (_) => JobOrderDetailsCubit(),
                child: const JobOrderDetailsScreen(),
              ),
          RoutesName.informationBookingsScreen: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider<BookingsCubit>(create: (_) => BookingsCubit()),
                  BlocProvider<CustomerInfoCubit>(create: (_) => CustomerInfoCubit()),
                ],
                child: const InformationBookingsScreen(),
              ),
          RoutesName.notificationsScreen: (context) {
                MaintenanceNotificationsCubit? existing;
                try {
                  existing = BlocProvider.of<MaintenanceNotificationsCubit>(context);
                } catch (_) {
                  existing = null;
                }

                if (existing != null) {
                  return BlocProvider.value(
                    value: existing,
                    child: const MaintenanceNotificationsScreen(),
                  );
                }

                return BlocProvider<MaintenanceNotificationsCubit>(
                  create: (_) => MaintenanceNotificationsCubit(),
                  child: const MaintenanceNotificationsScreen(),
                );
              },
          RoutesName.bookingDetailsScreen: (_) => BlocProvider<AddBookingCubit>(
                create: (_) => AddBookingCubit(),
                child: const BookingDetailsScreen(),
              ),
          RoutesName.jobEstimatorsScreen: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider<CustomerInfoCubit>(create: (_) => CustomerInfoCubit()),
                  BlocProvider<JobEstimatorsCubit>(create: (_) => JobEstimatorsCubit()),
                ],
                child: const JobEstimatorsScreen(),
              ),
          RoutesName.jobEstimatorDetailsScreen: (_) => const JobEstimatorDetailsScreen(),

          RoutesName.menuAccountScreen: (_) => BlocProvider<CustomerInfoCubit>(
                create: (_) => CustomerInfoCubit(),
                child: const MenuAccountScreen(),
              ),
          RoutesName.menuAboutSkodaScreen: (_) => const MenuAboutSkodaScreen(),
          RoutesName.menuRescueScreen: (_) => MenuRescueScreen(),
          RoutesName.menuContactScreen: (_) => const MenuContactScreen(),
          RoutesName.menuAboutCenterScreen: (_) => const MenuAboutCenterScreen(),
          RoutesName.menuLoyaltyPointsScreen: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider<CustomerInfoCubit>(create: (_) => CustomerInfoCubit()),
                  BlocProvider<LoyaltyPointsCubit>(create: (_) => LoyaltyPointsCubit()),
                ],
                child: const LoyaltyPointsScreen(),
              ),
          RoutesName.menuChangeLanguageScreen: (_) => const MenuChangeLanguageScreen(),
          RoutesName.menuLogoutScreen: (_) => const MenuLogoutScreen(),
        },
      ),
    );
  }
}
