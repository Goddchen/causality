// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:causality/src/cause.dart';

class Effect {
  Effect(this.effect);

  final FutureOr<List<Cause>> Function(Cause cause) effect;
}
