import 'package:effect/src/effect.dart';
import 'package:effect/src/either.dart';
import 'package:test/test.dart';

void main() {
  group(
    Effect,
    () {
      group(
        'fail',
        () {
          test(
            'returns error when run',
            () {
              final expectedException = Exception('Test');
              final effect = Effect<void, bool, Object>.fail(expectedException);

              final result = effect.runSync();

              expect(
                result,
                equals(Either<bool, Object>.error(expectedException)),
              );
            },
          );
        },
      );

      group(
        'runSync',
        () {
          test(
            'runs synchronous and returns value',
            () {
              final effect = Effect<void, bool, Object>.succeed(true);
              final result = effect.runSync();
              expect(result, equals(const Either<bool, Object>.success(true)));
            },
          );
        },
      );

      group(
        'succeed',
        () {
          test(
            'returns value when run',
            () {
              const expectedValue = true;
              final effect = Effect<void, bool, Object>.succeed(expectedValue);

              final result = effect.runSync();

              expect(
                result,
                equals(const Either<bool, Object>.success(expectedValue)),
              );
            },
          );
        },
      );

      group(
        'tryCatch',
        () {
          test(
            'returns value when successful',
            () {
              const expectedValue = true;
              final effect =
                  Effect<void, bool, Object>.tryCatch((_) => expectedValue);

              final result = effect.runSync();

              expect(
                result,
                equals(const Either<bool, Object>.success(expectedValue)),
              );
            },
          );

          test(
            'returns error on throw',
            () {
              final expectedException = Exception('Test');
              final effect = Effect<void, bool, Object>.tryCatch(
                (_) => throw expectedException,
              );

              final result = effect.runSync();

              expect(
                result,
                equals(Either<bool, Object>.error(expectedException)),
              );
            },
          );

          test(
            'preserves context when run',
            () {
              const expectedRequirement = 'Test';
              String? foundRequirement;

              Effect<String, bool, Object>.tryCatch(
                (context) {
                  foundRequirement = context.requirements;
                  return true;
                },
                expectedRequirement,
              ).runSync();

              expect(
                foundRequirement,
                equals(expectedRequirement),
              );
            },
          );
        },
      );
    },
  );
}
