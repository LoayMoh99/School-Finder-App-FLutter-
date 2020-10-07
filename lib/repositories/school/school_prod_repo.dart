import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:school_finder_app/core/failure.dart';
import 'package:school_finder_app/model/school_data.dart';
import 'package:school_finder_app/repositories/school/school_repository.dart';

class ProdSchoolRepository implements SchoolRepository {
  String schoolUrl = "https://api.coinmarketcap.com/v1/ticker/?limit=50";
  @override
  Future<List<School>> fetchSchools() async {
    //we got the response
    http.Response response = await http.get(schoolUrl);
    //here we decode it
    final List responseBody = json.decode(response.body);
    final statusCode = response.statusCode;
    if (statusCode != 200 || responseBody == null) {
      throw new Failure("An error ocurred : [Status Code : $statusCode]");
    }

    return responseBody.map((c) => new School.fromJson(c)).toList();
  }
}
