import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:school_finder_app/model/school_data.dart';
import 'package:school_finder_app/viewmodels/user_view_model.dart';

import 'add_suggestion_page.dart';
import 'ads_view.dart';
import 'compare_page.dart';
import 'profile_drawer.dart';
import '../school_page.dart';
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
    Provider.of<UserViewModel>(context, listen: false).getProfile();
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

  void showFilterOptions(size) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
            height: size.height * 0.5,
            color: Color(0xFF737373),
            child: new Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(25.0),
                        topRight: const Radius.circular(25.0))),
                child: new Center(
                  child: new Text("Filter Options"),
                )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.scale,
                child: AddSchoolSuggestionPage(),
                inheritTheme: true,
                ctx: context,
                alignment: Alignment.bottomRight,
              ),
            );
          },
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: Theme.of(context).primaryColor,
        ),
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
              onPressed: () {
                showSearch(context: context, delegate: SchoolSearch());
              },
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
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.scale,
                          child: ComparePage(),
                          inheritTheme: true,
                          ctx: context,
                          alignment: Alignment.bottomCenter,
                        ),
                      );
                    },
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
                    onTap: () => showFilterOptions(size),
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

class SchoolSearch extends SearchDelegate<String> {
  getSchools() {
    List<String> schools = [];
    for (int i = 1; i < 21; i++) {
      String school = 'School $i';
      schools.add(school);
    }
    return schools;
  }

  getRecentSchools() {
    List<String> schools = [];
    for (int i = 1; i < 6; i++) {
      String school = 'School $i';
      schools.add(school);
    }
    return schools;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    //actions on search
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            if (query.isNotEmpty) query = '';
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //leading
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // show some results based on selection
    return schoolsListView();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // show some suggestions while searching
    return schoolsListView();
  }

  Widget schoolsListView() {
    List<String> suggestions =
        query.isEmpty ? getRecentSchools() : getSchools();
    return (suggestions == null || suggestions.isEmpty)
        ? Container(
            child: Center(
              child: Text('No results'),
            ),
          )
        : ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.scale,
                      child: SchoolPage(
                        school:
                            School(id: 20 + index, name: suggestions[index]),
                      ),
                      inheritTheme: true,
                      ctx: context,
                      alignment: Alignment.topLeft,
                    ),
                  );
                },
                leading: Icon(Icons.school),
                title: Text(suggestions[index]),
              );
            },
          );
  }
}
