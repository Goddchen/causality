import 'dart:async';

import 'package:causality/causality.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_causality/src/universe_widget.dart';

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
  ///
  /// If [disposeCauses] is provided, all those causes are emitted when the
  /// widget's state is disposed.
  const EffectWidget({
    required EffectBuilder builder,
    required List<Type> observedCauseTypes,
    List<Cause> disposeCauses = const [],
    List<Cause> initCauses = const [],
    super.key,
  })  : _builder = builder,
        _disposeCauses = disposeCauses,
        _initCauses = initCauses,
        _observedCauseTypes = observedCauseTypes;
  final EffectBuilder _builder;

  final List<Cause> _disposeCauses;
  final List<Cause> _initCauses;
  final List<Type> _observedCauseTypes;

  @override
  State<EffectWidget> createState() => _EffectWidgetState();
}

class _EffectWidgetState extends State<EffectWidget> {
  _EffectWidgetState() {
    _effect = Effect((cause) {
      if (mounted) {
        setState(() {
          _latestCause = cause;
        });
      }
      return [];
    });
  }

  CausalityUniverse? _causalityUniverse;
  Effect? _effect;
  Cause? _latestCause;

  @override
  Widget build(BuildContext context) {
    return widget._builder(_latestCause);
  }

  @override
  void dispose() {
    super.dispose();
    if (_causalityUniverse case final CausalityUniverse universe) {
      scheduleMicrotask(() {
        for (final cause in widget._disposeCauses) {
          cause.emit(universe: universe);
        }
        _effect?.dispose(universe: universe);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _causalityUniverse = context
        .getInheritedWidgetOfExactType<CausalityUniverseWidget>()
        ?.causalityUniverse;
    assert(
      _causalityUniverse != null,
      'There has to be a CausalityUniverseWidget somewhere in the tree '
      'above this widget!',
    );
    if (_causalityUniverse case final CausalityUniverse universe) {
      _effect?.observe(
        widget._observedCauseTypes,
        universe: universe,
      );
      for (final cause in widget._initCauses) {
        cause.emit(universe: universe);
      }
    }
  }
}
