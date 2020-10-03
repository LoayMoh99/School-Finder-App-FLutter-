import 'dart:async';
import 'package:school_finder_app/model/user_data.dart';

class MockUserRepository {
  Future<User> fetchUser() {
    return new Future.value(admin);
  }
}

User admin = new User(
  id: 1,
  name: 'Loay',
  email: 'loay@demo.com',
  role: 'app_admin',
  avatar: 'imgs/users_avatars/personal photo.png',
  favorites: [1, 2],
);
