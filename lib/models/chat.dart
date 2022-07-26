import 'package:equatable/equatable.dart';

import 'user.dart';

class Chat extends Equatable {
  final User recipient;

  Chat(this.recipient);

  factory Chat.fromJson(Map<String, dynamic> json) {
    var name = json["name"];
    var id = json["uid"];
    var messagingToken = json["messagingToken"];

    var user = User(id: id, name: name, messagingToken: messagingToken);

    return Chat(user);
  }

  @override
  List<Object?> get props => [recipient];
}
