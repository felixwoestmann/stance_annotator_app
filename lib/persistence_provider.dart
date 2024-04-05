import 'dart:convert';

import 'package:annotator_app/data/submission.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _dataKey = 'submissions_data';

final persistenceProvider =
    Provider((ref) => Persistence(ref.watch(sharedPreferencesProvider)));

final sharedPreferencesProvider =
    Provider<SharedPreferences>((ref) => throw UnimplementedError());

class Persistence {
  final SharedPreferences sharedPreferences;

  Persistence(this.sharedPreferences);

  Future<void> saveData(Submission submission) {
    final processedSubmission=_prepareSubmission(submission);
    return sharedPreferences.setString(_dataKey, jsonEncode(processedSubmission.toJson()));
  }

  // This function shall set the isTopLevel for each comment
  Submission _prepareSubmission(Submission submission) {
    for (final branch in submission.branches){
      branch.isTopLevel=true;
    }

    return submission;
  }

  Submission? loadData() {
    final jsonString = sharedPreferences.getString(_dataKey);
    if (jsonString == null) {
      return null;
    }
    return Submission.fromJson(jsonDecode(jsonString));
  }
}

