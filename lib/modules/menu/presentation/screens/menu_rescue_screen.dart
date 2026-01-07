import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:reservation_workshop/modules/branch/presentation/cubits/branch_cubit/branch_cubit.dart';
import 'package:reservation_workshop/modules/customer/presentation/cubits/customer_info_cubit/customer_info_cubit.dart';
import 'package:reservation_workshop/modules/service/presentation/cubits/service_cubit/service_cubit.dart';

import 'package:reservation_workshop/modules/rescue/presentation/cubit/rescue_cubit.dart';
import 'package:reservation_workshop/modules/rescue/presentation/screens/rescue_screen.dart';

class MenuRescueScreen extends StatelessWidget {
  const MenuRescueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RescueCubit>(create: (_) => RescueCubit()),
        BlocProvider<CustomerInfoCubit>(create: (_) => CustomerInfoCubit()),
        BlocProvider<BranchCubit>(create: (_) => BranchCubit()),
        BlocProvider<ServiceCubit>(create: (_) => ServiceCubit()),
      ],
      child: const RescueScreen(),
    );
  }
}
