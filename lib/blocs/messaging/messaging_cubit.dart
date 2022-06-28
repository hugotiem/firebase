import 'dart:convert';

import 'package:pts/blocs/base/app_base_cubit.dart';
import 'package:pts/blocs/base/app_base_state.dart';
import 'package:pts/models/message.dart';
import 'package:pts/services/firestore_service.dart';

import 'package:http/http.dart' as http;

part 'messaging_state.dart';

class MessagingCubit extends AppBaseCubit<MessagingState> {
  MessagingCubit() : super(MessagingState.initial());

  FireStoreServices chatServices = FireStoreServices("chat");
  FireStoreServices userServices = FireStoreServices("user");

  Stream fetchMessage({required currentUserID, required otherUserID}) async* {
    var messagesSnapshot =
        chatServices.getMessageStreamSnapshot(currentUserID, otherUserID);
    List<Message> messages = await messagesSnapshot
        .map((event) => Message.fromSnapShots(event))
        .toList();
    emit(MessagingState.loaded(messages));
  }

  Future<void> sendMessage(
      {required String nameSender, required String recipientId, String? type}) async {
    var recipientToken = await userServices.getDataById(recipientId);
    final url =
        "https://us-central1-pts-beta-yog.cloudfunctions.net/handleMessage";
    final res = await http.post(Uri.parse(url), body: {
      "name": nameSender,
      "token": recipientToken,
    });

    var json = jsonDecode(res.body);

    print(json);
  }
}
