import '../../model/ad_data.dart';

abstract class AdRepository {
  Future<List<Ad>> fetchAds();
}
