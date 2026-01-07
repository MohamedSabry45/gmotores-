import 'package:flutter/material.dart';

import 'package:reservation_workshop/constants/app_constants.dart';
import 'package:reservation_workshop/core/network/local/cache_helper.dart';
import 'package:reservation_workshop/core/utils/strings/prefkeys.dart';

class LogoImageWidget extends StatelessWidget {
  const LogoImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: CacheHelper.getDataAsync<String>(key: PrefKeys.kBusinessLogoPath),
      builder: (context, snapshot) {
        final path = snapshot.data?.trim();
        final hasLogo = path != null && path.isNotEmpty;

        if (!hasLogo) {
          return Image.asset(
            'assets/images/logo.png',
            height: 120,
            fit: BoxFit.contain,
          );
        }

        final baseUrl = AppConstants.kBaseUrl.trim();
        final normalizedBase = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
        final normalizedPath = path.startsWith('/') ? path.substring(1) : path;
        final url = '$normalizedBase/$normalizedPath';

        return Image.network(
          url,
          height: 120,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) {
            return Image.asset(
              'assets/images/logo.png',
              height: 120,
              fit: BoxFit.contain,
            );
          },
        );
      },
    );
  }
}
