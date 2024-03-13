import 'package:causality/causality.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_causality/src/effects/rebuild_effect_widget.dart';
import 'package:flutter_causality/src/universe_widget.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(RebuildEffectWidget, () {
    testWidgets('rebuilds when cause is emitted', (widgetTester) async {
      final causalityUniverse = CausalityUniverse();
      final testCause = Cause();
      final buildCallCauses = <Cause?>[];

      await widgetTester.pumpWidget(
        CausalityUniverseWidget(
          causalityUniverse: causalityUniverse,
          child: RebuildEffectWidget(
            builder: (cause) {
              buildCallCauses.add(cause);
              return const Placeholder();
            },
            observedCauseTypes: [testCause.runtimeType],
          ),
        ),
      );

      testCause.emit(universe: causalityUniverse);
      await causalityUniverse.idle();
      await widgetTester.pumpAndSettle();

      expect(
        buildCallCauses,
        equals([
          null,
          testCause,
        ]),
      );
    });

    testWidgets('throws if universe not found in widget tree',
        (widgetTester) async {
      await widgetTester.pumpWidget(
        RebuildEffectWidget(
          builder: (cause) {
            return const Placeholder();
          },
          observedCauseTypes: const [Cause],
        ),
      );
      expect(
        widgetTester.takeException(),
        isAssertionError,
      );
    });

    testWidgets('disposes internal effect when state is disposed',
        (widgetTester) async {
      final causalityUniverse = CausalityUniverse();
      final testCause = Cause();

      await widgetTester.pumpWidget(
        CausalityUniverseWidget(
          causalityUniverse: causalityUniverse,
          child: RebuildEffectWidget(
            builder: (_) => const Placeholder(),
            observedCauseTypes: [testCause.runtimeType],
          ),
        ),
      );
      await causalityUniverse.idle();
      await widgetTester.pumpAndSettle();

      expect(
        causalityUniverse.observations[testCause.runtimeType],
        hasLength(1),
      );

      await widgetTester.pumpWidget(const Placeholder());
      await widgetTester.pumpAndSettle();

      expect(
        causalityUniverse.observations[testCause.runtimeType],
        isEmpty,
      );
    });

    testWidgets('emits dispose causes when state is disposed',
        (widgetTester) async {
      final causalityUniverse = CausalityUniverse();
      final disposeCauses = <Cause>[
        Cause(),
        Cause(),
        Cause(),
      ];
      final capturedCauses = <Cause>[];

      Effect((cause) {
        capturedCauses.add(cause);
        return [];
      }).observe(
        [Cause],
        universe: causalityUniverse,
      );

      await widgetTester.pumpWidget(
        CausalityUniverseWidget(
          causalityUniverse: causalityUniverse,
          child: RebuildEffectWidget(
            builder: (_) => const Placeholder(),
            disposeCauses: disposeCauses,
            observedCauseTypes: const [],
          ),
        ),
      );
      await causalityUniverse.idle();
      await widgetTester.pumpAndSettle();

      await widgetTester.pumpWidget(const Placeholder());
      await widgetTester.pumpAndSettle();

      expect(capturedCauses, hasLength(disposeCauses.length));
    });

    testWidgets('emits init causes when state is initialized',
        (widgetTester) async {
      final causalityUniverse = CausalityUniverse();
      final initCauses = <Cause>[
        Cause(),
        Cause(),
        Cause(),
      ];
      final capturedCauses = <Cause>[];

      Effect((cause) {
        capturedCauses.add(cause);
        return [];
      }).observe(
        [Cause],
        universe: causalityUniverse,
      );

      await widgetTester.pumpWidget(
        CausalityUniverseWidget(
          causalityUniverse: causalityUniverse,
          child: RebuildEffectWidget(
            builder: (_) => const Placeholder(),
            initCauses: initCauses,
            observedCauseTypes: const [],
          ),
        ),
      );
      await causalityUniverse.idle();
      await widgetTester.pumpAndSettle();

      expect(capturedCauses, hasLength(initCauses.length));
    });
  });
}
