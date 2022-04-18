part of 'user_cubit.dart';

enum UserStatus {
  initial,
  loggedOut,
  dataLoaded,
  idUploaded,
}

class UserState extends AppBaseState<UserStatus> {
  final String? token;
  final User? user;
  final Wallet? wallet;

  const UserState(UserStatus? status,
      {this.token,
      this.user,
      this.wallet,
      bool requestInProgress = false,
      String? requestFailureCode,
      String? requestFailureMessage})
      : super(
            status: status,
            requestInProgress: requestInProgress,
            requestFailureCode: requestFailureCode,
            requestFailureMessage: requestFailureMessage);

  const UserState.initial() : this(UserStatus.initial);
  const UserState.dataLoaded({User? user, String? token, Wallet? wallet})
      : this(UserStatus.dataLoaded, token: token, user: user, wallet: wallet);

  const UserState.idUploaded({User? user, String? token})
      : this(UserStatus.idUploaded, token: token, user: user);

  @override
  AppBaseState<UserStatus> copyWith(
          {bool requestInProgress = false,
          String? requestFailureCode,
          String? requestFailureMessage}) =>
      UserState(this.status,
          requestInProgress: requestInProgress,
          requestFailureCode: requestFailureCode,
          requestFailureMessage: requestFailureMessage);
}
