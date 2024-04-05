import 'dart:convert';

import 'package:annotator_app/data/submission.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_iterator/tree_iterator.dart';

import 'data/comment.dart';
import 'data/tree_interface.dart';

const String _dataKey = 'submissions_data';

final persistenceProvider =
    Provider((ref) => Persistence(ref.watch(sharedPreferencesProvider)));

final sharedPreferencesProvider =
    Provider<SharedPreferences>((ref) => throw UnimplementedError());

class Persistence {
  final SharedPreferences sharedPreferences;

  Persistence(this.sharedPreferences);

  Future<void> saveData(Submission submission) {
    final processedSubmission = _prepareSubmission(submission);
    return sharedPreferences.setString(
        _dataKey, jsonEncode(processedSubmission.toJson()));
  }

  // This function shall set the isTopLevel for each comment
  Submission _prepareSubmission(Submission submission) {
    for (final branch in submission.branches) {
      branch.isTopLevel = true;
    }

    return submission;
  }

  void updateCommentStance(Comment comment) {
    final root = loadData();
    findInTree<TreeNode>(root, (node) => node.nodes,
        (node) => (node as Comment).id == comment.id);
  }

  bool get hasData {
    return sharedPreferences.containsKey(_dataKey);
  }

  Submission loadData() {
    final jsonString = sharedPreferences.getString(_dataKey);
    if (jsonString == null) {
      throw Exception('No data found');
    }
    return Submission.fromJson(jsonDecode(jsonString));
  }
}
