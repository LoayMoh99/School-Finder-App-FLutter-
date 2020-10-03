import 'package:school_finder_app/core/error.dart';
import 'package:school_finder_app/model/ad_data.dart';
import 'package:school_finder_app/repositories/ad/ad_mock_repo.dart';

class AdsViewModel {
  Future<List<Ad>> getAds() async {
    MockAdRepository adRepository = new MockAdRepository();
    await adRepository.fetchAds().then((ads) {
      return ads;
    }).catchError((err) {
      throw FetchDataException(err.message);
    });
    return ads;
  }
}
