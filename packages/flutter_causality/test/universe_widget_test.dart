import 'package:causality/causality.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_causality/src/universe_widget.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(CausalityUniverseWidget, () {
    testWidgets('can be found up in the tree', (widgetTester) async {
      final causalityUniverse = CausalityUniverse();

      await widgetTester.pumpWidget(
        CausalityUniverseWidget(
          causalityUniverse: causalityUniverse,
          child: Builder(
            builder: (context) {
              final causalityUniverseWidget =
                  CausalityUniverseWidget.maybeOf(context);
              expect(
                causalityUniverseWidget?.causalityUniverse,
                equals(causalityUniverse),
              );
              return const Placeholder();
            },
          ),
        ),
      );
    });
  });
}
