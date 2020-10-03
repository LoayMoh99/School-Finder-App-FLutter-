import 'dart:async';
import 'dart:math';

import 'package:school_finder_app/model/school_data.dart';
import 'package:school_finder_app/repositories/school/school_repository.dart';

class MockSchoolRepository implements SchoolRepository {
  @override
  Future<List<School>> fetchSchools() {
    // : implement fetchCurrencies
    return new Future.delayed(
      Duration(seconds: 1),
      () => createSchools(),
    );
  }
}

createSchools() {
  var schools = <School>[];
  for (int i = 1; i < 21; i++) {
    Random random = new Random();
    int x = random.nextInt(5) + 1;
    School school = new School(
      name: "School$i",
      id: i,
      annualFees: 100 + i * 55,
      addresss: 'Giza, Egypt',
      certificates: ['IG', 'SAT'],
      description: 'Best schoool',
      estiblashingYear: 2000 + i,
      gallery: ['imgs/schools/school$x.jpe'],
      ratedBy: 2 + i,
      rating: 8 + i,
      gender: 'Boys',
      mainLanguage: 'English',
    );
    schools.add(school);
  }
  return schools;
}
