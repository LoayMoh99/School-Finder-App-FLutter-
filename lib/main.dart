import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_finder_app/ui/pages/auth_pages/login_page.dart';
import 'package:school_finder_app/ui/pages/home_pages/home_page.dart';
import 'package:school_finder_app/viewmodels/ads_view_model.dart';
import 'package:school_finder_app/viewmodels/user_view_model.dart';
import 'package:school_finder_app/viewmodels/schools_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dependency_injection.dart';

void main() {
  Injector.configure(Flavor.MOCK);
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AdsViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => SchoolsViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserViewModel(),
        ),
      ],
      child: new MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primaryColor: Colors.teal,
          accentColor: Colors.teal[300],
          primaryColorDark: Colors.teal[700],
        ),
        home: MainPage(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => HomePage()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
