import 'dart:convert';

import 'package:annotator_app/submission_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/submission.dart';
import 'annotation_page/annotator_page.dart';

class UploadSubmissionPage extends ConsumerWidget {
  const UploadSubmissionPage({super.key});

  Future<void> _onSubmissionButtonPressed(
      BuildContext context, WidgetRef ref) async {
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

      ref.read(submissionRepositoryProvider).submission = submission;

      navigator.push(MaterialPageRoute(builder: (_) => const AnnotatorPage()));
    } else {
      // ignore: use_build_context_synchronously
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              "This app is used to stance annotate comments of Reddits posts. "
              "To start upload a JSON file containing a Reddit submission",
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: FilledButton(
                onPressed: () => _onSubmissionButtonPressed(context, ref),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.upload_file),
                    SizedBox(width: 8),
                    Text('Pick JSON file'),
                  ],
                )),
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
