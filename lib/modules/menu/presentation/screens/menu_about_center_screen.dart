import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:reservation_workshop/modules/locations/presentation/cubit/business_locations_cubit.dart';
import 'package:reservation_workshop/modules/locations/presentation/screens/business_locations_screen.dart';

class MenuAboutCenterScreen extends StatelessWidget {
  const MenuAboutCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BusinessLocationsCubit>(
      create: (_) => BusinessLocationsCubit(),
      child: const BusinessLocationsScreen(),
    );
  }
}
