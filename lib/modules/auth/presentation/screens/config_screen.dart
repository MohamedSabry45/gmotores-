/*import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:reservation_workshop/config/routes/routes_name.dart';
import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/config/style/text_styles.dart';
import 'package:reservation_workshop/constants/app_constants.dart';
import 'package:reservation_workshop/core/components/app_textfield.dart';
import 'package:reservation_workshop/core/components/dialogs/prograss_delay_dialog.dart';
import 'package:reservation_workshop/core/components/toasters.dart';
import 'package:reservation_workshop/core/functions/validationform.dart';
import 'package:reservation_workshop/core/network/local/cache_helper.dart';
import 'package:reservation_workshop/core/utils/strings/app_strings.dart';
import 'package:reservation_workshop/core/utils/strings/prefkeys.dart';
import 'package:reservation_workshop/core/widgets/app_single_button.dart';
import 'package:reservation_workshop/core/widgets/logo_image_widget.dart';
import 'package:reservation_workshop/core/widgets/splash_image_widget.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  final TextEditingController _baseUrlController = TextEditingController();
  final TextEditingController _clintIdController = TextEditingController();
  final TextEditingController _clientSecretController = TextEditingController();
  final TextEditingController _configTokenController = TextEditingController();
  final TextEditingController _domainController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _baseUrlController.dispose();
    _clintIdController.dispose();
    _clientSecretController.dispose();
    _configTokenController.dispose();
    _domainController.dispose();
    super.dispose();
  }

  Future<void> _openScanner(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: const Text('Scan QR Code'),
            backgroundColor: AppColors.teal,
          ),
          body: MobileScanner(
            controller: MobileScannerController(
              detectionTimeoutMs: 1000,
            ),
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final String? value = barcodes.first.rawValue;
                if (value != null) {
                  Navigator.pop(context, value);
                }
              }
            },
          ),
        ),
      ),
    );

    if (result != null && result is String) {
      final parts = result.split('#');
      if (parts.length >= 3) {
        _baseUrlController.text = parts[0].trim();
        _clintIdController.text = parts[1].trim();
        _clientSecretController.text = parts[2].trim();
        if (parts.length >= 5) {
          _domainController.text = parts[3].trim();
          _configTokenController.text = parts[4].trim();
        }
      } else {
        Toasters.show(AppStrings.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth >= 900;

          final form = Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                AppSingleButton(
                  height: 50,
                  width: isWide ? MediaQuery.of(context).size.width / 3 : double.infinity,
                  onPressed: () => _openScanner(context),
                  text: AppStrings.qrScan,
                  color: AppColors.teal,
                ),
                const SizedBox(height: 20),
                AppTextFormField(
                  hintText: AppStrings.baseUrl,
                  controller: _baseUrlController,
                  validator: ValidationForm.nameValidator,
                  textDirection: TextDirection.ltr,
                ),
                const SizedBox(height: 20),
                AppTextFormField(
                  hintText: AppStrings.clientId,
                  controller: _clintIdController,
                  validator: ValidationForm.nameValidator,
                  textDirection: TextDirection.ltr,
                ),
                const SizedBox(height: 20),
                AppTextFormField(
                  hintText: AppStrings.clientSecret,
                  controller: _clientSecretController,
                  validator: ValidationForm.nameValidator,
                  textDirection: TextDirection.ltr,
                ),
                const SizedBox(height: 20),
                AppTextFormField(
                  hintText: 'Domain',
                  controller: _domainController,
                  validator: ValidationForm.nameValidator,
                  textDirection: TextDirection.ltr,
                ),
                const SizedBox(height: 20),
                AppTextFormField(
                  hintText: 'Config Token',
                  controller: _configTokenController,
                  validator: ValidationForm.nameValidator,
                  textDirection: TextDirection.ltr,
                ),
                const SizedBox(height: 20),
                AppSingleButton(
                  height: 50,
                  width: isWide ? MediaQuery.of(context).size.width / 3 : double.infinity,
                  onPressed: () => saveSecretData(context),
                  text: AppStrings.save,
                  color: AppColors.teal,
                ),
              ],
            ),
          );

          if (isWide) {
            return Row(
              children: [
                SizedBox(
                  width: constraints.maxWidth / 2,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const LogoImageWidget(),
                          Text(
                            AppStrings.workshopManagement,
                            style: AppTextStyle.cairoBold36Black,
                          ),
                          const SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50.0),
                            child: form,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SplashImageWidget(),
              ],
            );
          }

          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 220,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/images/splash.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                    child: Column(
                      children: [
                        const LogoImageWidget(),
                        const SizedBox(height: 12),
                        Text(
                          AppStrings.workshopManagement,
                          style: AppTextStyle.cairoBold36Black,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        form,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void saveSecretData(BuildContext context) {
    if (formKey.currentState!.validate()) {
      showPrograssDelayDialog(context);

      AppConstants.kBaseUrl = _baseUrlController.text;
      AppConstants.kClientId = _clintIdController.text;
      AppConstants.kClientSecret = _clientSecretController.text;
      AppConstants.configToken = _configTokenController.text;
      AppConstants.domain = _domainController.text;

      CacheHelper.saveData(key: PrefKeys.kBaseUrlCode, value: _baseUrlController.text);
      CacheHelper.saveData(key: PrefKeys.kClientIdCode, value: _clintIdController.text);
      CacheHelper.saveData(key: PrefKeys.kClientSecretCode, value: _clientSecretController.text);
      CacheHelper.saveData(key: PrefKeys.kConfigTokenCode, value: _configTokenController.text);
      CacheHelper.saveData(key: PrefKeys.kDomainCode, value: _domainController.text);

      final String? token = CacheHelper.getData<String>(key: PrefKeys.kAccessToken);

      if (token != null) {
        AppConstants.token = token;
        Timer(const Duration(seconds: 1), () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.mainScreen,
            (route) => false,
          );
        });
      } else {
        Timer(const Duration(seconds: 1), () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.loginScreen,
            (route) => false,
          );
        });
      }
    }
  }
}
*/