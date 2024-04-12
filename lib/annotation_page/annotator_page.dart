import 'package:annotator_app/colors.dart';
import 'package:annotator_app/annotator_page_provider.dart';
import 'package:annotator_app/data/annotator_page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'comment_view.dart';
import 'left_siderbar.dart';

const setsPerPage = 3;

class AnnotatorPage extends ConsumerWidget {
  const AnnotatorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(annotatorPageProvider);
    final current = state.unannotatedComments.take(setsPerPage).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Annotation Page",
          style: TextStyle(color: pureWhite),
        ),
        actions: [
          Text('${state.annotationCount} / ${state.length}'),
          const SizedBox(width: 16),
          FilledButton(onPressed: () {}, child: const Text('Next ->')),
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
                Flexible(
                    flex: 3,
                    child: CommentView(
                      key: ObjectKey(state),
                      commentSets: current,
                    )),
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
