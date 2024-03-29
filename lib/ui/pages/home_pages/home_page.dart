import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:school_finder_app/core/config.dart';
import 'package:school_finder_app/model/school_data.dart';
import 'package:school_finder_app/ui/helper_widgets/custom_dialog.dart';
import 'package:school_finder_app/ui/pages/home_pages/compare_page.dart';
import 'package:school_finder_app/ui/pages/home_pages/filtered_schools_view.dart';
import 'package:school_finder_app/viewmodels/user_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'add_suggestion_page.dart';
import 'ads_view.dart';
import '../profile_pages/profile_drawer.dart';
import '../school_pages/school_page.dart';
import 'schools_view.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String accessToken;
  bool isLoading = false;
  SharedPreferences sharedPreferences;
  TextEditingController maxFeesController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  String _selectedLanguage, _selectedCertificate, _selectedStage;
  var favSchools;
  bool isFiltering = false;
  @override
  void initState() {
    super.initState();
    getSharedPreference();
  }

  getSharedPreference() async {
    sharedPreferences = await SharedPreferences.getInstance().then((value) {
      setState(() {
        accessToken = value.getString('access_token');
      });
      Provider.of<UserViewModel>(context, listen: false)
          .getProfile(accessToken);
      return value;
    });
  }

  filterSchools() async {
    setState(() {
      isFiltering = true;
    });
    List<School> schools = <School>[];
    final data = {
      if (maxFeesController.text.isNotEmpty) 'MaxFees': maxFeesController.text,
      if (addressController.text.isNotEmpty) 'Address': addressController.text,
      if (_selectedLanguage != null && _selectedLanguage != 'Any')
        'Language': _selectedLanguage,
      if (_selectedCertificate != null && _selectedCertificate != 'Any')
        'Certificate': _selectedCertificate,
      if (_selectedStage != null && _selectedStage != 'Any')
        'Stage': _selectedStage,
    };
    final headers = {
      'APP_KEY': getAppKey(),
    };
    await http
        .post(
      "$domain/api/schools/filter",
      body: data,
      headers: headers,
    )
        .then((response) {
      var jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        if (jsonResponse != null) {
          for (var resp in jsonResponse) {
            School school = new School.fromJson(resp);
            schools.add(school);
          }
          setState(() {
            isFiltering = false;
          });
          Navigator.of(context).push(
            PageTransition(
              type: PageTransitionType.scale,
              alignment: Alignment.bottomCenter,
              child: FilteredSchoolsView(
                schools: schools,
              ),
              inheritTheme: true,
              ctx: context,
            ),
          );
        }
      } else {
        setState(() {
          isFiltering = false;
        });
        customDialog(
            'Error Occured', context, jsonResponse['message'] ?? 'No Schools!!',
            () {
          Navigator.pop(context);
        });
      }
    });
  }

  void showFilterOptions(size) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
            height: size.height * 0.8,
            color: Color(0xFF737373),
            child: new Container(
              height: size.height * 0.8,
              padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(25.0),
                      topRight: const Radius.circular(25.0))),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //max fees textfield
                    TextField(
                      controller: maxFeesController,
                      cursorColor: Theme.of(context).primaryColor,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 14.0,
                      ),
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.teal),
                        focusColor: Theme.of(context).primaryColor,
                        filled: true,
                        enabledBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                        hintText: 'Max Fees',
                        prefixIcon: Icon(
                          Icons.money,
                          size: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      autofocus: true,
                      keyboardType: TextInputType.number,
                    ),
                    //language dropdown
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.all(16),
                      child: DropdownButton<String>(
                        dropdownColor: Colors.teal[50],
                        value: _selectedLanguage,
                        hint: Row(
                          children: [
                            (_selectedLanguage != null)
                                ? Text('$_selectedLanguage')
                                : Text('Main Language:'),
                          ],
                        ),
                        isDense: true,
                        focusColor: Colors.teal[300],
                        items: <String>[
                          'Any',
                          'Arabic',
                          'French',
                          'English',
                          'German'
                        ].map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        onChanged: (chosen) {
                          setState(() {
                            _selectedLanguage = chosen;
                          });
                        },
                      ),
                    ),
                    //address testfield
                    TextField(
                      keyboardType: TextInputType.streetAddress,
                      controller: addressController,
                      cursorColor: Theme.of(context).primaryColor,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 14.0,
                      ),
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.teal),
                        focusColor: Theme.of(context).primaryColor,
                        filled: true,
                        enabledBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                        hintText: 'Address',
                        prefixIcon: Icon(
                          Icons.location_on,
                          size: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      autofocus: true,
                    ),
                    //certificate dropdown
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.all(16),
                      child: DropdownButton<String>(
                        dropdownColor: Colors.teal[50],
                        value: _selectedCertificate,
                        hint: Row(
                          children: [
                            (_selectedCertificate != null)
                                ? Text('$_selectedCertificate')
                                : Text('Certificate:'),
                          ],
                        ),
                        isDense: true,
                        focusColor: Colors.teal[300],
                        items: <String>['Any', 'National', 'IGCSE', 'SAT', 'IB']
                            .map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        onChanged: (chosen) {
                          setState(() {
                            _selectedCertificate = chosen;
                          });
                        },
                      ),
                    ),
                    //stage dropdown
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.all(16),
                      child: DropdownButton<String>(
                        dropdownColor: Colors.teal[50],
                        value: _selectedStage,
                        hint: Row(
                          children: [
                            (_selectedStage != null)
                                ? Text('$_selectedStage')
                                : Text('Stage:'),
                          ],
                        ),
                        isDense: true,
                        focusColor: Colors.teal[300],
                        items: <String>[
                          'Any',
                          'nursery',
                          'KG',
                          'Primary',
                          'Secondary'
                        ].map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        onChanged: (chosen) {
                          setState(() {
                            _selectedStage = chosen;
                          });
                        },
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.all(16),
                      child: RaisedButton(
                        onPressed: isFiltering
                            ? null
                            : () {
                                filterSchools();
                              },
                        child: Text(isFiltering ? 'Filtering..' : 'Filter',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: accessToken != null
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.scale,
                      child: AddSchoolSuggestionPage(
                        accessToken: accessToken,
                      ),
                      inheritTheme: true,
                      ctx: context,
                      alignment: Alignment.bottomRight,
                    ),
                  );
                },
                child: Icon(Icons.add, color: Colors.white),
                backgroundColor: Theme.of(context).primaryColor,
              )
            : Container(),
        drawer: ProfileDrawer(
          size: size,
          accessToken: accessToken,
        ),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Schools Finder',
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
              accessToken: accessToken,
            ),
          ],
        ),
      ),
    );
  }
}

