import 'package:flutter/material.dart';
import 'package:school_finder_app/ui/pages/auth_pages/login_page.dart';

import 'dependency_injection.dart';

void main() {
  Injector.configure(Flavor.PROD);
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primaryColor: Colors.teal,
        accentColor: Colors.teal[300],
        primaryColorDark: Colors.teal[700],
      ),
      home: LoginPage(),
    );
  }
}
