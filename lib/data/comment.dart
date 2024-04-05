import 'package:annotator_app/data/stance_label.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'comment.freezed.dart';
part 'comment.g.dart';

@unfreezed
class Comment with _$Comment {
   factory Comment({
    required final String id,
    required final String score,
    required final String created,
    required final String author,
    required final String body,
    required final List<Comment> branches,
    @Default(false) bool isTopLevel,
    final StanceLabel? stanceOnSubmission,
    final StanceLabel? stanceOnParent,
  }) = _Comment;

  factory Comment.fromJson(Map<String, Object?> json)
  => _$CommentFromJson(json);


}