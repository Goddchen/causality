# effect

![main](https://github.com/Goddchen/effect/actions/workflows/main.yaml/badge.svg)
![Pub Version](https://img.shields.io/pub/v/effect)

## Motivation

The `effect` NPM package is getting more and more popular (https://effect.website/).
I love the concept and so I'm trying to bring it over to Dart.

## Supported Features

### Effect

- ✅ `flatMap(...)`
- ✅ `map(...)`
- ✅ `run()`

### Either

- ✅ `flatMap(...)`
- ✅ `map(...)`
- ✅ `match(...)`

## Installation

As simple as `dart pub add effect`.

Or manually add `effect: ^<version>` to your `pubspec.yaml`.

## Usage

```dart
Future<String> _longRunningApiCall() async => '{}';
final result = await Effect<void, String, Object>.tryCatch(
  (context) => _longRunningApiCall(),
).map(jsonDecode).run();
result.match(
  (success) {},
  (error) {},
);
```
