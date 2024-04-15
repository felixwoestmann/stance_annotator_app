import 'dart:async';

import 'package:annotator_app/shared_preferences_extension.dart';
import 'package:annotator_app/ui/annotation_page/stance_annotation_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_iterator/tree_iterator.dart';

import 'data/annotator_page_state.dart';
import 'data/comment.dart';
import 'data/stance_label.dart';
import 'data/submission.dart';
import 'data/tree_interface.dart';
import 'dart:html' as html;

final submissionRepositoryProvider =
    Provider<SubmissionRepository>((ref) => SubmissionRepository());

class SubmissionRepository {
  SubmissionRepository() {
    _submission = BehaviorSubject.seeded(null);
    _prefListener = _submission.listen(_prefs.saveSubmission);
  }

  late final StreamSubscription<Submission?> _prefListener;
  final SharedPreferences _prefs = GetIt.instance.get<SharedPreferences>();
  late final BehaviorSubject<Submission?> _submission;

  Stream<Submission?> get stream => _submission.stream;

  set submission(Submission? submission) {
    _submission.value = submission;
    if (submission == null) {
      Future.microtask(() {
        html.window.location.reload();
      });
    }
  }

  Submission? get submission => _submission.value;

  Submission _updateCommentStance(
      Submission originalSubmission, CommentStanceKey key, StanceLabel label) {
    /// Use a local function to process each comment and comply with the interface while still being able to access the commentId and stanceLabel.
    bool updateStance(Comment comment) {
      if (comment.id != key.commentId) {
        return true;
      }

      if (key.stanceAnnotationType == StanceAnnotationType.source) {
        comment.stanceOnSubmission = label;
      } else {
        comment.stanceOnParent = label;
      }
      print("Updated comment ${comment.id}");
      return false;
    }

    final root = originalSubmission;
    traverseTree<TreeNode>(
        root, (node) => node.nodes, (node) => updateStance(node as Comment));

    return root;
  }

  void updateCommentStances(Map<CommentStanceKey, StanceLabel> jobs) {
    final completelyUpdatedSubmission = jobs.entries.fold(
        submission!,
        (previousValue, element) =>
            _updateCommentStance(previousValue, element.key, element.value));
    submission = completelyUpdatedSubmission.copyWith();
  }

  void dispose() {
    _prefListener.cancel();
    _submission.close();
  }
}
