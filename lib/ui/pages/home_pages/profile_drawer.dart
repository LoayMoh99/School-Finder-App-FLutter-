import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_finder_app/model/user_data.dart';
import 'package:school_finder_app/viewmodels/user_view_model.dart';

class ProfileDrawer extends StatefulWidget {
  final Size size;

  const ProfileDrawer({Key key, this.size}) : super(key: key);

  @override
  _ProfileDrawerState createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  @override
  void initState() {
    super.initState();
    Provider.of<UserViewModel>(context, listen: false).getProfile();
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
                  onPressed: () {},
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
                                child: Image.asset('${user.avatar}'),
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
                    onPressed: () {
                      Navigator.pop(context);
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
                    onPressed: () {},
                    icon: Icon(Icons.favorite),
                    label: Text('See Favorite List'),
                  ),
                ),
                Container(
                  width: this.widget.size.width * 0.4,
                  child: RaisedButton.icon(
                    color: Colors.teal[200],
                    onPressed: () {},
                    icon: Icon(Icons.question_answer),
                    label: Text('About Us'),
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
                        onPressed: () {},
                        icon: Icon(Icons.exit_to_app),
                        label: Text('Logout'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
