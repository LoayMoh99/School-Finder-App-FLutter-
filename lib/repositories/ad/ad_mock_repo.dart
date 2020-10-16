import 'dart:async';

import 'package:school_finder_app/core/config.dart';
import 'package:school_finder_app/core/failure.dart';
import 'package:school_finder_app/model/ad_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'ad_repository.dart';

class MockAdRepository implements AdRepository {
  @override
  Future<List<Ad>> fetchAds() async {
    // : implement fetchCurrencies
    /*return new Future.delayed(
      Duration(seconds: 1),
      () => ads,
    );*/

    var url = "$domain/api/ads";
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
      List<Ad> ads = <Ad>[];
      for (var resp in responseBody) {
        Ad ad = new Ad.fromJson(resp);
        ads.add(ad);
      }
      return ads;
    } on FormatException {
      throw new Failure("Bad Format 👎 ");
    } on TypeError {
      throw new Failure("Type Error 😲");
    }
  }
}

var ads = <Ad>[
  new Ad(
    adContent: "Misr School is opened",
    id: 1,
    userId: 1,
    adImageUrl: 'imgs/ads/ad1.jpe',
  ),
  new Ad(
    adContent: "Misr School is opened",
    id: 12,
    userId: 1,
  ),
  new Ad(
    adContent: "Future School is opened",
    id: 2,
    userId: 1,
    adImageUrl: 'imgs/ads/ad2.jpe',
  ),
  new Ad(
    adContent: "Om Hassan School is opened",
    id: 3,
    userId: 1,
    adImageUrl: 'imgs/ads/ad3.jpe',
  ),
  new Ad(
    adContent: "Om elmo2menen School is opened",
    id: 4,
    userId: 1,
    adImageUrl: 'imgs/ads/ad4.jpe',
  ),
  new Ad(
    adContent: "Harverd School is opened",
    id: 5,
    userId: 1,
    adImageUrl: 'imgs/ads/ad5.jpe',
  ),
];
