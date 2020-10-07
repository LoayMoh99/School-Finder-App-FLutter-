import 'package:flutter/material.dart';
import 'package:school_finder_app/core/failure.dart';
import '../dependency_injection.dart';
import '../model/user_data.dart';
import '../repositories/user/user_repository.dart';

class UserViewModel extends ChangeNotifier {
  List<int> favSchools = [1, 3, 5, 4, 7];
  UserRepository _userRepository = new Injector().userRepository;
  User user;

  void getProfile() async {
    try {
      User profile = await _userRepository.fetchUser();
      user = profile;
    } on Failure catch (f) {
      user = new User(
        id: -1,
        name: f.message(),
      );
    }

    notifyListeners();
  }
}
