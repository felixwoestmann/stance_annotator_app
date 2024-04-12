import 'package:annotator_app/data/comment_set.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'comment.dart';

part 'comment_sets_wrapper.freezed.dart';

part 'comment_sets_wrapper.g.dart';

@freezed
class CommentSetWrapper with _$CommentSetWrapper {
  const factory CommentSetWrapper({required List<CommentSet> commentSets}) =
      _CommentSetWrapper;

  const CommentSetWrapper._();

  factory CommentSetWrapper.fromJson(Map<String, dynamic> json) =>
      _$CommentSetWrapperFromJson(json);
}
