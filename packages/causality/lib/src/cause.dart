import 'package:clock/clock.dart';
import 'package:equatable/equatable.dart';

/// A cause can be observed by multiple effects and be the result of an effect.
class Cause extends Equatable {
  /// Creates a effect that has a timestamp of `clock.now()`.
  Cause() : timestamp = clock.now();

  /// The time at which the cause happened.
  final DateTime timestamp;

  @override
  List<Object?> get props => [timestamp];

  @override
  bool? get stringify => true;
}
