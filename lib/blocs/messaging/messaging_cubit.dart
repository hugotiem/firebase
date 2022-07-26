import 'dart:convert';

import 'package:pts/blocs/base/app_base_cubit.dart';
import 'package:pts/blocs/base/app_base_state.dart';
import 'package:pts/models/chat.dart';
import 'package:pts/models/message.dart';
import 'package:pts/services/firestore_service.dart';

import 'package:http/http.dart' as http;

part 'messaging_state.dart';

class MessagingCubit extends AppBaseCubit<MessagingState> {
  MessagingCubit() : super(MessagingState.initial());

  FireStoreServices chatServices = FireStoreServices("chat");
  FireStoreServices userServices = FireStoreServices("user");

  void fetchMessage({required currentUserID, required otherUserID}) {
    chatServices
        .getMessageStreamSnapshot(currentUserID, otherUserID)
        .listen((event) {
      print(event.docs);
    });

    //emit(MessagingState.loaded(messages));
  }

  void fetchMessageList(String? currentUserId) {
    if (currentUserId == null) return;
    chatServices.getMessagesListStreamSnapshot(currentUserId).listen((event) {
      var data = event.data() as Map<String, dynamic>;
      print(data["userid"]);
      var list = data["userid"] as List;
      print(list);
      var chats = list.map((e) => Chat.fromJson(e)).toList();

      emit(MessagingState.chatLoaded(chats));
    });
  }

  Future<void> sendMessage(
      {required String nameSender,
      required String recipientId,
      String? type}) async {
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
