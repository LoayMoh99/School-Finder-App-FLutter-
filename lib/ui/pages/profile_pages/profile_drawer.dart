import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:school_finder_app/core/config.dart';
import 'package:school_finder_app/model/user_data.dart';
import 'package:school_finder_app/ui/helper_widgets/custom_dialog.dart';
import 'package:school_finder_app/ui/pages/auth_pages/login_page.dart';
import 'package:school_finder_app/ui/pages/profile_pages/edit_profile_page.dart';
import 'package:school_finder_app/ui/pages/profile_pages/favorite_schools_page.dart';
import 'package:school_finder_app/viewmodels/user_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileDrawer extends StatefulWidget {
  final Size size;
  final String accessToken;
  //final User user;

  const ProfileDrawer({
    Key key,
    @required this.size,
    @required this.accessToken,
    // @required this.user,
  }) : super(key: key);

  @override
  _ProfileDrawerState createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  SharedPreferences sharedPreferences;
  bool isLoading = false;
  String accessToken;
  @override
  void initState() {
    super.initState();
    accessToken = this.widget.accessToken;
    Provider.of<UserViewModel>(context, listen: false).getProfile(accessToken);
    getSharedPref();
  }

  getSharedPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserViewModel>(context).user;
    bool error = (user != null && user.id == -1);
    bool showProfilePic = (user != null && user.avatar != null);
    bool showUserName = (user != null && user.name != null);
    return Drawer(
      child: error
          ? Column(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Text(user.name),
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    Provider.of<UserViewModel>(context, listen: false)
                        .getProfile(accessToken);
                  },
                  child: Text('Referesh'),
                )
              ],
            )
          : Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          this.widget.size.width * 0.05,
                          this.widget.size.width * 0.1,
                          this.widget.size.width * 0.05,
                          4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          this.widget.size.height * 0.05,
                        ),
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      width: this.widget.size.height * 0.1,
                      height: this.widget.size.height * 0.1,
                      child: showProfilePic
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(
                                this.widget.size.height * 0.05,
                              ),
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: Image.network(
                                    'http://127.0.0.1:8000${user.avatar}'),
                              ),
                            )
                          : Icon(Icons.person),
                    ),
                    if (showUserName) Text('${user.name}'),
                  ],
                ),
                SizedBox(
                  height: this.widget.size.height * 0.12,
                ),
                Container(
                  margin:
                      EdgeInsets.only(bottom: this.widget.size.height * 0.02),
                  width: this.widget.size.width * 0.4,
                  child: RaisedButton.icon(
                    color: Colors.teal[200],
                    onPressed: user == null
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.scale,
                                alignment: Alignment.bottomCenter,
                                child: EditProfilePage(
                                  accessToken: accessToken,
                                  user: user,
                                ),
                                inheritTheme: true,
                                ctx: context,
                              ),
                            );
                          },
                    icon: Icon(Icons.edit),
                    label: Text('Edit Profile'),
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(bottom: this.widget.size.height * 0.02),
                  width: this.widget.size.width * 0.4,
                  child: RaisedButton.icon(
                    color: Colors.teal[200],
                    onPressed: user == null
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.scale,
                                alignment: Alignment.bottomCenter,
                                child: FavSchoolsPage(
                                  accessToken: accessToken,
                                ),
                                inheritTheme: true,
                                ctx: context,
                              ),
                            );
                          },
                    icon: Icon(Icons.favorite),
                    label: Text('See Favorite List'),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(
                          bottom: this.widget.size.height * 0.05),
                      width: this.widget.size.width * 0.4,
                      child: RaisedButton.icon(
                        color: Colors.teal[200],
                        onPressed:
                            (isLoading || user == null) ? null : () => logout(),
                        icon: Icon(Icons.exit_to_app),
                        label: Text(isLoading ? 'Logging Out..' : 'Logout'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  logout() async {
    setState(() {
      isLoading = true;
    });
    final headers = {
      'APP_KEY': getAppKey(),
      'Authorization': 'Bearer $accessToken',
    };
    sharedPreferences.clear();
    try {
      var response = await http.get(
        "$domain/api/logout",
        headers: headers,
      );
      var jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        if (jsonResponse != null) {
          setState(() {
            isLoading = false;
          });
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
              (Route<dynamic> route) => false);
        }
      } else {
        if (jsonResponse != null) {
          setState(() {
            isLoading = false;
          });
          customDialog('Error Occured', context, jsonResponse['message'], () {
            Navigator.pop(context);
          });
        }
      }
    } on FormatException {
      setState(() {
        isLoading = false;
      });
      customDialog('Error Occured', context, 'Bad Format 👎 ', () {
        Navigator.pop(context);
      });
    } catch (SocketException) {
      setState(() {
        isLoading = false;
      });
      customDialog('Error Occured', context, 'Server Failed 😲 ', () {
        Navigator.pop(context);
      });
    }
  }
}
