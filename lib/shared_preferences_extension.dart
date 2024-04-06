import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'data/submission.dart';
const String _dataKey = 'submissions_data';

extension SaveSubmission on SharedPreferences {
  Future<void> saveSubmission(Submission submission) {
    final processedSubmission = _prepareSubmission(submission);
    return setString(_dataKey, jsonEncode(processedSubmission.toJson()));
  }

  // This function shall set the isTopLevel for each comment
  Submission _prepareSubmission(Submission submission) {
    for (final branch in submission.branches) {
      branch.isTopLevel = true;
    }
    return submission;
  }

  Submission loadSubmission() {
    final jsonString = getString(_dataKey);
    if (jsonString == null) {
      throw Exception('No data found');
    }
    return Submission.fromJson(jsonDecode(jsonString));
  }


  bool get hasData => containsKey(_dataKey);
}