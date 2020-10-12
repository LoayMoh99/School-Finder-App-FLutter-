import 'package:school_finder_app/model/school_data.dart';
import 'package:school_finder_app/model/user_data.dart';
import 'package:school_finder_app/repositories/user/user_repository.dart';

class ProdUserRepository implements UserRepository {
  @override
  Future<User> fetchUser(accessToken) {
    throw UnimplementedError();
  }

  @override
  Future<List<int>> favoritesAction(accessToke, schoolIdn, action) {
    throw UnimplementedError();
  }

  @override
  Future<List<School>> getFavorites(accessToken) {
    throw UnimplementedError();
  }
}
