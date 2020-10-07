import 'package:school_finder_app/model/user_data.dart';
import 'package:school_finder_app/repositories/user/user_repository.dart';

class ProdUserRepository implements UserRepository {
  @override
  Future<User> fetchUser() {
    throw UnimplementedError();
  }
}
