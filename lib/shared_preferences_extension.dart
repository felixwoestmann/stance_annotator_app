import 'dart:convert';

import 'package:annotator_app/data/comment_sets_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/comment_set.dart';
import 'data/submission.dart';
const String _submissionDataKey = 'submissions_data';
const String _commentSetDataKey = 'comment_set_data';

extension HandleSubmission on SharedPreferences {
  Future<void> saveSubmission(Submission submission) {
    final processedSubmission = _prepareSubmission(submission);
    return setString(_submissionDataKey, jsonEncode(processedSubmission.toJson()));
  }

  // This function shall set the isTopLevel for each comment
  Submission _prepareSubmission(Submission submission) {
    for (final branch in submission.branches) {
      branch.isTopLevel = true;
    }
    return submission;
  }

  Submission loadSubmission() {
    final jsonString = getString(_submissionDataKey);
    if (jsonString == null) {
      throw Exception('No data found');
    }
    return Submission.fromJson(jsonDecode(jsonString));
  }


  bool get hasSubmissionData => containsKey(_submissionDataKey);
}

extension HandleCommentSet on SharedPreferences {
  Future<void> saveCommentSet(List<CommentSet> commentSets) {
    return setString(_commentSetDataKey, jsonEncode(CommentSetWrapper(commentSets: commentSets).toJson()));
  }

  List<CommentSet> loadCommentSet() {
    final jsonString = getString(_commentSetDataKey);
    if (jsonString == null) {
      throw Exception('No data found');
    }
    return CommentSetWrapper.fromJson(jsonDecode(jsonString)).commentSets;
  }

  bool get hasCommentSetData => containsKey(_commentSetDataKey);
}