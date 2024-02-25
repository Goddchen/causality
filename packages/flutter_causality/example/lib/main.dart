import 'package:causality/causality.dart';
import 'package:flutter/material.dart';
import 'package:flutter_causality/flutter_causality.dart';

class RequestDataCause extends Cause {}

class DataAvailableCause extends Cause {
  DataAvailableCause(this.data);

  final String data;
}

void main() {
  final CausalityUniverse causalityUniverse = CausalityUniverse();

  Effect((_) async {
    await Future<void>.delayed(const Duration(seconds: 5));
    return [DataAvailableCause('data')];
  }).observe(
    [RequestDataCause],
    universe: causalityUniverse,
  );

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
}

class ViewModel {
  ViewModel(CausalityUniverse causalityUniverse) {
    Effect((cause) {
      if (cause case DataAvailableCause _) {
        data = cause.data;
      }
      return [
        ViewModelUpdatedCause(this),
      ];
    }).observe(
      [
        DataAvailableCause,
      ],
      universe: causalityUniverse,
    );

    RequestDataCause().emit(universe: causalityUniverse);
  }

  String? data;
}

class ViewModelUpdatedCause extends Cause {
  ViewModelUpdatedCause(this.viewModel);

  final ViewModel viewModel;
}
