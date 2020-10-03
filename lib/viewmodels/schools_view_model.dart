import 'package:school_finder_app/core/error.dart';
import 'package:school_finder_app/model/school_data.dart';
import 'package:school_finder_app/repositories/school/school_mock_repo.dart';

class SchoolsViewModel {
  Future<List<School>> getSchools() async {
    List<School> schools;
    MockSchoolRepository schoolRepository = new MockSchoolRepository();
    await schoolRepository.fetchSchools().then((fetchschools) {
      schools = fetchschools;
      return schools;
    }).catchError((err) {
      throw FetchDataException(err.message);
    });
    return schools;
  }
}
