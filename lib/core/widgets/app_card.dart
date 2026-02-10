import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.backgroundColor = Colors.white,
    this.backgroundGradient,
    this.borderColor = const Color(0xFFE6E8EC),
    this.borderRadius = 14,
    this.boxShadow,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color backgroundColor;
  final Gradient? backgroundGradient;
  final Color borderColor;
  final double borderRadius;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundGradient == null ? backgroundColor : null,
        gradient: backgroundGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor),
        boxShadow: boxShadow ?? const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 16,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}
