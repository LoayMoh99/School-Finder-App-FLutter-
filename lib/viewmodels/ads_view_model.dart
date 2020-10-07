import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:school_finder_app/core/failure.dart';
import 'package:school_finder_app/dependency_injection.dart';
import 'package:school_finder_app/model/ad_data.dart';
import 'package:school_finder_app/repositories/ad/ad_repository.dart';
import 'package:school_finder_app/viewmodels/change_ntifier_helper.dart';

class AdsViewModel extends ChangeNotifier {
  AdRepository _adRepository = new Injector().adRepository;

  NotifierState _state = NotifierState.initial;
  NotifierState get state => _state;
  void _setState(NotifierState state) {
    _state = state;
  }

  Either<Failure, List<Ad>> _ads;
  Either<Failure, List<Ad>> get ads => _ads;
  void _setAds(Either<Failure, List<Ad>> ads) {
    _ads = ads;
    notifyListeners();
  }

  void getAds() async {
    _setState(NotifierState.loading);
    await Task(() => _adRepository.fetchAds())
        .attempt() //convert the Task to Either type
        .map((either) => either.leftMap((obj) {
              return obj as Failure;
            }))
        .run() //convert back the Either type to a Future
        .then((value) => _setAds(value));
    _setState(NotifierState.loaded);
  }
}
