import 'dart:async';

import 'package:annotator_app/data/annotator_page_state.dart';
import 'package:annotator_app/data/comment.dart';
import 'package:annotator_app/data/comment_set.dart';
import 'package:annotator_app/submission_repository.dart';
import 'package:annotator_app/tree_helper.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/stance_annotation_type.dart';
import '../../data/stance_label.dart';
import '../../data/submission.dart';
import '../../data/tree_interface.dart';

const setsPerPage = 3;

final annotatorPageProvider =
    NotifierProvider.autoDispose<AnnotatorPageProvider, AnnotatorPageState>(
  AnnotatorPageProvider.new,
);

class AnnotatorPageProvider extends AutoDisposeNotifier<AnnotatorPageState> {
  @override
  AnnotatorPageState build() {
    _submissionRepository = ref.read(submissionRepositoryProvider);
    _submissionListener =
        _submissionRepository.stream.listen(_onSubmissionChange);

    ref.onDispose(() async => _submissionListener.cancel());

    final currentSubmission = _submissionRepository.submission;

    if (currentSubmission == null) {
      throw StateError('Submission is null');
    }

    return AnnotationPageStateExtension.fromSubmission(currentSubmission);
  }

  late final StreamSubscription<Submission?> _submissionListener;
  late final SubmissionRepository _submissionRepository;

  void _onSubmissionChange(Submission? submission) {
    print('Updating state with new submission');
    if (submission == null) {
      return;
    }
    state = AnnotationPageStateExtension.fromSubmission(submission);
  }

  int get annotationCount => state.annotationCount;

  int get totalPageCount => (state.length / setsPerPage).ceil();

  int get currentPage => (state.annotationCount / setsPerPage).ceil();

  List<CommentSet> get current {
    return state.unannotatedComments.take(setsPerPage).toList();
  }

  void reset() {
    _submissionRepository.submission = null;
  }

  bool get isPageCompletelyAnnotated {
    for (final commentSet in current) {
      final commentId = commentSet.comment.id;

      if (!state.updateCommentJobs.containsKey((
        commentId: commentId,
        stanceAnnotationType: StanceAnnotationType.source
      ))) {
        return false;
      }

      if (commentSet is SubsequentComment &&
          !state.updateCommentJobs.containsKey((
            commentId: commentId,
            stanceAnnotationType: StanceAnnotationType.parent
          ))) {
        return false;
      }
    }

    return true;
  }

  void addToCache({required CommentStanceKey key, required StanceLabel label}) {
    print('Adding job for ${key.commentId} to cache');

    final mapCopy = Map.of(state.updateCommentJobs);
    mapCopy.update(key, (value) => label, ifAbsent: () => label);
    state = state.copyWith(updateCommentJobs: mapCopy);
  }

  void flushCache() {
    _submissionRepository.updateCommentStances(state.updateCommentJobs);
    state = state.copyWith(updateCommentJobs: {});
  }

  StanceLabel? getJobForCommentStanceKey(CommentStanceKey key) {
    return state.updateCommentJobs[key];
  }
}

extension on Submission {
  List<CommentSet> get commentSets {
    final root = this;
    final commentSets = <CommentSet>[];

    /// Use local function to add comment sets to the list.
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

extension AnnotationPageStateExtension on AnnotatorPageState {
  static AnnotatorPageState fromSubmission(Submission submission) {
    final commentSets = submission.commentSets;
    final annotatedComments =
        commentSets.where((commentSet) => commentSet.isAnnotated).toList();
    final unannotatedComments =
        commentSets.whereNot((commentSet) => commentSet.isAnnotated).toList();

    return AnnotatorPageState(
      submission: submission,
      annotatedComments: annotatedComments,
      unannotatedComments: unannotatedComments,
    );
  }

  int get length => annotatedComments.length + unannotatedComments.length;

  int get annotationCount => annotatedComments.length;
}
