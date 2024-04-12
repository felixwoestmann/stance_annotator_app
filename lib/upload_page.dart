import 'dart:convert';

import 'package:annotator_app/shared_preferences_extension.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'annotation_page/annotator_page.dart';
import 'data/submission.dart';

class UploadSubmissionPage extends ConsumerWidget {
  const UploadSubmissionPage({
    super.key,
  });

  Future<void> _onSubmissionButtonPressed(BuildContext context) async {
    final navigator = Navigator.of(context);

    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['json']);

    if (result != null) {
      final bytes = result.files.single.bytes;
      final jsonString = String.fromCharCodes(bytes!);
      final submission = Submission.fromJson(json.decode(jsonString));

      // This function shall set the isTopLevel for each comment
      for (final branch in submission.branches) {
        branch.isTopLevel = true;
      }

      await GetIt.instance.get<SharedPreferences>().saveSubmission(submission);

      navigator.push(MaterialPageRoute(builder: (_) => const AnnotatorPage()));
    } else {
      await showDialog(
          context: context, builder: (_) => const Text("Error occured"));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          'Upload Reddit Submission',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Center(
        child: FilledButton(
            onPressed: () => _onSubmissionButtonPressed(context),
            child: const Text('Pick JSON file')),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
