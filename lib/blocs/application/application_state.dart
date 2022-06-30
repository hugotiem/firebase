part of 'application_cubit.dart';

enum ApplicationStatus { splash, login, main }

class ApplicationState extends AppBaseState<ApplicationStatus> {
  final app.User? user;

  const ApplicationState(ApplicationStatus? status,
      {this.user,
      bool requestInProgress = false,
      String? requestFailureCode,
      String? requestFailureMessage})
      : super(
            status: status,
            requestInProgress: requestInProgress,
            requestFailureCode: requestFailureCode,
            requestFailureMessage: requestFailureMessage);

  const ApplicationState.initial() : this(ApplicationStatus.splash);
  const ApplicationState.login() : this(ApplicationStatus.login);
  const ApplicationState.main(app.User user)
      : this(ApplicationStatus.main, user: user);
}
