import 'dart:async';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:school_finder_app/core/config.dart';
import 'package:school_finder_app/core/failure.dart';
import 'package:school_finder_app/model/school_data.dart';
import 'package:school_finder_app/repositories/school/school_repository.dart';

class MockSchoolRepository implements SchoolRepository {
  @override
  Future<List<School>> fetchSchools() async {
    /*return new Future.delayed(
      Duration(seconds: 1),
      () => createSchools(),
    );*/
    var url = "$domain/api/schools";
    final headers = {
      'APP_KEY': getAppKey(),
    };
    try {
      var response = await http.get(url, headers: headers);
      var responseBody = json.decode(response.body);
      var statusCode = response.statusCode;
      if (statusCode != 200 || responseBody == null) {
        if (statusCode == 500) throw new Failure("No Internet!");
        throw new Failure("An error ocurred : [Status Code : $statusCode]");
      }
      List<School> schools = <School>[];
      for (var resp in responseBody) {
        School school = new School.fromJson(resp);
        schools.add(school);
      }
      return schools;
    } on FormatException {
      throw new Failure("Bad Format 👎 ");
    } on TypeError {
      throw new Failure("Type Error 😲");
    }
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
