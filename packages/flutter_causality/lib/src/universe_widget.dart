import 'package:causality/causality.dart';
import 'package:flutter/widgets.dart';

/// Places a [CausalityUniverse] in the widget tree.
class CausalityUniverseWidget extends InheritedWidget {
  /// Creates a widget that manages a [CausalityUniverse] and provides it to
  /// its children.
  const CausalityUniverseWidget({
    required this.causalityUniverse,
    required super.child,
    super.key,
  });

  /// The universe that is managed and provided by this widget.
  final CausalityUniverse causalityUniverse;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

  /// Check the widget tree for an existing [CausalityUniverseWidget].
  static CausalityUniverseWidget? maybeOf(BuildContext context) {
    return context.getInheritedWidgetOfExactType<CausalityUniverseWidget>();
  }
}
