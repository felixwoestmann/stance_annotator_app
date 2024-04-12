import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'data/submission.dart';

const String _submissionDataKey = 'submissions_data';

extension HandleSubmission on SharedPreferences {
  Future<void> saveSubmission(Submission? submission) {
    print("Saving submission update to LocalStorage");
    if (submission == null) {
      return Future.value();
    }

    return setString(_submissionDataKey, jsonEncode(submission.toJson()));
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
