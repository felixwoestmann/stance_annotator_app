import 'package:annotator_app/annotation_page/comment_view.dart';
import 'package:annotator_app/data/submission.dart';
import 'package:annotator_app/shared_preferences_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_iterator/tree_iterator.dart';

import 'data/comment.dart';
import 'data/comment_set.dart';
import 'data/stance_label.dart';
import 'data/tree_interface.dart';

final submissionProvider =
    NotifierProvider.autoDispose<SubmissionNotifier, Submission>(
  SubmissionNotifier.new,
);

final sharedPreferencesProvider =
    Provider<SharedPreferences>((ref) => throw UnimplementedError());

class SubmissionNotifier extends AutoDisposeNotifier<Submission> {
  late final SharedPreferences sharedPreferences;

  @override
  Submission build() {
    sharedPreferences = ref.read(sharedPreferencesProvider);
    return sharedPreferences.loadSubmission();
  }

  Future<void> updateCommentStance(
      {required String commentId,
      required StanceLabel stanceLabel,
      required StanceAnnotationType stanceAnnotationType}) async {
    bool updateStance(Comment comment) {
      if (comment.id != commentId) {
        return true;
      }

      if (stanceAnnotationType == StanceAnnotationType.source) {
        comment.stanceOnSubmission = stanceLabel;
      } else {
        comment.stanceOnParent = stanceLabel;
      }

      return false;
    }

    final root = state;
    traverseTree<TreeNode>(
        root, (node) => node.nodes, (node) => updateStance(node as Comment));

    state = root.copyWith();
    await sharedPreferences.saveSubmission(root);
  }

  List<CommentSet> generateCommentSets() {
    final root = state;
    final commentSets = <CommentSet>[];

    bool addCommentSet(Comment comment, Comment? parent) {
      final commentSet = parent == null
          ? CommentSet.topLevel(comment: comment)
          : CommentSet.subsequent(comment: comment, parent: parent);

      commentSets.add(commentSet);

      return true;
    }

    traverseTreeWithNodeParent<TreeNode>(root, (node) => node.nodes,
        (node, parent) => addCommentSet(node as Comment, parent as Comment?));

    return commentSets;
  }
}

bool traverseTreeWithNodeParent<N>(N root, GetChildren<N> getChildren,
    ProcessChildWithParent<N> processChildWithParent) {
  for (final child in getChildren(root)) {
    /// we terminate the traversal if [processChild] returns false.
    if (!processChildWithParent(child, root is Submission ? null : root)) {
      return false;
    }

    if (!traverseTreeWithNodeParent(
        child, getChildren, processChildWithParent)) {
      return false;
    }
  }
  return true;
}

typedef ProcessChildWithParent<N> = bool Function(N child, N? parent);
