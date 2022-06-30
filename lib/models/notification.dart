import 'package:equatable/equatable.dart';

enum NotificationType { waiting, message }

class Notification extends Equatable {
  final String messagingToken;
  final NotificationType type;
  final String senderName;

  Notification({required this.messagingToken, required this.type, required this.senderName});

  @override
  List<Object?> get props => [messagingToken, type, senderName];
}
