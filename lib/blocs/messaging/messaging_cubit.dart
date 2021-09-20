import 'package:pts/blocs/base/app_base_cubit.dart';
import 'package:pts/blocs/base/app_base_state.dart';
import 'package:pts/model/services/firestore_service.dart';

part 'messaging_state.dart';

class MessagingCubit extends AppBaseCubit<MessagingState> {
  MessagingCubit() : super(MessagingState.initial());

  FireStoreServices userServices = FireStoreServices("user");

  // Stream fetchListUser() async* {
  //   var messageSnapshot = userServices.getSnapshots();
  // }
}