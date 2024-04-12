import 'package:annotator_app/shared_preferences_extension.dart';
import 'package:annotator_app/upload_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'annotation_page/annotator_page.dart';

class AnnotatorApp extends ConsumerWidget {
  const AnnotatorApp({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Annotator App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: GetIt.instance.get<SharedPreferences>().hasSubmissionData
          ? const AnnotatorPage()
          : const UploadSubmissionPage(),
    );
  }
}
