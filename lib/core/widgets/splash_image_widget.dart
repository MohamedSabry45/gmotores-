import 'package:flutter/material.dart';

class SplashImageWidget extends StatelessWidget {
  const SplashImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: Image.asset(
          'assets/images/splash.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
