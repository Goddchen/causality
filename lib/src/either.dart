// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';

class Either<Success, Error> extends Equatable {
  const Either.success(
    Success this._success,
  ) : _error = null;
  const Either.error(Error this._error) : _success = null;

  final Success? _success;

  final Error? _error;

  @override
  List<Object?> get props => [
        _success,
        _error,
      ];

  Either<NewSuccess, Error> flatMap<NewSuccess>(
    Either<NewSuccess, Error> Function(Success value) mapper,
  ) =>
      match(
        (success) => mapper(success),
        Either.error,
      );

  Either<NewSuccess, Error> map<NewSuccess>(
    NewSuccess Function(Success value) mapper,
  ) =>
      match(
        (success) => Either.success(mapper(success)),
        Either.error,
      );

  Result match<Result>(
    Result Function(Success success) onSuccess,
    Result Function(Error error) onError,
  ) {
    if (_success != null) {
      return onSuccess(_success);
    } else if (_error != null) {
      return onError(_error);
    }
    throw Exception('Either success or error has to be set');
  }
}
