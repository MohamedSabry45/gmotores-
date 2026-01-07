import 'package:flutter/material.dart';

void showPrograssDelayDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return const Center(
        child: SizedBox(
          width: 56,
          height: 56,
          child: CircularProgressIndicator(),
        ),
      );
    },
  );
}
