import 'package:annotator_app/colors.dart';
import 'package:annotator_app/data/submission.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'comment_view.dart';
import 'left_siderbar.dart';

class AnnotatorPage extends ConsumerStatefulWidget {
  final Submission submission;

  const AnnotatorPage({super.key, required this.submission});

  @override
  ConsumerState<AnnotatorPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends ConsumerState<AnnotatorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Annotate",style: TextStyle(color: pureWhite),),
        backgroundColor: softBlack,
        foregroundColor: pureWhite,
      ),
      body: Column(
        children: [
          const SizedBox(height: 8,),
          Expanded(
            child: Row(
              children: [
                Flexible(flex:1,child: LeftSidebar(submission: widget.submission)),
                const VerticalDivider(color: softBlack,),
                Flexible(
                  flex: 3,
                    child: CommentView(comments: widget.submission.branches)),
              ],
            ),
          ),
          const Divider(color: softBlack,),
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

