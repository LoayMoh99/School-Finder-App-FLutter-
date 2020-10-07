import '../../model/school_data.dart';

abstract class SchoolRepository {
  Future<List<School>> fetchSchools();
}
