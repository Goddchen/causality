import 'package:causality/causality.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_causality/flutter_causality.dart';

/// Builder method that takes a [Cause] to build a [Widget].
typedef EffectBuilder = Widget Function(Cause? cause);

/// A widget that allows you to observe [Cause]s and rebuilds when such a cause
/// is emitted.
///
/// It looks for a [CausalityUniverseWidget] up in the tree.
class EffectWidget extends StatefulWidget {
  /// Create a widget that observes [observedCauseTypes] and uses [builder] to
  /// build a [Widget] when one the causes is emitted.
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
