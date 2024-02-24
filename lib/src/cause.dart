// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';

class Cause extends Equatable {
  Cause() : timestamp = DateTime.now();

  final DateTime timestamp;

  @override
  List<Object?> get props => [timestamp];

  @override
  bool? get stringify => true;
}
