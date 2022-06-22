import 'package:pts/models/user.dart';
import 'package:pts/services/firestore_service.dart';

class UserService {
  final FireStoreServices services = FireStoreServices("user");

  Future<User> getUser(String id) async {
    var result = await services.getDataById(id);
    return User.fromSnapshot(result);
  }
}
