import 'package:effect/src/either.dart';
import 'package:test/test.dart';

void main() {
  group(
    Either,
    () {
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
