import 'data/comment_set.dart';
import 'data/submission.dart';

class CommentSetGenerator {
  final Submission submission;

  CommentSetGenerator(this.submission);

  /// Simplest strategy to generate comment sets. Just take everz branch of the discussion as a comment set.
  List<CommentSet> generateUsingBranches() {
    final commentSets = <CommentSet>[];

    for (final branch in submission.branches) {
      commentSets.add(CommentSet(comments: [branch]));
    }

    return commentSets;
  }
}
