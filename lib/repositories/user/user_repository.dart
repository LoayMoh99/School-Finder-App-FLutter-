import 'package:school_finder_app/model/school_data.dart';
import 'package:school_finder_app/model/user_data.dart';

abstract class UserRepository {
  Future<User> fetchUser(accessToken);
  Future<List<School>> getFavorites(accessToken);
  Future<List<int>> favoritesAction(accessToken, schoolId, action);
}
