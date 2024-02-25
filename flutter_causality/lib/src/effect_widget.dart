import 'package:flutter/widgets.dart';
import 'package:causality/effect.dart';
import 'package:flutter_causality/flutter_causality.dart';

typedef EffectBuilder = Widget Function(Cause? cause);

class EffectWidget extends StatefulWidget {
  const EffectWidget({
    super.key,
    required EffectBuilder builder,
    required List<Type> observedCauseTypes,
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

  @override
  Widget build(BuildContext context) {
    return widget._builder(_cause);
  }
}
