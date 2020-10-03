import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'ads_view.dart';
import 'profile_drawer.dart';
import 'schools_view.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var name, role;
  String accessToken;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  getProfile() async {
    setState(() {
      isLoading = true;
    });
    var response =
        await http.post("http://10.0.2.2:8000/api/user/profile", headers: {
      'Authorization': 'Bearer $accessToken',
    });
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          isLoading = false;
        });
      }
      name = jsonResponse['name'];
      role = jsonResponse['role'];
    } else {
      setState(() {
        isLoading = false;
      });
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        drawer: ProfileDrawer(
          size: size,
        ),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'School Finder',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            AdsView(
              size: size,
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    onTap: () {},
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.compare),
                          Text('Compare'),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    'Schools List',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Text('Filter'),
                          Icon(Icons.filter_list),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SchoolsView(
              size: size,
            ),
          ],
        ),
      ),
    );
  }
}
