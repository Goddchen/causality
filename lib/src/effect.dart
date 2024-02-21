// ignore_for_file: public_member_api_docs

import 'package:effect/src/either.dart';
import 'package:equatable/equatable.dart';

class Context<Requirements> extends Equatable {
  const Context(this.requirements);

  final Requirements? requirements;

  @override
  List<Object?> get props => [requirements];
}

class Effect<Requirements, Success, Error> extends Equatable {
  factory Effect.fail(Error fail) => Effect._(() => Either.error(fail));
  factory Effect.succeed(Success success) =>
      Effect._(() => Either.success(success));
  factory Effect.tryCatch(
    Success Function(Context<Requirements?> context) tryCatch, [
    Requirements? requirements,
  ]) =>
      Effect._(
        () {
          try {
            return Either.success(tryCatch(Context(requirements)));
          } catch (e) {
            return Either.error(e as Error);
          }
        },
        requirements,
      );

  const Effect._(
    this._effect, [
    this._requirements,
  ]);

  final Either<Success, Error> Function() _effect;
  final Requirements? _requirements;

  @override
  List<Object?> get props => [_requirements];

  Either<Success, Error> runSync() => _effect();
}
