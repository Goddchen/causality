// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:causality/src/cause.dart';
import 'package:causality/src/effect.dart';
import 'package:fimber/fimber.dart';

class CausalityUniverse {
  Map<Type, List<Effect>> observations = {};

  List<Cause> history = [];

  final List<Completer<void>> _completers = [];

  void disposeEffect(Effect effect) {
    Fimber.d('Disposing $this');
    for (final entry in observations.entries) {
      if (entry.value.remove(effect)) {
        Fimber.d('$this no longer observing ${entry.key}');
      }
    }
  }

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

  Future<void> idle() async {
    await Future.wait(
      _completers
          .where((element) => !element.isCompleted)
          .map((completer) => completer.future),
    );
  }

  void observe({
    required List<Type> causeTypes,
    required Effect effect,
    CausalityUniverse? universe,
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

extension CauseExtension on Cause {
  void emit({required CausalityUniverse universe}) {
    universe.emit(this);
  }
}

extension EffectExtension on Effect {
  void dispose({required CausalityUniverse universe}) {
    universe.disposeEffect(this);
  }

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
