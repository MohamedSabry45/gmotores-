import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:reservation_workshop/core/widgets/app_single_button.dart';
import 'package:reservation_workshop/config/routes/routes_name.dart';
import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/config/style/text_styles.dart';
import 'package:reservation_workshop/core/components/dialogs/prograss_delay_dialog.dart';
import 'package:reservation_workshop/core/components/toasters.dart';
import 'package:reservation_workshop/core/functions/validationform.dart';
import 'package:reservation_workshop/core/widgets/logo_image_widget.dart';
import 'package:reservation_workshop/core/network/local/cache_helper.dart';
import 'package:reservation_workshop/core/utils/strings/prefkeys.dart';
import 'package:reservation_workshop/modules/auth/presentation/cubits/check_phone_cubit/check_phone_cubit.dart';
import 'package:reservation_workshop/modules/auth/presentation/cubits/check_phone_cubit/check_phone_state.dart';
import 'package:reservation_workshop/modules/auth/presentation/cubits/social_auth_cubit/social_auth_cubit.dart';
import 'package:reservation_workshop/modules/auth/presentation/cubits/social_auth_cubit/social_auth_state.dart';

class EnterMobileScreen extends StatefulWidget {
  const EnterMobileScreen({super.key});

  @override
  State<EnterMobileScreen> createState() => _EnterMobileScreenState();
}

