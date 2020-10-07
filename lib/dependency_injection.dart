import 'package:school_finder_app/repositories/ad/ad_mock_repo.dart';
import 'package:school_finder_app/repositories/ad/ad_prod_repo.dart';
import 'package:school_finder_app/repositories/ad/ad_repository.dart';
import 'package:school_finder_app/repositories/user/user_mock_repo.dart';
import 'package:school_finder_app/repositories/user/user_prod_repo.dart';
import 'package:school_finder_app/repositories/user/user_repository.dart';

import 'repositories/school/school_mock_repo.dart';
import 'repositories/school/school_prod_repo.dart';
import 'repositories/school/school_repository.dart';

enum Flavor { MOCK, PROD }

//DI
class Injector {
  //the _singleton is only created once..
  //singleton is created once the app is built
  //while lazy one is created when the Injector is called
  static final Injector _singleton = new Injector._internal();
  static Flavor _flavor;

  static void configure(Flavor flavor) {
    _flavor = flavor;
  }

  //so we used the factory constructor for that purpose not to create
  //another instance when creating another instance of Injector
  //don't forget to finish writing all the {static} objects before the factory constructor..
  factory Injector() {
    return _singleton;
  }

  Injector._internal();

  SchoolRepository get schoolRepository {
    switch (_flavor) {
      case Flavor.MOCK:
        return new MockSchoolRepository();
      default:
        return new ProdSchoolRepository();
    }
  }

  AdRepository get adRepository {
    switch (_flavor) {
      case Flavor.MOCK:
        return new MockAdRepository();
      default:
        return new ProdAdRepository();
    }
  }

  UserRepository get userRepository {
    switch (_flavor) {
      case Flavor.MOCK:
        return new MockUserRepository();
      default:
        return new ProdUserRepository();
    }
  }
}
