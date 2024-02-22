import 'package:effect/src/either.dart';
import 'package:test/test.dart';

void main() {
  group(
    Either,
    () {
      group(
        'flatMap',
        () {
          test(
            'maps correctly',
            () async {
              const Either<bool, Object>.success(true)
                  .flatMap<String>(
                    (value) => Either<String, Object>.success(value.toString()),
                  )
                  .match(
                    (success) => expect(success, equals('true')),
                    (error) => fail('Should not call onError'),
                  );
            },
          );

          test(
            'propagates error correctly',
            () async {
              final expectedException = Exception('Test');
              Either<bool, Object>.error(expectedException)
                  .flatMap<String>(
                    (value) => Either<String, Object>.success(value.toString()),
                  )
                  .match(
                    (success) => fail('Should not call onSuccess'),
                    (error) => expect(error, equals(expectedException)),
                  );
            },
          );
        },
      );

      group(
        'map',
        () {
          test(
            'maps correctly',
            () async {
              const Either<bool, Object>.success(true)
                  .map((value) => value.toString())
                  .match(
                    (success) => expect(success, equals('true')),
                    (error) => fail('Should not call onError'),
                  );
            },
          );

          test(
            'propagates error correctly',
            () async {
              final expectedException = Exception('Test');
              Either<bool, Object>.error(expectedException)
                  .map((value) => value.toString())
                  .match(
                    (success) => fail('Should not call onSuccess'),
                    (error) => expect(error, equals(expectedException)),
                  );
            },
          );
        },
      );
      group(
        'match',
        () {
          test(
            'calls onSuccess on success',
            () {
              const expectedValue = true;
              const Either<bool, Object>.success(expectedValue).match(
                (success) => expect(success, equals(expectedValue)),
                (_) => fail('Should not call onError'),
              );
            },
          );

          test(
            'calls onError on error',
            () {
              final expectedException = Exception('Error');
              Either<bool, Object>.error(expectedException).match(
                (_) => fail('Should not call onSuccess'),
                (error) => expect(error, equals(expectedException)),
              );
            },
          );
        },
      );
    },
  );
}
