import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:reservation_workshop/config/routes/routes_name.dart';
import 'package:reservation_workshop/config/style/text_styles.dart';
import 'package:reservation_workshop/core/components/dialogs/prograss_delay_dialog.dart';
import 'package:reservation_workshop/core/components/toasters.dart';
import 'package:reservation_workshop/core/components/app_textfield.dart';
import 'package:reservation_workshop/core/functions/validationform.dart';
import 'package:reservation_workshop/core/widgets/app_single_button.dart';
import 'package:reservation_workshop/core/widgets/logo_image_widget.dart';
import 'package:reservation_workshop/core/widgets/splash_image_widget.dart';

import 'package:reservation_workshop/modules/auth/presentation/cubits/forgot_password_cubit/forgot_password_cubit.dart';
import 'package:reservation_workshop/modules/auth/presentation/cubits/forgot_password_cubit/forgot_password_cubit.dart'
    as forgot_password_cubit;

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _mobileController = TextEditingController();

  bool _didPrefill = false;
  bool _dialogShown = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didPrefill) return;
    _didPrefill = true;

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      final mobile = args['mobile']?.toString();
      if (mobile != null && mobile.trim().isNotEmpty) {
        _mobileController.text = mobile;
      }
    }
  }

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = forgot_password_cubit.ForgotPasswordCubit.get(context);

    return BlocListener<forgot_password_cubit.ForgotPasswordCubit, forgot_password_cubit.ForgotPasswordState>(
      listener: (context, state) {
        if (state is forgot_password_cubit.ForgotPasswordLoading) {
          showPrograssDelayDialog(context);
          _dialogShown = true;
          return;
        }

        if (state is forgot_password_cubit.ForgotPasswordSuccess) {
          if (_dialogShown) {
            Navigator.of(context, rootNavigator: true).maybePop();
            _dialogShown = false;
          }
          Navigator.pushNamed(
            context,
            RoutesName.resetPasswordScreen,
            arguments: {'mobile': state.mobile},
          );
          return;
        }

        if (state is forgot_password_cubit.ForgotPasswordError) {
          if (_dialogShown) {
            Navigator.of(context, rootNavigator: true).maybePop();
            _dialogShown = false;
          }
          Toasters.show(state.message);
          return;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final bool isWide = constraints.maxWidth >= 900;

            final form = Form(
              key: formKey,
              child: Column(
                children: [
                  Text(
                    'auth.forgot_password_title'.tr(),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'auth.forgot_password_hint'.tr(),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  AppTextFormField(
                    hintText: 'auth.mobile_hint'.tr(),
                    controller: _mobileController,
                    validator: ValidationForm.nameValidator,
                  ),
                  const SizedBox(height: 24),
                  AppSingleButton(
                    height: 50,
                    width: isWide ? MediaQuery.of(context).size.width / 3 : double.infinity,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        cubit.forgotPassword(mobile: _mobileController.text);
                      }
                    },
                    text: 'auth.forgot_password_submit'.tr(),
                    color: const Color.fromARGB(255, 181, 7, 7),
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
                              'auth.welcome_title'.tr(),
                              style: AppTextStyle.cairoBold36Black,
                            ),
                            const SizedBox(height: 30),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 50),
                              child: Card(
                                color: const Color(0xFF0B0F1A),
                                elevation: 2,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                                  child: form,
                                ),
                              ),
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Column(
                    children: [
                      const LogoImageWidget(),
                      const SizedBox(height: 12),
                      Text(
                        'auth.welcome_title'.tr(),
                        style: AppTextStyle.cairoBold36Black,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Card(
                        color: const Color(0xFF0B0F1A),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                          child: form,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
