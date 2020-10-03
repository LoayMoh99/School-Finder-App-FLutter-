import 'dart:async';

import 'package:school_finder_app/model/ad_data.dart';

import 'ad_repository.dart';

class MockAdRepository implements AdRepository {
  @override
  Future<List<Ad>> fetchAds() {
    // : implement fetchCurrencies
    return new Future.delayed(
      Duration(seconds: 1),
      () => ads,
    );
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
