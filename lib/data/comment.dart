import 'package:annotator_app/data/stance_label.dart';
import 'package:annotator_app/data/tree_interface.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'comment.freezed.dart';
part 'comment.g.dart';

@unfreezed
class Comment with _$Comment implements TreeNode {
  factory Comment({
    required final String id,
    required final String score,
    required final String created,
    required final String author,
    required final String body,
    required final List<Comment> branches,
    @Default(false) bool isTopLevel,
    StanceLabel? stanceOnSubmission,
    StanceLabel? stanceOnParent,
  }) = _Comment;

  factory Comment.fromJson(Map<String, Object?> json) =>
      _$CommentFromJson(json);

  Comment._();

  @override
  List<TreeNode> get nodes => branches;
}
