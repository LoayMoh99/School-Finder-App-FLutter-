import 'package:school_finder_app/model/school_data.dart';

abstract class SchoolRepository {
  Future<List<School>> fetchSchools();
}
