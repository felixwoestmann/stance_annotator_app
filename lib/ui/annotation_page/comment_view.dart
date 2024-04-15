import 'package:annotator_app/colors.dart';
import 'package:annotator_app/data/comment_set.dart';
import 'package:annotator_app/ui/annotation_page/stance_annotation_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/comment.dart';

class CommentView extends StatefulWidget {
  final List<CommentSet> commentSets;

  const CommentView({super.key, required this.commentSets});

  @override
  State<CommentView> createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: _scrollController,
      itemCount: widget.commentSets.length,
      itemBuilder: (context, index) {
        final commentSet = widget.commentSets[index];
        return switch (commentSet) {
          TopLevelComment topCommentSet =>
            TopLevelCommentView(comment: topCommentSet.comment),
          SubsequentComment subsequentCommentSet => SubsequentCommentView(
              comment: subsequentCommentSet.comment,
              parent: subsequentCommentSet.parent),
        };
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Divider(
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
              const SizedBox(
                  width: 25,
                  height: double.infinity,
                  child: PaintedArrowToParent()),
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

  const CommentDisplay({
    super.key,
    required this.comment,
    this.toBeAnnotated = true,
  });

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
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 6,
                child: Text(
                  comment.body,
                  style: GoogleFonts.roboto(fontSize: 18, color: pureBlack),
                ),
              ),
              const SizedBox(width: 8),
              if (toBeAnnotated)
                StanceAnnotationControls(
                    key: ValueKey(comment.id), comment: comment),
            ],
          ),
        ),
      ),
    );
  }
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
