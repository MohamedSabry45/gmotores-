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
import 'package:reservation_workshop/core/widgets/app_single_button.dart';
import 'package:reservation_workshop/core/widgets/logo_image_widget.dart';
import 'package:reservation_workshop/modules/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:reservation_workshop/modules/auth/presentation/cubits/login_cubit/login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
        _userNameController.text = mobile;
      }
    }
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = LoginCubit.get(context);

    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          showPrograssDelayDialog(context);
          return;
        }

        if (state is LoginSuccess) {
          Navigator.of(context, rootNavigator: true).maybePop();
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              RoutesName.chooseCarScreen,
              (route) => false,
            );
          });
          return;
        }

        if (state is LoginError) {
          Navigator.of(context, rootNavigator: true).maybePop();
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
                  AppTextFormField(
                    hintText: 'auth.login_username_hint'.tr(),
                    controller: _userNameController,
                    validator: ValidationForm.nameValidator,
                  ),
                  const SizedBox(height: 20),
                  AppTextFormField(
                    hintText: 'auth.login_password_hint'.tr(),
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
                  AppSingleButton(
                    height: 50,
                    width: double.infinity,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        authCubit.login(mobile: _userNameController.text, password: _passwordController.text);
                      }
                    },
                    text: 'auth.login_button'.tr(),
                    color: AppColors.brandPrimary,
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          RoutesName.forgotPasswordScreen,
                          arguments: {'mobile': _userNameController.text},
                        );
                      },
                      child: Text(
                        'auth.forgot_password'.tr(),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );

            // Unified centered layout for all screen sizes
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
  }
}
