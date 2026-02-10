import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:reservation_workshop/config/routes/routes_name.dart';
import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/config/style/text_styles.dart';
import 'package:reservation_workshop/core/components/dialogs/prograss_delay_dialog.dart';
import 'package:reservation_workshop/core/components/toasters.dart';
import 'package:reservation_workshop/core/functions/validationform.dart';
import 'package:reservation_workshop/core/utils/strings/app_texts.dart';
import 'package:reservation_workshop/core/utils/strings/app_strings.dart';
import 'package:reservation_workshop/core/widgets/logo_image_widget.dart';
import 'package:reservation_workshop/core/widgets/splash_image_widget.dart';
import 'package:reservation_workshop/modules/auth/presentation/cubits/auth_otp_cubit/auth_otp_cubit.dart';
import 'package:reservation_workshop/modules/auth/presentation/cubits/auth_otp_cubit/auth_otp_state.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isObscured = true;
  bool _isObscured2 = true;

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _confirmValidator(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Required';
    if (v != _passwordController.text.trim()) return 'Not match';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = AuthOtpCubit.get(context);

    return BlocListener<AuthOtpCubit, AuthOtpState>(
      listener: (context, state) {
        if (state is CompleteProfileLoading) {
          showPrograssDelayDialog(context);
          return;
        }

        if (state is CompleteProfileSuccess) {
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.mainScreen,
            (route) => false,
          );
          return;
        }

        if (state is AuthOtpError) {
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
                  Text(AppTexts.completeProfileTitle, style: titleStyle, textAlign: TextAlign.center),
                  const SizedBox(height: 6),
                  Text(
                    AppTexts.completeProfileSubtitle,
                    style: subtitleStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _nameController,
                    validator: ValidationForm.nameValidator,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                    decoration: InputDecoration(
                      hintText: AppTexts.nameHint,
                      prefixIcon: const Icon(Icons.person_outline, color: Colors.white70),
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
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _passwordController,
                    validator: ValidationForm.passwordValidator,
                    obscureText: _isObscured,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                    decoration: InputDecoration(
                      hintText: AppTexts.passwordHint,
                      prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
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
                      suffixIcon: IconButton(
                        icon: Icon(_isObscured ? Icons.visibility_off : Icons.visibility, color: Colors.white70),
                        onPressed: () {
                          setState(() {
                            _isObscured = !_isObscured;
                          });
                        },
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _confirmPasswordController,
                    validator: _confirmValidator,
                    obscureText: _isObscured2,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                    decoration: InputDecoration(
                      hintText: AppTexts.confirmPasswordHint,
                      prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
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
                      suffixIcon: IconButton(
                        icon: Icon(_isObscured2 ? Icons.visibility_off : Icons.visibility, color: Colors.white70),
                        onPressed: () {
                          setState(() {
                            _isObscured2 = !_isObscured2;
                          });
                        },
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 52,
                    width: isWide ? MediaQuery.of(context).size.width / 3 : double.infinity,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: const LinearGradient(
                          colors: [AppColors.brandPrimary, AppColors.brandDark],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.brandPrimarySoft2,
                            blurRadius: 18,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              cubit.completeProfile(
                                name: _nameController.text,
                                password: _passwordController.text,
                              );
                            }
                          },
                          child: const Center(
                            child: Text(
                              AppTexts.completeSetup,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
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
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Column(
                      children: [
                        const LogoImageWidget(),
                        const SizedBox(height: 14),
                        Card(
                          color: const Color(0xFF0B0F1A),
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: form,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          AppStrings.workshopManagement,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
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
