import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:school_finder_app/core/failure.dart';
import 'package:school_finder_app/model/school_data.dart';
import 'package:school_finder_app/viewmodels/change_ntifier_helper.dart';
import '../dependency_injection.dart';
import '../model/user_data.dart';
import '../repositories/user/user_repository.dart';

class UserViewModel extends ChangeNotifier {
  List<int> favSchools = <int>[];
  UserRepository _userRepository = new Injector().userRepository;
  User user;
  void getProfile(accessToken) async {
    try {
      await _userRepository.fetchUser(accessToken).then((profile) {
        user = profile;
        favSchools = (user == null) ? <int>[] : user.favorites;
        notifyListeners();
      });
    } on Failure catch (f) {
      user = new User(
        id: -1,
        name: f.message(),
      );
      notifyListeners();
    }
  }

  setFavorites(List<int> favs) {
    favSchools = favs;
    notifyListeners();
  }

  void favoriteAction(String accessToken, int schoolId, String action) async {
    //action either : add or remove
    try {
      await _userRepository
          .favoritesAction(accessToken, schoolId, action)
          .then((favs) {
        setFavorites(favs);
      });
    } on Failure catch (f) {
      print(f.message());
    }
  }

  NotifierState _state = NotifierState.initial;
  NotifierState get state => _state;
  void _setState(NotifierState state) {
    _state = state;
  }

  Either<Failure, List<School>> _favSchools;
  Either<Failure, List<School>> get favorites => _favSchools;
  void _setFavSchools(Either<Failure, List<School>> schools) {
    _favSchools = schools;
    notifyListeners();
  }

  void getFavorites(accessToken) async {
    _setState(NotifierState.loading);
    await Task(() => _userRepository.getFavorites(accessToken))
        .attempt() //convert the Task to Either type
        .map((either) => either.leftMap((obj) {
              return obj as Failure;
            }))
        .run() //convert back the Either type to a Future
        .then((value) => _setFavSchools(value));
    _setState(NotifierState.loaded);
  }
}
