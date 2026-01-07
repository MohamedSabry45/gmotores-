import 'package:flutter/material.dart';

class AppSingleButton extends StatelessWidget {
  const AppSingleButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.color,
    required this.height,
    required this.width,
  });

  final VoidCallback onPressed;
  final String text;
  final Color color;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
