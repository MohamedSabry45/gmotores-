import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ContactCarsScreen extends StatelessWidget {
  const ContactCarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home.contact_cars'.tr()),
      ),
      body: const SizedBox.shrink(),
    );
  }
}
