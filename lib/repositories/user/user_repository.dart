import 'package:school_finder_app/model/user_data.dart';

abstract class UserRepository {
  Future<User> fetchUser();
}
