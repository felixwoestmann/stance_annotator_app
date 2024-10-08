import 'package:annotator_app/ui/annotation_page/annotator_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/comment.dart';
import '../../data/stance_annotation_type.dart';
import '../../data/stance_label.dart';

class StanceAnnotationControls extends StatelessWidget {
  final Comment comment;

  const StanceAnnotationControls({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Stance on the topic: ', style: textStyle),
        _StanceAnnotationButton(
            comment: comment, type: StanceAnnotationType.source),
        if (!comment.isTopLevel) ...[
          const SizedBox(height: 8),
          Text('Stance on the parent: ', style: textStyle),
          _StanceAnnotationButton(
              comment: comment, type: StanceAnnotationType.parent)
        ],
      ],
    );
  }
}

class _StanceAnnotationButton extends ConsumerStatefulWidget {
  final Comment comment;
  final StanceAnnotationType type;

  const _StanceAnnotationButton(
      {required this.comment, required this.type, super.key});

  @override
  ConsumerState<_StanceAnnotationButton> createState() =>
      _StanceAnnotationButtonState();
}

class _StanceAnnotationButtonState
    extends ConsumerState<_StanceAnnotationButton> {
  Set<StanceLabel> selected = {};

  @override
  void initState() {
    super.initState();
    final stanceLabelPresent = ref
        .read(annotatorPageProvider.notifier)
        .getJobForCommentStanceKey(
            (commentId: widget.comment.id, stanceAnnotationType: widget.type));
    if (stanceLabelPresent != null) {
      selected = stanceLabelPresent.toSet;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      emptySelectionAllowed: true,
      multiSelectionEnabled: false,
      segments: [
        ButtonSegment(
            value: StanceLabel.positive,
            label: Text(StanceLabel.positive.toDisplayString(widget.type))),
        ButtonSegment(
            value: StanceLabel.negative,
            label: Text(StanceLabel.negative.toDisplayString(widget.type))),
        ButtonSegment(
            value: StanceLabel.neither,
            label: Text(StanceLabel.neither.toDisplayString(widget.type))),
      ],
      selected: selected,
      showSelectedIcon: false,
      onSelectionChanged: (nowSelectedLabels) async {
        setState(() {
          ref.read(annotatorPageProvider.notifier).addToCache(
            key: (
              commentId: widget.comment.id,
              stanceAnnotationType: widget.type
            ),
            label: nowSelectedLabels.single,
          );
          selected = nowSelectedLabels.single.toSet;
        });
      },
    );
  }
}


extension on StanceLabel? {
  Set<StanceLabel> get toSet => this == null ? {} : {this!};
}
