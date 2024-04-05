import 'package:freezed_annotation/freezed_annotation.dart';

import 'comment.dart';
part 'comment_set.freezed.dart';
part 'comment_set.g.dart';

@freezed
class CommentSet with _$CommentSet {
  const factory CommentSet({
    required List<Comment> comments,
  }) = _CommentSet;

  factory CommentSet.fromJson(Map<String, Object?> json)
  => _$CommentSetFromJson(json);
}