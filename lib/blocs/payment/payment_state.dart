part of 'payment_cubit.dart';

enum PaymentStatus { initial, success }

class PaymentState extends AppBaseState<PaymentStatus> {
  const PaymentState(PaymentStatus? status,
      {bool requestInProgress = false,
      String? requestFailureCode,
      String? requestFailureMessage})
      : super(
            status: status,
            requestInProgress: requestInProgress,
            requestFailureCode: requestFailureCode,
            requestFailureMessage: requestFailureMessage);

  const PaymentState.initial() : this(PaymentStatus.initial);

  @override
  AppBaseState<PaymentStatus> copyWith(
          {bool requestInProgress = false,
          String? requestFailureCode,
          String? requestFailureMessage}) =>
      PaymentState(this.status,
          requestInProgress: requestInProgress,
          requestFailureCode: requestFailureCode,
          requestFailureMessage: requestFailureMessage);
}
