import 'package:annotator_app/colors.dart';
import 'package:annotator_app/comment_set_provider.dart';
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
    final commentSetNotifier = ref.watch(commentSetProvider.notifier);
    final totalLength = commentSetNotifier.length;
    final annotatedLength = commentSetNotifier.annotationCount;

    final currentSets=commentSetNotifier.current;


    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Annotation Page",
          style: TextStyle(color: pureWhite),
        ),
        actions: [
          Text('$annotatedLength / $totalLength'),
          const SizedBox(width: 16),
          FilledButton(onPressed: (){}, child: const Text('Next ->')),
          const SizedBox(width: 16),
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
                        key: ObjectKey(currentSets),
                        comments: currentSets)),
              ],
            ),
          ),
          const Divider(
            color: softBlack,
            height: 1,
          ),
          const _ProgressIndicator(),
        ],
      ),
    );
  }
}

class _ProgressIndicator extends ConsumerWidget {
  const _ProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentSetNotifier = ref.watch(commentSetProvider.notifier);
    final totalLength = commentSetNotifier.length;
    final annotatedLength = commentSetNotifier.annotationCount;
    final relativeProgress = annotatedLength / totalLength;
    return LinearProgressIndicator(
      value: relativeProgress,
      minHeight: 20,
    );
  }
}
