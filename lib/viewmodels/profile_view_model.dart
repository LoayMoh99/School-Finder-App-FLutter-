import 'package:school_finder_app/core/error.dart';
import 'package:school_finder_app/model/user_data.dart';
import 'package:school_finder_app/repositories/user_mock_data.dart';

class ProfileViewModel {
  Future<User> getProfile() async {
    MockUserRepository profileRepository = new MockUserRepository();
    User profile;
    await profileRepository.fetchUser().then((user) {
      profile = user;
      return profile;
    }).catchError((err) {
      throw FetchDataException(err.message);
    });
    return profile;
  }
}
