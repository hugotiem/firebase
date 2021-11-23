import 'package:equatable/equatable.dart';

class AppBaseState<T> extends Equatable {
  const AppBaseState(
      {this.status,
      this.requestInProgress = false,
      this.requestFailureCode,
      this.requestFailureMessage});

  final T? status;
  final bool requestInProgress;
  final String? requestFailureCode;
  final String? requestFailureMessage;

  @override
  List<Object?> get props =>
      [status, requestInProgress, requestFailureCode, requestFailureMessage];

  @override
  String toString() => '$runtimeType { props: $props }';

  bool hasError() {
    return requestFailureCode != null || requestFailureMessage != null;
  }

  AppBaseState<T> setRequestInProgress({
    bool inProgress = true,
  }) {
    return this.copyWith(requestInProgress: inProgress);
  }

  AppBaseState<T> setErrorReceived(
      {required String requestFailureCode,
      required String requestFailureMessage}) {
    return this.copyWith(
        requestFailureCode: requestFailureCode,
        requestFailureMessage: requestFailureMessage);
  }

  AppBaseState<T> copyWith(
      {bool requestInProgress = false,
      String? requestFailureCode,
      String? requestFailureMessage}) {
    throw UnimplementedError();
  }
}
