/*import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:reservation_workshop/core/notifications/notification_service.dart';

class FcmTestScreen extends StatefulWidget {
  const FcmTestScreen({super.key});

  @override
  State<FcmTestScreen> createState() => _FcmTestScreenState();

}

class _FcmTestScreenState extends State<FcmTestScreen> {
  String? _token;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    if (_loading) return;
    setState(() {
      _loading = true;
    });

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    final token = await FirebaseMessaging.instance.getToken();
    debugPrint('🔥 FCM TOKEN => $token');

    if (!mounted) return;
    setState(() {
      _token = token;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FCM TEST')),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SelectableText(
                      _token == null ? 'FCM TOKEN: null' : 'FCM TOKEN: $_token',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        NotificationService.show(
                          title: 'LOCAL TEST',
                          body: 'ده إشعار من الجهاز نفسه 🔔',
                        );
                      },
                      child: const Text('TEST LOCAL'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
*/