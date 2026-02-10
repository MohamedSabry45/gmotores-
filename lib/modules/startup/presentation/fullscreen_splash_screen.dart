import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:reservation_workshop/config/routes/routes_name.dart';

class FullscreenSplashScreen extends StatefulWidget {
  const FullscreenSplashScreen({super.key});

  @override
  State<FullscreenSplashScreen> createState() => _FullscreenSplashScreenState();
}

class _FullscreenSplashScreenState extends State<FullscreenSplashScreen> {
  Timer? _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage('assets/images/splash_screen.png'), context);
  }

  @override
  void initState() {
    super.initState();
    _requestNotificationPermissionThenNavigate();
  }

  Future<void> _requestNotificationPermissionThenNavigate() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    final token = await FirebaseMessaging.instance.getToken();
    debugPrint('🔥 FCM TOKEN => $token');

    _timer = Timer(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/startup');
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          'assets/images/splash_screen.png',
          fit: BoxFit.cover,
          gaplessPlayback: true,
        ),
      ),
    );
  }
}
