import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui' as ui;

String? getTranslated(String key, BuildContext context) {
  final translated = key.tr();
  if (translated == key) return null;

  // Safety: avoid showing raw keys in UI.
  if (translated.contains('.') || translated.contains('_')) return null;

  return translated;
}

String t(
  BuildContext context,
  String key, {
  required String ar,
  required String en,
  List<String> args = const [],
}) {
  final raw = getTranslated(key, context) ?? (isLtr(context) ? en : ar);
  if (args.isEmpty) return raw;

  var result = raw;
  for (final value in args) {
    result = result.replaceFirst('{}', value);
  }
  return result;
}

bool isLtr(BuildContext context) {
  return Directionality.of(context) == ui.TextDirection.ltr;
}
