import 'dart:async';

import 'package:causality/causality.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_causality/src/effect_widget.dart';
import 'package:flutter_causality/src/universe_widget.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(EffectWidget, () {
    testWidgets('rebuilds when cause is emitted', (widgetTester) async {
      final causalityUniverse = CausalityUniverse();
      final testCause = Cause();
      final buildCallCauses = <Cause?>[];

      await widgetTester.pumpWidget(
        CausalityUniverseWidget(
          causalityUniverse: causalityUniverse,
          child: EffectWidget(
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
        EffectWidget(
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
  });
}
