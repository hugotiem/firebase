part of 'login_cubit.dart';

enum LoginStatus { initial, logging, signedUp, logged }

class LoginState extends AppBaseState<LoginStatus> {
  final String? email;

  const LoginState(LoginStatus? status, 
      {this.email,
        bool requestInProgress = false,
      String? requestFailureCode,
      String? requestFailureMessage})
      : super(
            status: status,
            requestInProgress: requestInProgress,
            requestFailureCode: requestFailureCode,
            requestFailureMessage: requestFailureMessage);

  const LoginState.initial() : this(LoginStatus.initial);
  const LoginState.signedUp(String? email) : this(LoginStatus.signedUp, email: email);
  const LoginState.logged() : this(LoginStatus.logged);

  @override
  AppBaseState<LoginStatus> copyWith(
          {bool requestInProgress = false,
          String? requestFailureCode,
          String? requestFailureMessage}) =>
      LoginState(status,
          requestInProgress: requestInProgress,
          requestFailureCode: requestFailureCode,
          requestFailureMessage: requestFailureMessage);
}
