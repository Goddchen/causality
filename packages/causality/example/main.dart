import 'package:causality/causality.dart';

void main() async {
  final causalityUniverse = CausalityUniverse();

  printDataEffect.observe(
    types: [
      DataAvailableCause,
    ],
    universe: causalityUniverse,
  );

  causalityUniverse
    ..observe(
      causeTypes: [
        DataRequestedCause,
      ],
      effect: getDataEffect,
    )
    ..emit(DataRequestedCause());

  await causalityUniverse.idle();
}

class DataRequestedCause extends Cause {}

class DataAvailableCause extends Cause {
  DataAvailableCause(this.data);

  final String data;
}

final getDataEffect = Effect(
  (_) async => [
    DataAvailableCause('data'),
  ],
);

final printDataEffect = Effect((cause) {
  switch (cause) {
    case DataAvailableCause _:
      // ignore: avoid_print
      print(cause.data);
  }
  return [];
});
