import 'package:flutter/material.dart';

import 'package:reservation_workshop/core/widgets/primary_button.dart';

class SubmitBookingButton extends StatelessWidget {
  const SubmitBookingButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      label: 'احجز الآن',
      onPressed: onPressed,
    );
  }
}
