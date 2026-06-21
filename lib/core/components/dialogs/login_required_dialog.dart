import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:reservation_workshop/config/routes/routes_name.dart';

Future<void> showLoginRequiredDialog(BuildContext context) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      final isAr = ctx.locale.languageCode == 'ar';
      return Directionality(
        textDirection: isAr ? ui.TextDirection.rtl : ui.TextDirection.ltr,
        child: AlertDialog(
          title: Text('auth.login_required_title'.tr()),
          content: Text('auth.login_required_message'.tr()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('common.cancel'.tr()),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RoutesName.enterMobileScreen,
                  (route) => false,
                );
              },
              child: Text('auth.login_button'.tr()),
            ),
          ],
        ),
      );
    },
  );
}
