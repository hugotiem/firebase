import 'package:equatable/equatable.dart';

abstract class AppBaseEvent extends Equatable {
  const AppBaseEvent();

  @override
  List<Object> get props => [];

  @override
  String toString() => '$runtimeType { props: $props }';
}
