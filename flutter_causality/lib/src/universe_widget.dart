import 'package:causality/effect.dart';
import 'package:flutter/widgets.dart';

class CausalityUniverseWidget extends InheritedWidget {
  final CausalityUniverse causalityUniverse;

  const CausalityUniverseWidget({
    super.key,
    required this.causalityUniverse,
    required super.child,
  });

  static CausalityUniverseWidget? maybeOf(BuildContext context) {
    return context.getInheritedWidgetOfExactType<CausalityUniverseWidget>();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
