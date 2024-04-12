import 'package:annotator_app/data/submission.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'comment_set.dart';

part 'annotator_page_state.freezed.dart';

@freezed
class AnnotatorPageState with _$AnnotatorPageState {
  const AnnotatorPageState._();

  factory AnnotatorPageState({
    required final Submission submission,
    required final List<CommentSet> annotatedComments,
    required final List<CommentSet> unannotatedComments,
  }) = _AnnotatorPageState;
}
