import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/core/network/local/cache_helper.dart';
import 'package:reservation_workshop/core/utils/strings/prefkeys.dart';

class FirstLanguageScreen extends StatelessWidget {
  const FirstLanguageScreen({super.key});

  Future<void> _selectLocale(BuildContext context, Locale locale) async {
    await CacheHelper.saveData(key: PrefKeys.kLocaleCode, value: locale.languageCode);
    if (!context.mounted) return;
    await context.setLocale(locale);
    if (!context.mounted) return;
    Navigator.of(context).pushReplacementNamed('/startup');
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 24.0 : 16.0,
              vertical: isWide ? 32.0 : 24.0,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isWide ? 560 : 420),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'first_language.title'.tr(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'first_language.subtitle'.tr(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.grey7, height: 1.4, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 18),
                      Directionality(
                        textDirection: ui.TextDirection.ltr,
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _selectLocale(context, const Locale('en')),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  side: const BorderSide(color: AppColors.brandOutline),
                                ),
                                child: Text(
                                  'first_language.english'.tr(),
                                  style: const TextStyle(fontWeight: FontWeight.w900),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _selectLocale(context, const Locale('ar')),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  backgroundColor: AppColors.brandPrimary,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                ),
                                child: Text(
                                  'first_language.arabic'.tr(),
                                  style: const TextStyle(fontWeight: FontWeight.w900),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
