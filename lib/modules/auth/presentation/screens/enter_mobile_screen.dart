import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;

import 'package:reservation_workshop/config/routes/routes_name.dart';
import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/config/style/text_styles.dart';
import 'package:reservation_workshop/core/components/dialogs/prograss_delay_dialog.dart';
import 'package:reservation_workshop/core/components/toasters.dart';
import 'package:reservation_workshop/core/functions/validationform.dart';
import 'package:reservation_workshop/core/widgets/logo_image_widget.dart';
import 'package:reservation_workshop/core/widgets/app_single_button.dart';
import 'package:reservation_workshop/modules/auth/presentation/cubits/check_phone_cubit/check_phone_cubit.dart';
import 'package:reservation_workshop/modules/auth/presentation/cubits/check_phone_cubit/check_phone_state.dart';

class EnterMobileScreen extends StatefulWidget {
  const EnterMobileScreen({super.key});

  @override
  State<EnterMobileScreen> createState() => _EnterMobileScreenState();
}

class _EnterMobileScreenState extends State<EnterMobileScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _mobileController = TextEditingController();
  bool _dialogShown = false;

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CheckPhoneCubit>(
      create: (_) => CheckPhoneCubit(),
      child: Builder(
        builder: (context) {
          final cubit = context.read<CheckPhoneCubit>();

          return BlocListener<CheckPhoneCubit, CheckPhoneState>(
            listener: (context, state) {
              if (state is CheckPhoneLoading) {
                showPrograssDelayDialog(context);
                _dialogShown = true;
                return;
              }

              if (state is CheckPhoneSuccess) {
                if (_dialogShown) {
                  Navigator.of(context, rootNavigator: true).maybePop();
                  _dialogShown = false;
                }

                if (state.result.userFound) {
                  Navigator.pushNamed(
                    context,
                    RoutesName.loginScreen,
                    arguments: <String, dynamic>{
                      'mobile': state.mobile,
                      'name': state.result.name,
                    },
                  );
                  return;
                }

                Navigator.pushNamed(
                  context,
                  RoutesName.registerScreen,
                  arguments: <String, dynamic>{
                    'mobile': state.mobile,
                  },
                );
                return;
              }

              if (state is CheckPhoneError) {
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

                  final titleStyle = const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  );

                  final subtitleStyle = const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                    height: 1.3,
                  );

                  final form = Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('auth.enter_mobile_title'.tr(), style: titleStyle, textAlign: TextAlign.center),
                        const SizedBox(height: 6),
                        Text(
                          'auth.enter_mobile_subtitle'.tr(),
                          style: subtitleStyle,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 18),
                        TextFormField(
                          controller: _mobileController,
                          validator: ValidationForm.nameValidator,
                          keyboardType: TextInputType.phone,
                          textDirection: ui.TextDirection.ltr,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                          decoration: InputDecoration(
                            hintText: 'auth.mobile_hint'.tr(),
                            prefixIcon: const Icon(Icons.phone_android, color: Colors.white70),
                            filled: true,
                            fillColor: const Color(0xFF0F172A),
                            hintStyle: const TextStyle(color: Colors.white54, fontWeight: FontWeight.w600),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF334155)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF334155)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.white, width: 1.2),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          ),
                        ),
                        const SizedBox(height: 16),
                        AppSingleButton(
                          height: 52,
                          width: double.infinity,
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              cubit.checkPhone(mobile: _mobileController.text);
                            }
                          },
                          text: 'auth.send_otp'.tr(),
                          color: const Color.fromARGB(255, 81, 79, 79),
                        ),
                      ],
                    ),
                  );

                  // Unified centered layout similar to LoginScreen
                  return SafeArea(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: isWide ? 24.0 : 16.0,
                          vertical: isWide ? 32.0 : 24.0,
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: isWide ? 560 : 420,
                          ),
                          child: Card(
                            color: const Color(0xFF0B0F1A),
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const LogoImageWidget(),
                                  const SizedBox(height: 12),
                                  Text(
                                    'auth.welcome_title'.tr(),
                                    style: AppTextStyle.cairoBold36Black,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 24),
                                  form,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
