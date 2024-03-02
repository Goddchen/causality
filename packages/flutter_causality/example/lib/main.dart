import 'package:causality/causality.dart';
import 'package:flutter/material.dart';
import 'package:flutter_causality/flutter_causality.dart';

void main() {
  _setupObservations();
  AppStartedCause().emit(universe: causalityUniverse);
}

final causalityUniverse = CausalityUniverse();

final getDataEffect = Effect((_) async {
  await Future<void>.delayed(const Duration(seconds: 5));
  return [DataAvailableCause('data')];
});

final runAppEffect = Effect((_) {
  ViewModel(causalityUniverse);
  runApp(
    CausalityUniverseWidget(
      causalityUniverse: causalityUniverse,
      child: MaterialApp(
        home: Scaffold(
          body: EffectWidget(
            builder: (cause) => switch (cause) {
              ViewModelUpdatedCause _ => Center(
                  child: Text(cause.viewModel.data ?? ''),
                ),
              _ => const Center(
                  child: CircularProgressIndicator(),
                ),
            },
            observedCauseTypes: const [
              ViewModelUpdatedCause,
            ],
          ),
        ),
      ),
    ),
  );
  return [];
});

void _setupObservations() {
  getDataEffect.observe(
    types: [
      RequestDataCause,
    ],
    universe: causalityUniverse,
  );
  runAppEffect.observe(
    types: [
      AppStartedCause,
    ],
    universe: causalityUniverse,
  );
}

class AppStartedCause extends Cause {}

class DataAvailableCause extends Cause {
  final String data;

  DataAvailableCause(this.data);
}

class RequestDataCause extends Cause {}

class ViewModel {
  String? data;

  ViewModel(CausalityUniverse causalityUniverse) {
    Effect((cause) {
      if (cause case DataAvailableCause _) {
        data = cause.data;
      }
      return [
        ViewModelUpdatedCause(this),
      ];
    }).observe(
      types: [
        DataAvailableCause,
      ],
      universe: causalityUniverse,
    );

    RequestDataCause().emit(universe: causalityUniverse);
  }
}

class ViewModelUpdatedCause extends Cause {
  final ViewModel viewModel;

  ViewModelUpdatedCause(this.viewModel);
}
