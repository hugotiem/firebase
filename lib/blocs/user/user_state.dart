part of 'user_cubit.dart';

enum UserStatus { initial, loading, loggedOut, dataLoaded }

class UserState extends AppBaseState<UserStatus> {
  final String token;
  final User user;

  const UserState(UserStatus status,
      {this.token,
      this.user,
      bool requestInProgress = false,
      String requestFailureCode,
      String requestFailureMessage})
      : super(
            requestInProgress: requestInProgress,
            requestFailureCode: requestFailureCode,
            requestFailureMessage: requestFailureMessage);

  const UserState.initial() : this(UserStatus.initial);
  const UserState.dataLoaded(User user)
      : this(UserStatus.dataLoaded, user: user);

  @override
  AppBaseState<UserStatus> copyWith(
          {bool requestInProgress = false,
          String requestFailureCode,
          String requestFailureMessage}) =>
      UserState(this.status,
          requestInProgress: requestInProgress,
          requestFailureCode: requestFailureCode,
          requestFailureMessage: requestFailureMessage);
}
