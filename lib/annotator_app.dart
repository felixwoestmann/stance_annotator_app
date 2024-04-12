import 'package:annotator_app/shared_preferences_extension.dart';
import 'package:annotator_app/submission_repository.dart';
import 'package:annotator_app/ui/annotation_page/annotator_page.dart';
import 'package:annotator_app/ui/upload_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnnotatorApp extends ConsumerWidget {
  const AnnotatorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = GetIt.instance.get<SharedPreferences>();
    Widget home;
    if (prefs.hasSubmissionData) {
      final submission = prefs.loadSubmission();
      ref.read(submissionRepositoryProvider).submission = submission;
      home = const AnnotatorPage();
    } else {
      home = const UploadSubmissionPage();
    }

    return MaterialApp(
      title: 'Annotator App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: home,
    );
  }
}
