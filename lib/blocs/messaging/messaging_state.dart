part of 'messaging_cubit.dart';

enum MessagingStatus { initial, send, received }

class MessagingState extends AppBaseState<MessagingStatus> {
  const MessagingState(MessagingStatus status,
      {bool requestInProgress = false,
      String requestFailureCode,
      String requestFailureMessage})
      : super(  
            status: status,
            requestInProgress: requestInProgress,
            requestFailureCode: requestFailureCode,
            requestFailureMessage: requestFailureMessage);

  const MessagingState.initial() : this(MessagingStatus.initial);
  const MessagingState.send() : this(MessagingStatus.send);
  const MessagingState.received() : this(MessagingStatus.received);

  @override 
  AppBaseState<MessagingStatus> copyWith(  
        {bool requestInProgress = false,
          String requestFailureCode,
          String requestFailureMessage}) =>
      MessagingState(status,
          requestInProgress: requestInProgress,
          requestFailureCode: requestFailureCode,
          requestFailureMessage: requestFailureMessage);
}