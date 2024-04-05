import 'package:annotator_app/colors.dart';
import 'package:annotator_app/data/stance_label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/comment.dart';

class CommentView extends StatefulWidget {
  final List<Comment> comments;

  const CommentView({super.key, required this.comments});

  @override
  State<CommentView> createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
  late final TreeController<Comment> _controller;

  @override
  void initState() {
    super.initState();
    _controller = TreeController<Comment>(
      childrenProvider: (comment) => comment.branches,
      roots: widget.comments,
    )..expandAll();
  }

  @override
  Widget build(BuildContext context) {
    return TreeView(
      treeController: _controller,
      padding: const EdgeInsets.only(top: 8, right: 8),
      nodeBuilder: (BuildContext context, TreeEntry<Comment> entry) {
        return TreeIndentation(
          entry: entry,
          guide: const IndentGuide.connectingLines(
            color: softBlack,
            padding: EdgeInsets.zero,
          ),
          child: BranchDisplay(comment: entry.node),
        );
      },
    );
  }
}

class BranchDisplay extends StatelessWidget {
  final Comment comment;

  const BranchDisplay({super.key, required this.comment});

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
              Flexible(
                  flex: 3,
                  child: Column(
                    children: [
                      const Text(
                        'Comments stance on the topic: ',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      _StanceAnnotationButton(comment: comment),
                      if (!comment.isTopLevel) ...[
                        const SizedBox(height: 8),
                        const Text(
                          'Comments stance on the parent: ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        _StanceAnnotationButton(comment: comment)
                      ],
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class _StanceAnnotationButton extends StatefulWidget {
  final Comment comment;

  const _StanceAnnotationButton({super.key, required this.comment});

  @override
  State<_StanceAnnotationButton> createState() =>
      _StanceAnnotationButtonState();
}

class _StanceAnnotationButtonState extends State<_StanceAnnotationButton> {
  late Set<StanceLabel> _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.comment.stanceOnParent == null
        ? {}
        : {widget.comment.stanceOnParent!};
  }

  @override
  Widget build(BuildContext context) {
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
      selected: _selected,
      onSelectionChanged: (nowSelectedLabels) {
        setState(() {
          _selected = nowSelectedLabels;
        });
        //final optionalSelection = nowSelectedLabels.singleOrNull;
      },
    );
  }
}
