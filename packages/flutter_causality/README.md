# flutter_causality

![main](https://github.com/Goddchen/causality/actions/workflows/main.yaml/badge.svg)
![Pub Version](https://img.shields.io/pub/v/flutter_causality)

## Motivation

I wanted to provide some convenience extensions for using `causality` with
Flutter.

## Supported Features

- ✅ Put a causality universe widget in the wigdet tree
- ✅ Put an effect widget in the widget tree to observe causes

## Installation

As simple as `dart pub add flutter_causality`.

Or manually add `flutter_causality: ^<version>` to your `pubspec.yaml`.

## Examples

```dart
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
```