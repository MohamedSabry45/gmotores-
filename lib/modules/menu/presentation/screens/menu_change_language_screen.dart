import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:reservation_workshop/core/network/local/cache_helper.dart';
import 'package:reservation_workshop/core/utils/strings/prefkeys.dart';

class MenuChangeLanguageScreen extends StatelessWidget {
  const MenuChangeLanguageScreen({super.key});

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
              },
            ),
          ],
        ),
      ),
    );
  }
}
