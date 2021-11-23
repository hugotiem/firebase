part of 'messaging_cubit.dart';

enum MessagingStatus { initial, loading, loaded }

class MessagingState extends AppBaseState<MessagingStatus> {
  final List<Message>? messages;

  const MessagingState(MessagingStatus? status,
      { this.messages,
      bool requestInProgress = false,
      String? requestFailureCode,
      String? requestFailureMessage})
      : super(  
            status: status,
            requestInProgress: requestInProgress,
            requestFailureCode: requestFailureCode,
            requestFailureMessage: requestFailureMessage);

  const MessagingState.initial() : this(MessagingStatus.initial);
  const MessagingState.loading() 
      : this(MessagingStatus.loading, requestInProgress: true);
  const MessagingState.loaded(messages) 
      : this(MessagingStatus.loaded, messages: messages);

  @override 
  AppBaseState<MessagingStatus> copyWith(  
        {bool requestInProgress = false,
          String? requestFailureCode,
          String? requestFailureMessage}) =>
      MessagingState(status,
          messages: this.messages,
          requestInProgress: requestInProgress,
          requestFailureCode: requestFailureCode,
          requestFailureMessage: requestFailureMessage);
}