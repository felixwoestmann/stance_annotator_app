import 'package:annotator_app/colors.dart';
import 'package:annotator_app/data/comment_set.dart';
import 'package:annotator_app/data/stance_label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/comment.dart';

class CommentView extends StatelessWidget {
  final List<CommentSet> commentSets;

  const CommentView({super.key, required this.commentSets});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: commentSets.length,
      itemBuilder: (context, index) {
        final commentSet = commentSets[index];
        return switch (commentSet) {
          TopLevelComment topCommentSet =>
            TopLevelCommentView(comment: topCommentSet.comment),
          SubsequentComment subsequentCommentSet => SubsequentCommentView(
              comment: subsequentCommentSet.comment,
              parent: subsequentCommentSet.parent),
        };
      },
      separatorBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: const Divider(
            color: softBlack,
            height: 1,
          ),
        );
      },
    );
  }
}

class TopLevelCommentView extends StatelessWidget {
  final Comment comment;

  const TopLevelCommentView({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return CommentDisplay(comment: comment);
  }
}

class SubsequentCommentView extends StatelessWidget {
  final Comment comment;
  final Comment parent;

  const SubsequentCommentView(
      {super.key, required this.comment, required this.parent});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommentDisplay(comment: parent, toBeAnnotated: false),
        IntrinsicHeight(
          child: Row(
            children: [
              SizedBox(
                  width: 25,
                  height: double.infinity,
                  child: const PaintedArrowToParent()),
              Expanded(child: CommentDisplay(comment: comment))
            ],
          ),
        ),
      ],
    );
  }
}

class CommentDisplay extends StatelessWidget {
  final Comment comment;
final bool toBeAnnotated;
  const CommentDisplay({super.key, required this.comment, this.toBeAnnotated=true,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 6,
                child: Text(
                  comment.body,
                  style: GoogleFonts.roboto(fontSize: 18, color: pureBlack),
                ),
              ),
              if (toBeAnnotated)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Comments stance on the topic: ',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  _StanceAnnotationButton(
                      comment: comment, type: StanceAnnotationType.source),
                  if (!comment.isTopLevel) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Comments stance on the parent: ',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    _StanceAnnotationButton(
                        comment: comment, type: StanceAnnotationType.parent)
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StanceAnnotationButton extends ConsumerWidget {
  final Comment comment;
  final StanceAnnotationType type;

  const _StanceAnnotationButton({required this.comment, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SegmentedButton(
      emptySelectionAllowed: true,
      multiSelectionEnabled: false,
      segments: [
        ButtonSegment(
            value: StanceLabel.agrees, label: Text(StanceLabel.agrees.value)),
        ButtonSegment(
            value: StanceLabel.disagrees,
            label: Text(StanceLabel.disagrees.value)),
        ButtonSegment(
            value: StanceLabel.neither, label: Text(StanceLabel.neither.value)),
      ],
      showSelectedIcon: false,
      selected: type == StanceAnnotationType.source
          ? comment.stanceOnSubmission.toSet
          : comment.stanceOnParent.toSet,
      onSelectionChanged: (nowSelectedLabels) async {
        // await ref.read(submissionProvider.notifier).updateCommentStance(
        //     commentId: comment.id,
        //     stanceLabel: nowSelectedLabels.first,
        //     stanceAnnotationType: type);
      },
    );
  }
}

enum StanceAnnotationType { source, parent }

extension on StanceLabel? {
  Set<StanceLabel> get toSet => this == null ? {} : {this!};
}

class PaintedArrowToParent extends StatelessWidget {
  const PaintedArrowToParent({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ArrowPainter(),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = softBlack
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(size.width / 3, size.height / 2)
      ..lineTo(size.width / 3, 0)
      ..moveTo(size.width / 3, size.height / 2)
      ..lineTo(size.width, size.height / 2);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
