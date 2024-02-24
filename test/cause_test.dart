import 'package:effect/effect.dart';
import 'package:effect/src/cause.dart';
import 'package:effect/src/universe.dart';
import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';
import 'package:test/test.dart';

void main() {
  test('Test', () async {
    Fimber.plantTree(DebugTree());

    final testUniverse = CausalityUniverse();

    // getDataEffect.observe([RequestDataCause]);
    printDataEffect.observe(
      [
        DataAvailableCause,
        UppercaseDataAvailable,
      ],
      universe: testUniverse,
    );
    // getMultipleDataEffect.observe([RequestDataCause]);
    // convertDataToUppercaseEffect.observe([DataAvailableCause]);
    throwingEffect.observe(
      [RequestDataCause],
      universe: testUniverse,
    );
    errorHandlerEffect.observe(
      [GetDataErrorCause],
      universe: testUniverse,
    );

    // DataAvailableCause('test1').emit();
    final requestDataCause = RequestDataCause()..emit(universe: testUniverse);
    // DataAvailableCause('test2').emit();
    // await null;
    // await null;
    // await null;
    await testUniverse.idle();

    errorHandlerEffect.dispose(universe: testUniverse);

    expect(
      testUniverse.history,
      containsAllInOrder([
        requestDataCause,
        isA<GetDataErrorCause>(),
      ]),
    );
  });
}

// final errorHandlerEffect = Effect((cause) {
//   switch (cause) {
//     case final GetDataErrorCause _:
//       // ignore: avoid_print
//       print(cause.error);
//     default:
//       // ignore: avoid_print
//       print('Unknown error: $cause');
//   }
//   return [];
// });

final errorHandlerEffect = ErrorHandlerEffect();

class ErrorHandlerEffect extends Effect with EquatableMixin {
  ErrorHandlerEffect()
      : super((cause) {
          switch (cause) {
            case final GetDataErrorCause _:
              // ignore: avoid_print
              print(cause.error);
            default:
              // ignore: avoid_print
              print('Unknown error: $cause');
          }
          return [];
        });

  @override
  List<Object?> get props => [];
}

final throwingEffect = Effect((_) => [GetDataErrorCause(Exception('Test'))]);

final printDataEffect = Effect((Cause cause) {
  if (cause case final DataAvailableCause _) {
    // ignore: avoid_print
    print(cause.data);
  } else if (cause case final UppercaseDataAvailable _) {
    // ignore: avoid_print
    print(cause.data);
  }
  return [];
});

final getDataEffect = Effect(
  (_) => [
    DataAvailableCause('data'),
  ],
);

final getMultipleDataEffect = Effect(
  (_) => [
    DataAvailableCause('multi-data-1'),
    DataAvailableCause('multi-data-2'),
  ],
);

final convertDataToUppercaseEffect = Effect((cause) {
  return [
    if (cause case final DataAvailableCause _)
      UppercaseDataAvailable(cause.data.toUpperCase()),
  ];
});

class UppercaseDataAvailable extends Cause with EquatableMixin {
  UppercaseDataAvailable(this.data);

  final String data;

  @override
  List<Object?> get props => [
        super.props,
        data,
      ];

  @override
  bool? get stringify => true;
}

class RequestDataCause extends Cause {}

class DataAvailableCause extends Cause with EquatableMixin {
  DataAvailableCause(this.data);

  final String data;

  @override
  List<Object?> get props => [
        ...super.props,
        data,
      ];

  @override
  bool? get stringify => true;
}

class GetDataErrorCause extends Cause with EquatableMixin {
  GetDataErrorCause(this.error);

  final Object error;

  @override
  List<Object?> get props => [super.props, error];

  @override
  bool? get stringify => true;
}
