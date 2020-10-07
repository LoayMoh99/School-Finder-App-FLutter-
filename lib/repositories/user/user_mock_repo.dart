import 'dart:async';

import 'package:school_finder_app/model/user_data.dart';
import 'package:school_finder_app/repositories/user/user_repository.dart';

class MockUserRepository implements UserRepository {
  @override
  Future<User> fetchUser() {
    return new Future.delayed(
      Duration(seconds: 1),
      () => appAdmin,
    );
  }
}

User appAdmin = new User(
  id: 1,
  name: 'Loay',
  email: 'loay@demo.com',
  role: 'app_admin',
  avatar: 'imgs/users_avatars/personal photo.png',
  favorites: [1, 2],
);
User schoolAdmin = new User(
  id: 1,
  name: 'Loay',
  email: 'loay@demo.com',
  role: 'school_admin',
  avatar: 'imgs/users_avatars/personal photo.png',
  favorites: [1, 2],
);
User schoolFinder = new User(
  id: 1,
  name: 'Loay',
  email: 'loay@demo.com',
  role: 'school_finder_client',
  avatar: 'imgs/users_avatars/personal photo.png',
  favorites: [1, 2],
);
