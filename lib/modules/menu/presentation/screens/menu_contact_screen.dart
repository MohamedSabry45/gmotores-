import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:reservation_workshop/modules/locations/presentation/cubit/business_locations_cubit.dart';
import 'package:reservation_workshop/modules/locations/presentation/screens/contact_us_screen.dart';

class MenuContactScreen extends StatelessWidget {
  const MenuContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BusinessLocationsCubit>(
      create: (_) => BusinessLocationsCubit(),
      child: const ContactUsScreen(),
    );
  }
}
