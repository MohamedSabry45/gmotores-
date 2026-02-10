import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:reservation_workshop/core/network/local/cache_helper.dart';
import 'package:reservation_workshop/core/utils/strings/prefkeys.dart';
import 'package:reservation_workshop/modules/home/presentation/cubit/blog_cubit.dart';

class MenuChangeLanguageScreen extends StatelessWidget {
  const MenuChangeLanguageScreen({super.key});

  Future<void> _refreshBlogsIfAvailable(BuildContext context, {required String localeCode}) async {
    try {
      final cubit = BlocProvider.of<BlogCubit>(context);
      await cubit.loadFirst(localeCode: localeCode);
    } catch (_) {
      // BlogCubit not in the current widget tree (e.g. user not on Home route).
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentCode = context.locale.languageCode;
    return Scaffold(
      appBar: AppBar(
        title: Text('language.title'.tr()),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            RadioListTile<String>(
              value: 'ar',
              groupValue: currentCode,
              title: Text('language.arabic'.tr()),
              onChanged: (value) async {
                if (value == null) return;
                await CacheHelper.saveData(key: PrefKeys.kLocaleCode, value: value);
                if (!context.mounted) return;
                await context.setLocale(const Locale('ar'));
                if (!context.mounted) return;
                await _refreshBlogsIfAvailable(context, localeCode: value);
              },
            ),
            RadioListTile<String>(
              value: 'en',
              groupValue: currentCode,
              title: Text('language.english'.tr()),
              onChanged: (value) async {
                if (value == null) return;
                await CacheHelper.saveData(key: PrefKeys.kLocaleCode, value: value);
                if (!context.mounted) return;
                await context.setLocale(const Locale('en'));
                if (!context.mounted) return;
                await _refreshBlogsIfAvailable(context, localeCode: value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
