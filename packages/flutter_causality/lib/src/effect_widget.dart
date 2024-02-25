// ignore_for_file: public_member_api_docs

import 'package:causality/causality.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_causality/flutter_causality.dart';

typedef EffectBuilder = Widget Function(Cause? cause);

class EffectWidget extends StatefulWidget {
  const EffectWidget({
    required EffectBuilder builder,
    required List<Type> observedCauseTypes,
    super.key,
  })  : _builder = builder,
        _observedCauseTypes = observedCauseTypes;

  final EffectBuilder _builder;
  final List<Type> _observedCauseTypes;

  @override
  State<EffectWidget> createState() => _EffectWidgetState();
}

class _EffectWidgetState extends State<EffectWidget> {
  Cause? _cause;

  @override
  void initState() {
    super.initState();
    final universe = context
        .getInheritedWidgetOfExactType<CausalityUniverseWidget>()
        ?.causalityUniverse;
    assert(
      universe != null,
      'There has to be a CausalityUniverseWidget somewhere in the tree '
      'above this widget!',
    );
    if (universe != null) {
      Effect((cause) {
        setState(() {
          _cause = cause;
        });
        return [];
      }).observe(
        widget._observedCauseTypes,
        universe: universe,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget._builder(_cause);
  }
}
