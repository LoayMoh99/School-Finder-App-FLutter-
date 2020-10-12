import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:school_finder_app/core/config.dart';
import 'package:school_finder_app/core/failure.dart';
import 'package:school_finder_app/model/school_data.dart';
import 'package:school_finder_app/model/user_data.dart';
import 'package:school_finder_app/repositories/user/user_repository.dart';

class MockUserRepository implements UserRepository {
  @override
  Future<User> fetchUser(accessToken) async {
    /*return new Future.delayed(
      Duration(seconds: 1),
      () => appAdmin,
    );*/
    var url = "$domain/api/user/profile";
    final headers = {
      'APP_KEY': getAppKey(),
      'Authorization': 'Bearer $accessToken',
    };
    try {
      var response = await http.get(url, headers: headers);
      var responseBody = json.decode(response.body);
      var statusCode = response.statusCode;
      if (statusCode != 200 || responseBody == null) {
        throw new Failure("An error ocurred : [Status Code : $statusCode]");
      }
      User user;
      user = User.fromJson(responseBody);
      return user;
    } on FormatException {
      throw new Failure("Bad Format 👎 ");
    } catch (SocketException) {
      throw new Failure("Server Failed 😲");
    }
  }

  @override
  Future<List<School>> getFavorites(accessToken) async {
    var url = "$domain/api/user/favorites";
    final headers = {
      'APP_KEY': getAppKey(),
      'Authorization': 'Bearer $accessToken',
    };
    try {
      var response = await http.get(url, headers: headers);
      var responseBody = json.decode(response.body);
      var statusCode = response.statusCode;
      if (statusCode != 200 || responseBody == null) {
        throw new Failure("An error ocurred : [Status Code : $statusCode]");
      }
      print(responseBody);
      return responseBody.map((c) => new School.fromJson(c)).toList();
    } on FormatException {
      throw new Failure("Bad Format 👎 ");
    } catch (SocketException) {
      throw new Failure("Server Failed 😲");
    }
  }

  @override
  Future<List<int>> favoritesAction(accessToken, schoolId, action) async {
    var url = "$domain/api/user/favorites/$schoolId/$action";
    final headers = {
      'APP_KEY': getAppKey(),
      'Authorization': 'Bearer $accessToken',
    };
    try {
      var response = await http.post(url, headers: headers);
      var responseBody = json.decode(response.body);
      var statusCode = response.statusCode;
      if (statusCode != 200 || responseBody == null) {
        throw new Failure("An error ocurred : [Status Code : $statusCode]");
      }
      print(responseBody);
      return responseBody;
    } on FormatException {
      throw new Failure("Bad Format 👎 ");
    } catch (SocketException) {
      throw new Failure("Server Failed 😲");
    }
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
