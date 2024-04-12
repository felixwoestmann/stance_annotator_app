import 'package:freezed_annotation/freezed_annotation.dart';

import 'comment.dart';

part 'comment_set.freezed.dart';

part 'comment_set.g.dart';

/// According to Zubianga 2015a
/// If the Tweet is the source Tweet only it is shown.
/// If the Tweet is a direct descendent of the source Tweet, the tuple is shown.
/// If the Tweet furhter nested in the conversation it is shown as a tripple alongside the source Tweet and its direct parent.
///
/// Since we consider the Post the Source we only have
///   - top level comments showing only the Comment
///   - subsequent comments showing the Comment and its parent
@freezed
sealed class CommentSet with _$CommentSet {
  const CommentSet._();

  bool get isAnnotated {
    if (this is TopLevelComment) {
      return comment.stanceOnSubmission != null;
    } else {
      return comment.stanceOnSubmission != null &&
          (this as SubsequentComment).parent.stanceOnSubmission != null;
    }
  }

  Comment get comment => when(
        topLevel: (comment) => comment,
        subsequent: (comment, _) => comment,
      );

  const factory CommentSet.topLevel({required Comment comment}) =
      TopLevelComment;

  const factory CommentSet.subsequent(
      {required Comment comment, required Comment parent}) = SubsequentComment;

  factory CommentSet.fromJson(Map<String, dynamic> json) =>
      _$CommentSetFromJson(json);
}
