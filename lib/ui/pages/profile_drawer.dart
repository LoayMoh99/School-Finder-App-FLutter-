import 'package:flutter/material.dart';
import 'package:school_finder_app/model/user_data.dart';
import 'package:school_finder_app/viewmodels/profile_view_model.dart';

class ProfileDrawer extends StatefulWidget {
  final Size size;

  const ProfileDrawer({this.size});

  @override
  _ProfileDrawerState createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  ProfileViewModel _profileViewModel = new ProfileViewModel();
  User user;
  @override
  void initState() {
    super.initState();
    _profileViewModel.getProfile().then((user) {
      if (user != null) {
        setState(() {
          this.user = user;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool showProfilePic = (user != null && user.avatar != null);
    bool showUserName = (user != null && user.name != null);
    return Drawer(
      child: Column(
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
            margin: EdgeInsets.only(bottom: this.widget.size.height * 0.02),
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
            margin: EdgeInsets.only(bottom: this.widget.size.height * 0.02),
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
                margin: EdgeInsets.only(bottom: this.widget.size.height * 0.05),
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
