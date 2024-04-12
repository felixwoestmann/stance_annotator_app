import 'package:tree_iterator/tree_iterator.dart';

import 'data/submission.dart';

typedef ProcessChildWithParent<N> = bool Function(N child, N? parent);

/// For each iteration in its traversal the process Child function is called with the node and its parent.
/// This serves to allow the processChild function to have access to the parent node.
/// Used for creation of Comment Sets.
bool traverseTreeWithNodeParent<N>(
  N root,
  GetChildren<N> getChildren,
  ProcessChildWithParent<N> processChildWithParent,
) {
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
