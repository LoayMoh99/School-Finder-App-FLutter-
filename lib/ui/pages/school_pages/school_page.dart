import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_finder_app/core/config.dart';
import 'package:school_finder_app/ui/helper_widgets/custom_dialog.dart';

import '../../../model/school_data.dart';
import '../../../viewmodels/user_view_model.dart';

class SchoolPage extends StatefulWidget {
  final School school;

  const SchoolPage({Key key, this.school}) : super(key: key);

  @override
  _SchoolPageState createState() => _SchoolPageState();
}

class _SchoolPageState extends State<SchoolPage> {
  int _currentIndex = 0;
  PageController _pageController;
  String accessToken;

  @override
  void initState() {
    super.initState();
    _getAccessToken();
    _pageController = PageController();
  }

  _getAccessToken() async {
    await getAccessToken().then((value) {
      setState(() {
        accessToken = value;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Provider.of<UserViewModel>(context, listen: false).getProfile(accessToken);
    var favSchools = Provider.of<UserViewModel>(context).favSchools;
    return Scaffold(
      backgroundColor: Colors.teal[50],
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: size.height * 0.3,
              width: size.width,
              child: FittedBox(
                fit: BoxFit.fill,
                child: Image.asset((widget.school.gallery != null &&
                        widget.school.gallery[0] != null)
                    ? '${widget.school.gallery[0]}'
                    : 'imgs/placeholder.jpg'),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '${widget.school.name}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      IconButton(
                        icon: (favSchools.contains(widget.school.id))
                            ? Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : Icon(
                                Icons.favorite_border,
                                color: Colors.red,
                              ),
                        onPressed: () {
                          if (accessToken == null) {
                            customDialog('Not Authenticated', context,
                                "You have to login to have an account and have a favorite list 😄 ",
                                () {
                              Navigator.pop(context);
                            });
                          }
                          if (favSchools.contains(widget.school.id)) {
                            //remove from fav
                            Provider.of<UserViewModel>(context, listen: false)
                                .favoriteAction(
                                    accessToken, widget.school.id, 'remove');
                          } else {
                            //add to favorites
                            Provider.of<UserViewModel>(context, listen: false)
                                .favoriteAction(
                                    accessToken, widget.school.id, 'add');
                          }
                        },
                      ),
                      Text(
                        'Rating: ${widget.school.rating}',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    child: Center(
                      child: Text('Details Overview'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.pinkAccent,
                      ),
                    ),
                    child: Center(
                      child: Text('Reviews Page'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.orange,
                      ),
                    ),
                    child: Center(
                      child: Text('Community Page'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.animateToPage(index,
              duration: Duration(milliseconds: 300), curve: Curves.ease);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            activeColor: Theme.of(context).primaryColor,
            title: Text('Detials'),
            icon: Icon(Icons.details),
          ),
          BottomNavyBarItem(
              activeColor: Theme.of(context).primaryColor,
              title: Text('Reviews'),
              icon: Icon(Icons.rate_review)),
          BottomNavyBarItem(
              activeColor: Theme.of(context).primaryColor,
              title: Text('Community'),
              icon: Icon(Icons.home)),
        ],
      ),
    );
  }
}
