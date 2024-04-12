import 'package:annotator_app/colors.dart';
import 'package:annotator_app/ui/annotation_page/annotator_page_provider.dart';
import 'package:annotator_app/data/annotator_page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'comment_view.dart';
import 'left_siderbar.dart';

class AnnotatorPage extends ConsumerWidget {
  const AnnotatorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(annotatorPageProvider);
    final notifier = ref.watch(annotatorPageProvider.notifier);
    final current = notifier.current;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Annotation Page",
          style: TextStyle(color: pureWhite),
        ),
        automaticallyImplyLeading: false,
        actions: [
          Text('${notifier.currentPage} / ${notifier.totalPageCount}'),
          const SizedBox(width: 16),
          FilledButton(
              onPressed: notifier.isPageCompletelyAnnotated
                  ? notifier.flushCache
                  : null,
              child: const Row(
                children: [
                  Text('Save and Next'),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward),
                ],
              )),
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
                Flexible(
                    flex: 1, child: LeftSidebar(submission: state.submission)),
                const VerticalDivider(
                  color: softBlack,
                ),
                Flexible(flex: 3, child: CommentView(commentSets: current)),
                const SizedBox(width: 8),
              ],
            ),
          ),
          const Divider(
            color: softBlack,
            height: 1,
          ),
          _ProgressIndicator(state),
        ],
      ),
    );
  }
}

class _ProgressIndicator extends ConsumerWidget {
  const _ProgressIndicator(this.state);

  final AnnotatorPageState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalLength = state.length;
    final annotatedLength = state.annotationCount;
    final relativeProgress = annotatedLength / totalLength;
    return LinearProgressIndicator(
      value: relativeProgress,
      minHeight: 20,
    );
  }
}
