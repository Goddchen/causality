import 'dart:async';

import 'package:causality/src/cause.dart';

/// Typedef for a method that maps one cause to a list of other causes.
typedef EffectMethod = FutureOr<List<Cause>> Function(Cause cause);

/// An effect is executed when an observed [Cause] is emitted.
class Effect {
  /// Creates an effect with the given `effect`.
  Effect(this.effect);

  /// The method that should be run when an observed [Cause] is emitted.
  final FutureOr<List<Cause>> Function(Cause cause) effect;
}
