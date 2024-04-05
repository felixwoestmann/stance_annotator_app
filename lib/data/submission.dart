import 'package:annotator_app/data/tree_interface.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'comment.dart';
part 'submission.freezed.dart';
part 'submission.g.dart';

@freezed
class Submission with _$Submission implements TreeNode {
  const factory Submission({
    required String id,
    required String title,
    required int score,
    required String created,
    required String url,
    required String author,
    required List<Comment> branches,
  }) = _Submission;

  factory Submission.fromJson(Map<String, Object?> json) =>
      _$SubmissionFromJson(json);

  const Submission._();

  @override
  List<TreeNode> get nodes => branches;
}
