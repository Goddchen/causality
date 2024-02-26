import 'dart:async';

import 'package:causality/src/cause.dart';
import 'package:causality/src/effect.dart';
import 'package:fimber/fimber.dart';

/// A universe in which causes and effects are managed.
class CausalityUniverse {
  /// A list of all effects that are observing causes.
  Map<Type, List<Effect>> observations = {};

  /// A history of all causes that were emitted in this universe.
  List<Cause> history = [];

  final List<Completer<void>> _completers = [];

  /// Disposes an effect and removes all occurences from [observations].
  void disposeEffect(Effect effect) {
    Fimber.d('Disposing $this');
    for (final entry in observations.entries) {
      if (entry.value.remove(effect)) {
        Fimber.d('$this no longer observing ${entry.key}');
      }
    }
    _cleanupObservations();
  }

  void _cleanupObservations() {
    observations.removeWhere((_, value) => value.isEmpty);
  }

  /// Emits this cause and triggers all observing effects.
  void emit(Cause cause) {
    Fimber.d('emitting $cause');
    history.add(cause);
    observations[cause.runtimeType]?.forEach(
      (effect) async {
        Fimber.d('$cause triggers $effect');
        final completer = Completer<void>();
        _completers.add(completer);
        final resultCauses = await effect.effect(cause);
        completer.complete();
        _completers.remove(completer);
        Fimber.d('$effect results in $resultCauses');
        for (final cause in resultCauses) {
          cause.emit(universe: this);
        }
      },
    );
  }

  /// Wait until all pending effects have been triggered and finished running.
  Future<void> idle() async {
    await Future.wait(
      _completers
          .where((element) => !element.isCompleted)
          .map((completer) => completer.future),
    );
  }

  /// Adds an [Effect] observing a [Cause] to [observations].
  void observe({
    required List<Type> causeTypes,
    required Effect effect,
  }) {
    Fimber.d('$effect observing $causeTypes');
    for (final type in causeTypes) {
      observations.update(
        type,
        (value) => value..add(effect),
        ifAbsent: () => [effect],
      );
    }
  }
}

/// Extensions on [Cause].
extension CauseExtension on Cause {
  /// Emit this cause in [universe].
  void emit({required CausalityUniverse universe}) {
    universe.emit(this);
  }
}

/// Extensions on [Effect].
extension EffectExtension on Effect {
  /// Dispose all observations of this effect in [universe].
  void dispose({required CausalityUniverse universe}) {
    universe.disposeEffect(this);
  }

  /// Observe [types] in [universe].
  void observe(
    List<Type> types, {
    required CausalityUniverse universe,
  }) {
    universe.observe(
      causeTypes: types,
      effect: this,
    );
  }
}
