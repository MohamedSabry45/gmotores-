import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:reservation_workshop/config/routes/routes_name.dart';
import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/config/style/text_styles.dart';
import 'package:reservation_workshop/core/components/app_textfield.dart';
import 'package:reservation_workshop/core/components/dialogs/prograss_delay_dialog.dart';
import 'package:reservation_workshop/core/components/toasters.dart';
import 'package:reservation_workshop/core/functions/validationform.dart';
import 'package:reservation_workshop/core/utils/strings/app_strings.dart';
import 'package:reservation_workshop/core/widgets/app_single_button.dart';
import 'package:reservation_workshop/core/widgets/logo_image_widget.dart';
import 'package:reservation_workshop/core/widgets/splash_image_widget.dart';
import 'package:reservation_workshop/modules/auth/presentation/cubits/register_cubit/register_cubit.dart';
import 'package:reservation_workshop/modules/auth/presentation/cubits/register_cubit/register_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  bool _isObscured = true;
  bool _didPrefill = false;

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
    _nameController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = RegisterCubit.get(context);

    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterLoading) {
          showPrograssDelayDialog(context);
          return;
        }

        if (state is RegisterSuccess) {
          Navigator.of(context, rootNavigator: true).maybePop();
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.chooseCarScreen,
            (route) => false,
          );
          return;
        }

        if (state is RegisterError) {
          Navigator.of(context, rootNavigator: true).maybePop();
          Toasters.show(state.message);
          return;
        }
      },
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            final bool isWide = constraints.maxWidth >= 900;

            final form = Form(
              key: formKey,
              child: Column(
                children: [
                  AppTextFormField(
                    hintText: 'auth.register_name_hint'.tr(),
                    controller: _nameController,
                    validator: ValidationForm.nameValidator,
                  ),
                  const SizedBox(height: 20),
                  AppTextFormField(
                    hintText: 'auth.register_mobile_hint'.tr(),
                    controller: _mobileController,
                    validator: ValidationForm.nameValidator,
                  ),
                  const SizedBox(height: 20),
                  AppTextFormField(
                    hintText: 'auth.register_password_hint'.tr(),
                    obscureText: _isObscured,
                    maxLines: 1,
                    controller: _passwordController,
                    validator: ValidationForm.passwordValidator,
                    fixIcon: IconButton(
                      icon: Icon(
                        _isObscured ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  AppTextFormField(
                    hintText: 'auth.register_code_hint'.tr(),
                    controller: _codeController,
                    validator: ValidationForm.nameValidator,
                  ),
                  const SizedBox(height: 20),
                  AppSingleButton(
                    height: 50,
                    width: isWide ? MediaQuery.of(context).size.width / 3 : double.infinity,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        cubit.register(
                          name: _nameController.text,
                          mobile: _mobileController.text,
                          password: _passwordController.text,
                          code: _codeController.text,
                        );
                      }
                    },
                    text: 'auth.register_button'.tr(),
                    color: AppColors.green,
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
                              'auth.app_title'.tr(),
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
                            'auth.app_title'.tr(),
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
      ),
    );
  }
}
