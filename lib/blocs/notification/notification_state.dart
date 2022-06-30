part of 'notification_cubit.dart';

enum NotificationStatus { initial }

class NotificationState extends AppBaseState<NotificationStatus> {
  const NotificationState(NotificationStatus? status,
      {bool requestInProgress = false,
      String? requestFailureCode,
      String? requestFailureMessage})
      : super(
            status: status,
            requestInProgress: requestInProgress,
            requestFailureCode: requestFailureCode,
            requestFailureMessage: requestFailureMessage);

  const NotificationState.initial() : this(NotificationStatus.initial);
}
