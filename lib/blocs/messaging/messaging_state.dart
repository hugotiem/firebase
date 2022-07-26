part of 'messaging_cubit.dart';

enum MessagingStatus { initial, loading, chatLoaded, messageLoaded }

class MessagingState extends AppBaseState<MessagingStatus> {
  final List<Message>? messages;
  final List<Chat>? chats;

  const MessagingState(MessagingStatus? status,
      {this.messages,
      this.chats,
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
  const MessagingState.messageLoaded(List<Message> messages)
      : this(MessagingStatus.messageLoaded, messages: messages);
  const MessagingState.chatLoaded(List<Chat> chats)
      : this(MessagingStatus.chatLoaded, chats: chats);

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
