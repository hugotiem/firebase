import 'package:pts/blocs/base/app_base_cubit.dart';
import 'package:pts/blocs/base/app_base_state.dart';

part 'notification_state.dart';

class NotificationCubit extends AppBaseCubit<NotificationState> {
  NotificationCubit() : super(NotificationState.initial());
  
  Future<void> sendNotification() async {
    
  }
}