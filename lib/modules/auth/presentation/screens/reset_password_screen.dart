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

import 'package:reservation_workshop/modules/auth/presentation/cubits/reset_password_cubit/reset_password_cubit.dart';
import 'package:reservation_workshop/modules/auth/presentation/cubits/reset_password_cubit/reset_password_cubit.dart'
    as reset_password_cubit;

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final List<TextEditingController> _codeControllers = List.generate(5, (_) => TextEditingController());
  final List<FocusNode> _codeFocusNodes = List.generate(5, (_) => FocusNode());

  bool _didPrefill = false;
  bool _dialogShown = false;
  bool _isObscured = true;
  bool _isConfirmObscured = true;

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
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    for (final c in _codeControllers) {
      c.dispose();
    }
    for (final f in _codeFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  Widget buildCodeInputs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(5, (index) {
        return SizedBox(
          width: 56,
          height: 56,
          child: TextFormField(
            controller: _codeControllers[index],
            focusNode: _codeFocusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: const Color(0xFF0F172A),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF334155), width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < 4) {
                _codeFocusNodes[index + 1].requestFocus();
              } else if (value.isEmpty && index > 0) {
                _codeFocusNodes[index - 1].requestFocus();
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '';
              }
              return null;
            },
          ),
        );
      }),
    );
  }

  String getCodeValue() {
    final code = _codeControllers.map((c) => c.text).join();
    _otpController.text = code;
    return code;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = reset_password_cubit.ResetPasswordCubit.get(context);

    return BlocListener<reset_password_cubit.ResetPasswordCubit, reset_password_cubit.ResetPasswordState>(
      listener: (context, state) {
        if (state is reset_password_cubit.ResetPasswordLoading) {
          showPrograssDelayDialog(context);
          _dialogShown = true;
          return;
        }

        if (state is reset_password_cubit.ResetPasswordSuccess) {
          if (_dialogShown) {
            Navigator.of(context, rootNavigator: true).maybePop();
            _dialogShown = false;
          }
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.loginScreen,
            (route) => false,
            arguments: {'mobile': _mobileController.text},
          );
          return;
        }

        if (state is reset_password_cubit.ResetPasswordError) {
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
                    'auth.reset_password_title'.tr(),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  AppTextFormField(
                    hintText: 'auth.mobile_hint'.tr(),
                    controller: _mobileController,
                    validator: ValidationForm.nameValidator,
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'auth.register_code_hint'.tr(),
                        style: AppTextStyle.cairoBold16Black,
                      ),
                      const SizedBox(height: 12),
                      buildCodeInputs(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AppTextFormField(
                    hintText: 'auth.new_password_hint'.tr(),
                    controller: _newPasswordController,
                    obscureText: _isObscured,
                    validator: ValidationForm.passwordValidator,
                    fixIcon: IconButton(
                      icon: Icon(
                        _isObscured ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white70,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppTextFormField(
                    hintText: 'auth.confirm_password_hint'.tr(),
                    controller: _confirmPasswordController,
                    obscureText: _isConfirmObscured,
                    validator: (value) {
                      if (value != _newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return ValidationForm.passwordValidator(value);
                    },
                    fixIcon: IconButton(
                      icon: Icon(
                        _isConfirmObscured ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white70,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmObscured = !_isConfirmObscured;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  AppSingleButton(
                    height: 50,
                    width: isWide ? MediaQuery.of(context).size.width / 3 : double.infinity,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        cubit.resetPassword(
                          mobile: _mobileController.text,
                          otp: getCodeValue(),
                          newPassword: _newPasswordController.text,
                        );
                      }
                    },
                    text: 'auth.reset_password_submit'.tr(),
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
