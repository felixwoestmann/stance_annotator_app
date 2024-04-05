import 'package:annotator_app/persistence_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'annotator_app.dart';

void main() async {
  final prefs = await SharedPreferences.getInstance();

  runApp(ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const AnnotatorApp()));
}
