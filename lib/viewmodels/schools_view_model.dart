import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:school_finder_app/core/failure.dart';
import 'package:school_finder_app/dependency_injection.dart';
import 'package:school_finder_app/model/school_data.dart';
import 'package:school_finder_app/repositories/school/school_repository.dart';
import 'package:school_finder_app/viewmodels/change_ntifier_helper.dart';

class SchoolsViewModel extends ChangeNotifier {
  SchoolRepository _schoolRepository = new Injector().schoolRepository;

  NotifierState _state = NotifierState.initial;
  NotifierState get state => _state;
  void _setState(NotifierState state) {
    _state = state;
  }

  Either<Failure, List<School>> _schools;
  Either<Failure, List<School>> get schools => _schools;
  void _setSchools(Either<Failure, List<School>> schools) {
    _schools = schools;
    notifyListeners();
  }

  void getSchools() async {
    _setState(NotifierState.loading);
    await Task(() => _schoolRepository.fetchSchools())
        .attempt() //convert the Task to Either type
        .map((either) => either.leftMap((obj) {
              return obj as Failure;
            }))
        .run() //convert back the Either type to a Future
        .then((value) => _setSchools(value));
    _setState(NotifierState.loaded);
  }
}
