import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:school_finder_app/core/failure.dart';
import 'package:school_finder_app/model/ad_data.dart';
import 'package:school_finder_app/repositories/ad/ad_repository.dart';

class ProdAdRepository implements AdRepository {
  String adUrl = "https://api.coinmarketcap.com/v1/ticker/?limit=50";
  @override
  Future<List<Ad>> fetchAds() async {
    //we got the response
    http.Response response = await http.get(adUrl);
    //here we decode it
    final List responseBody = json.decode(response.body);
    final statusCode = response.statusCode;
    if (statusCode != 200 || responseBody == null) {
      throw new Failure("An error ocurred : [Status Code : $statusCode]");
    }

    return responseBody.map((c) => new Ad.fromJson(c)).toList();
  }
}