class _EnterMobileScreenState extends State<EnterMobileScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _mobileController = TextEditingController();
  bool _dialogShown = false;

  Future<void> _confirmRestoreDeletedAccount({
    required int userId,
    required String message,
    String? retryMobile,
  }) async {
    if (!mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Restore account'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      await SocialAuthCubit.get(context).restoreDeletedAccount(userId: userId);
      final m = (retryMobile ?? '').trim();
      if (m.isNotEmpty && mounted) {
        await CheckPhoneCubit.get(context).checkPhone(mobile: m);
      }
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      showPrograssDelayDialog(context);
      _dialogShown = true;

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        if (_dialogShown) {
          Navigator.of(context, rootNavigator: true).maybePop();
          _dialogShown = false;
        }
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken ?? '';

      final socialCubit = SocialAuthCubit.get(context);
      await socialCubit.socialLogin(
        accessToken: accessToken,
        uniqueId: googleUser.id,
        email: googleUser.email,
        medium: 'google',
        name: googleUser.displayName,
      );
    } catch (e) {
      if (_dialogShown) {
        Navigator.of(context, rootNavigator: true).maybePop();
        _dialogShown = false;
      }
      Toasters.show(e.toString());
    }
  }

  Future<void> signInWithApple() async {
    debugPrint('[APPLE_LOGIN] [A1] pressed');
    try {
      showPrograssDelayDialog(context);
      _dialogShown = true;

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final identityToken = appleCredential.identityToken ?? '';
      final authorizationCode = appleCredential.authorizationCode;
      final userIdentifier = appleCredential.userIdentifier ?? '';
      var email = appleCredential.email ?? '';

      // Extract email from JWT if not provided directly by Apple (common on 2nd+ login)
      if (email.isEmpty && identityToken.isNotEmpty) {
        try {
          final parts = identityToken.split('.');
          if (parts.length == 3) {
            final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
            final jwtData = jsonDecode(payload) as Map<String, dynamic>;
            email = jwtData['email']?.toString() ?? '';
            debugPrint('[APPLE_LOGIN] [A2] Extracted email from JWT: $email');
          }
        } catch (e) {
          debugPrint('[APPLE_LOGIN] [A2] Failed to parse JWT: $e');
        }
      }

      debugPrint('[APPLE_LOGIN] [A2] received: authCodeLen=${authorizationCode.length} identityTokenLen=${identityToken.length} uniqueId=${userIdentifier.substring(0, userIdentifier.length > 4 ? 4 : userIdentifier.length)}*** email=${email.isEmpty ? '(empty)' : email.substring(0, email.length > 4 ? 4 : email.length) + '***'} name=${appleCredential.givenName ?? '(empty)'} ${appleCredential.familyName ?? '(empty)'}');

      final fullName = <String?>[
        appleCredential.givenName,
        appleCredential.familyName,
      ].where((e) => (e ?? '').trim().isNotEmpty).join(' ').trim();

      if (userIdentifier.trim().isEmpty || authorizationCode.trim().isEmpty) {
        throw Exception('Invalid Apple authorization code');
      }

      debugPrint('[APPLE_LOGIN] [A3] payload: medium=apple unique_id=${userIdentifier.substring(0, 4)}*** email=${email.isEmpty ? '(empty)' : email.substring(0, 4) + '***'} authorization_code=${authorizationCode.substring(0, 4)}*** identity_token=${identityToken.substring(0, 4)}*** name=${fullName.isNotEmpty ? '(provided)' : '(empty)'}');

      debugPrint('[APPLE_LOGIN] [A4] calling backend...');

      final socialCubit = SocialAuthCubit.get(context);
      await socialCubit.socialLogin(
        accessToken: '',
        uniqueId: userIdentifier,
        email: email,
        medium: 'apple',
        name: fullName.isNotEmpty ? fullName : null,
        identityToken: identityToken,
        authorizationCode: authorizationCode,
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        return;
      }
      if (_dialogShown) {
        Navigator.of(context, rootNavigator: true).maybePop();
        _dialogShown = false;
      }
      Toasters.show(e.toString());
    } catch (e) {
      if (_dialogShown) {
        Navigator.of(context, rootNavigator: true).maybePop();
        _dialogShown = false;
      }
      Toasters.show(e.toString());
    }
  }

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

          return MultiBlocListener(
            listeners: [
              BlocListener<CheckPhoneCubit, CheckPhoneState>(
                listener: (context, state) {
                  if (state is CheckPhoneLoading) {
                    showPrograssDelayDialog(context);
                    _dialogShown = true;
                    return;
                  }

                  if (state is CheckPhoneRestoreRequired) {
                    if (_dialogShown) {
                      Navigator.of(context, rootNavigator: true).maybePop();
                      _dialogShown = false;
                    }
                    Future.microtask(() {
                      if (!mounted) return;
                      _confirmRestoreDeletedAccount(
                        userId: state.userId,
                        message: state.message,
                        retryMobile: state.mobile,
                      );
                    });
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
              ),
              BlocListener<SocialAuthCubit, SocialAuthState>(
                listener: (context, state) {
                  if (state is SocialAuthLoading) {
                    return;
                  }

                  if (state is SocialAuthSuccess) {
                    if (_dialogShown) {
                      Navigator.of(context, rootNavigator: true).maybePop();
                      _dialogShown = false;
                    }
                    debugPrint('[APPLE_LOGIN] [A6] navigating to chooseCarScreen');
                    Future.delayed(const Duration(milliseconds: 300), () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        RoutesName.chooseCarScreen,
                        (route) => false,
                      );
                    });
                    return;
                  }

                  if (state is SocialAuthNeedPhone) {
                    if (_dialogShown) {
                      Navigator.of(context, rootNavigator: true).maybePop();
                      _dialogShown = false;
                    }
                    Navigator.pushNamed(
                      context,
                      RoutesName.socialUpdateMobileScreen,
                      arguments: <String, dynamic>{
                        'email': state.email,
                        'name': state.name,
                        'medium': state.medium,
                        'unique_id': state.uniqueId,
                        'user_id': state.userId,
                      },
                    );
                    return;
                  }

                  if (state is SocialAuthRestoreRequired) {
                    if (_dialogShown) {
                      Navigator.of(context, rootNavigator: true).maybePop();
                      _dialogShown = false;
                    }
                    Future.microtask(() {
                      if (!mounted) return;
                      _confirmRestoreDeletedAccount(userId: state.userId, message: state.message);
                    });
                    return;
                  }

                  if (state is SocialAuthError) {
                    if (_dialogShown) {
                      Navigator.of(context, rootNavigator: true).maybePop();
                      _dialogShown = false;
                    }
                    Toasters.show(state.message);
                    return;
                  }
                },
              ),
            ],
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

                        const SizedBox(height: 18),
                        const Divider(color: Color(0xFF334155), height: 1),
                        const SizedBox(height: 18),

                        SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: signInWithGoogle,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Continue with Google'),
                          ),
                        ),
                        if (Platform.isIOS) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed: signInWithApple,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Continue with Apple'),
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: () async {
                            await CacheHelper.saveData(key: PrefKeys.kIsGuestMode, value: true);
                            if (mounted) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                RoutesName.homeScreen,
                                (route) => false,
                              );
                            }
                          },
                          icon: const Icon(Icons.person_outline, color: Colors.white70),
                          label: Text(
                            'auth.continue_as_guest'.tr(),
                            style: const TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white30),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            minimumSize: const Size(double.infinity, 48),
                          ),
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
