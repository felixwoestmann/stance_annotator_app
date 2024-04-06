import 'package:annotator_app/colors.dart';
import 'package:annotator_app/submission_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'comment_view.dart';
import 'left_siderbar.dart';

class AnnotatorPage extends ConsumerWidget {
  const AnnotatorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final submission = ref.watch(submissionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Annotate",
          style: TextStyle(color: pureWhite),
        ),
        actions: [
          FilledButton(
              onPressed: () {
                final sets=ref.read(submissionProvider.notifier).generateCommentSets();
                print(sets.length);
              },
              child: Text('CommentSets'))
        ],
        backgroundColor: softBlack,
        foregroundColor: pureWhite,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: Row(
              children: [
                Flexible(flex: 1, child: LeftSidebar(submission: submission)),
                const VerticalDivider(
                  color: softBlack,
                ),
                Flexible(
                    flex: 3,
                    child: CommentView(
                        key: ObjectKey(submission),
                        comments: submission.branches)),
              ],
            ),
          ),
          const Divider(
            color: softBlack,
          ),
          const LinearProgressIndicator(
            value: 0.3,
            minHeight: 20,
          ),
          const SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }
}
