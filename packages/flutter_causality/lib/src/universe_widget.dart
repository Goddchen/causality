// ignore_for_file: public_member_api_docs

import 'package:causality/causality.dart';
import 'package:flutter/widgets.dart';

class CausalityUniverseWidget extends InheritedWidget {
  const CausalityUniverseWidget({
    required this.causalityUniverse,
    required super.child,
    super.key,
  });

  final CausalityUniverse causalityUniverse;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

  static CausalityUniverseWidget? maybeOf(BuildContext context) {
    return context.getInheritedWidgetOfExactType<CausalityUniverseWidget>();
  }
}
