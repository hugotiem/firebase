import 'package:pts/blocs/base/app_base_cubit.dart';
import 'package:pts/blocs/base/app_base_state.dart';
import 'package:pts/model/message.dart';
import 'package:pts/model/services/firestore_service.dart';

part 'messaging_state.dart';

class MessagingCubit extends AppBaseCubit<MessagingState> {
  MessagingCubit() : super(MessagingState.initial());

  FireStoreServices chatServices = FireStoreServices("chat");

  Stream fetchMessage({required currentUserID, required otherUserID}) async* {
    var messagesSnapshot = 
        chatServices.getMessageStreamSnapshot(currentUserID, otherUserID);
    List<Message> messages = 
        await messagesSnapshot.map((event) => Message.fromSnapShots(event)).toList();
    emit(MessagingState.loaded(messages));
  }
}