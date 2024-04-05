
import 'package:annotator_app/persistence_provider.dart';
import 'package:annotator_app/upload_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'annotation_page/annotator_page.dart';

class AnnotatorApp extends ConsumerWidget {
  const AnnotatorApp({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final submission = ref.watch(persistenceProvider).loadData();
    return MaterialApp(
      title: 'Annotator App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: submission != null
          ? AnnotatorPage(submission: submission)
          : const UploadSubmissionPage(),
    );
  }
}

