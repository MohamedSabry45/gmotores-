import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:reservation_workshop/core/functions/localization_helper.dart';
import 'package:reservation_workshop/modules/about_us/presentation/cubit/about_us_cubit.dart';
import 'package:reservation_workshop/modules/about_us/presentation/screens/about_us_screen.dart';

class MenuAboutSkodaScreen extends StatelessWidget {
  const MenuAboutSkodaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AboutUsCubit>(
      create: (_) => AboutUsCubit()..load(),
      child: AboutUsScreen(
        title: t(context, 'about.vag_title', ar: 'تعرف على GMOTORS', en: 'About GMOTORS'),
      ),
    );
  }
}