class SchoolSearch extends SearchDelegate<String> {
  String error = 'No results';

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
    return SchoolsListView(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // show some suggestions while searching
    return SchoolsListView(query);
  }
}

class SchoolsListView extends StatefulWidget {
  final query;

  const SchoolsListView(this.query);

  @override
  _SchoolsListViewState createState() => _SchoolsListViewState();
}

class _SchoolsListViewState extends State<SchoolsListView> {
  String error = 'No results!!';
  List<School> schools = <School>[];
  List<String> suggestions = <String>[];

  @override
  void initState() {
    super.initState();
    _getSuggestions();
  }

  _getSuggestions() async {
    await getSuggestions();
  }

  Future<List<String>> getSchools() async {
    List<String> schoolNames = <String>[];
    final data = {
      'name': widget.query,
    };
    final headers = {
      'APP_KEY': getAppKey(),
    };
    await http
        .post(
      "$domain/api/schools/search",
      body: data,
      headers: headers,
    )
        .then((response) {
      var jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        if (jsonResponse != null) {
          for (var resp in jsonResponse) {
            School school = new School.fromJson(resp);
            schools.add(school);
            schoolNames.add(school.name);
          }
          setState(() {});
        }
      } else {
        error = jsonResponse['message'] ??
            'Error with status code${response.statusCode}';
        setState(() {});
      }
    });
    return schoolNames;
  }

  getSuggestions() async {
    if (widget.query.isNotEmpty) {
      await getSchools().then((value) {
        suggestions = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return (suggestions == null || suggestions.isEmpty)
        ? Container(
            child: Center(
              child: Text(error),
            ),
          )
        : ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.scale,
                      child: SchoolPage(
                        school: schools[index],
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
