import 'package:annotator_app/data/comment_set.dart';
import 'package:annotator_app/shared_preferences_extension.dart';
import 'package:annotator_app/submission_provider.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commentSetProvider =
    NotifierProvider.autoDispose<CommentSetNotifier, List<CommentSet>>(
  CommentSetNotifier.new,
);

const setsPerPage = 3;

class CommentSetNotifier extends AutoDisposeNotifier<List<CommentSet>> {
  @override
  List<CommentSet> build() {
    return ref.read(sharedPreferencesProvider).hasCommentSetData
        ? ref.read(sharedPreferencesProvider).loadCommentSet()
        : ref.read(submissionProvider.notifier).generateCommentSets();
  }

  int get length => state.length;

  int get annotationCount {
    return state.where((commentSet) => commentSet.isAnnotated).length;
  }

  List<CommentSet> get current => state
      .whereNot((commentSet) => commentSet.isAnnotated)
      .take(setsPerPage)
      .toList();
}
