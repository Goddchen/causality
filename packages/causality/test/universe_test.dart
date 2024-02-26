import 'package:causality/src/cause.dart';
import 'package:causality/src/effect.dart';
import 'package:causality/src/universe.dart';
import 'package:test/test.dart';

void main() {
  group(CausalityUniverse, () {
    late CausalityUniverse causalityUniverse;

    setUp(() {
      causalityUniverse = CausalityUniverse();
    });

    group('disposeEffect', () {
      test('disposes effect', () {
        final testCause = Cause();
        final testEffect = Effect((_) => []);

        causalityUniverse
          ..observations = {
            testCause.runtimeType: [
              testEffect,
            ],
          }
          ..disposeEffect(testEffect);

        expect(causalityUniverse.observations, isEmpty);
      });
    });

    group('emit', () {
      test('calls observers', () {
        var hasBeenCalled = false;
        final testCause = Cause();
        final testEffect = Effect((_) {
          hasBeenCalled = true;
          return [];
        });

        causalityUniverse
          ..observations = {
            testCause.runtimeType: [
              testEffect,
            ],
          }
          ..emit(testCause);

        expect(hasBeenCalled, isTrue);
      });
    });

    group('observe', () {
      test('registers observer', () {
        final testCause = Cause();
        final testEffect = Effect((_) => []);

        causalityUniverse.observe(
          causeTypes: [testCause.runtimeType],
          effect: testEffect,
        );

        expect(
          causalityUniverse.observations,
          containsPair(testCause.runtimeType, [testEffect]),
        );
      });
    });
  });
}
