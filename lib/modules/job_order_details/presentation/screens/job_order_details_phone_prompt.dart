import 'package:flutter/material.dart';

class JobOrderDetailsPhonePrompt extends StatefulWidget {
  const JobOrderDetailsPhonePrompt({super.key});

  @override
  State<JobOrderDetailsPhonePrompt> createState() => _JobOrderDetailsPhonePromptState();
}

class _JobOrderDetailsPhonePromptState extends State<JobOrderDetailsPhonePrompt> {
  final TextEditingController _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isValidLast4(String v) {
    final s = v.trim();
    if (s.length != 4) return false;
    return RegExp(r'^[0-9\u0660-\u0669]{4}$').hasMatch(s);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Text(
          'تأكيد رقم الهاتف',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'اكتب آخر 4 أرقام من رقم الموبايل لعرض تفاصيل أمر العمل.',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'مثال: 4154',
                errorText: _error,
                border: const OutlineInputBorder(),
              ),
              maxLength: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text(
              'إلغاء',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
            ),
          ),
          TextButton(
            onPressed: () {
              final v = _controller.text;
              if (!_isValidLast4(v)) {
                setState(() => _error = 'لازم 4 أرقام');
                return;
              }
              Navigator.pop(context, v.trim());
            },
            child: const Text(
              'متابعة',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}
