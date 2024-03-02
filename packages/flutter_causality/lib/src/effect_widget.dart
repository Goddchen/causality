import 'package:causality/causality.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_causality/flutter_causality.dart';

/// Builder method that takes a [Cause] to build a [Widget].
typedef EffectBuilder = Widget Function(Cause? latestCause);

/// A widget that allows you to observe [Cause]s and rebuilds when such a cause
/// is emitted.
///
/// It looks for a [CausalityUniverseWidget] up in the tree.
class EffectWidget extends StatefulWidget {
  /// Create a widget that observes [observedCauseTypes] and uses [builder] to
  /// build a [Widget] when one the causes is emitted.
  ///
  /// If [initCauses] is provided, all those causes are emitted when the
  /// widget's state is initialized.
  const EffectWidget({
    required EffectBuilder builder,
    required List<Type> observedCauseTypes,
    List<Cause> initCauses = const [],
    super.key,
  })  : _builder = builder,
        _initCauses = initCauses,
        _observedCauseTypes = observedCauseTypes;

  final EffectBuilder _builder;
  final List<Type> _observedCauseTypes;
  final List<Cause> _initCauses;

  @override
  State<EffectWidget> createState() => _EffectWidgetState();
}

class _EffectWidgetState extends State<EffectWidget> {
  Cause? _latestCause;

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
          _latestCause = cause;
        });
        return [];
      }).observe(
        widget._observedCauseTypes,
        universe: universe,
      );
      for (final cause in widget._initCauses) {
        cause.emit(universe: universe);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget._builder(_latestCause);
  }
}
