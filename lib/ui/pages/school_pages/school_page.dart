import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ScreenUtil.init(context);
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

  String getAllCertificates() {
    String certifcates = '';
    for (int i = 0; i < widget.school.certificates.length - 1; i++) {
      certifcates += widget.school.certificates[i] + ' , ';
    }
    certifcates +=
        widget.school.certificates[widget.school.certificates.length - 1];
    return certifcates;
  }

  String getAllStages() {
    String stages = '';
    for (int i = 0; i < widget.school.stages.length - 1; i++) {
      stages = stages + widget.school.stages[i] + ' , ';
    }
    stages += widget.school.stages[widget.school.stages.length - 1];
    return stages;
  }

  List<Widget> getAllFacilities() {
    List<Widget> facilities = <Widget>[];
    for (int i = 0; i < widget.school.facilities.length; i++) {
      facilities.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "${widget.school.facilities[i].type} x${widget.school.facilities[i].number} one of it:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              )),
          Text('${widget.school.facilities[i].description}'),
          SizedBox(
            height: 5,
          )
        ],
      ));
    }
    return facilities;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // if (accessToken != null)
    //   Provider.of<UserViewModel>(context, listen: false)
    //       .getProfile(accessToken);
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
                        widget.school.gallery.isNotEmpty)
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
                        icon: (favSchools.contains(widget.school.id) &&
                                accessToken != null)
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
                          } else {
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
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ListTile(
                            leading: Icon(Icons.phone),
                            title: Row(
                              children: [
                                Text('Phone No. '),
                                Expanded(
                                  child: Text(
                                      '(+2)${widget.school.phoneNumber}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.location_on_outlined),
                            title: Row(
                              children: [
                                Text('Address: '),
                                Expanded(
                                  child: Text('${widget.school.addresss}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.attach_money),
                            title: Row(
                              children: [
                                Text('Avg. Annual Fees: '),
                                Expanded(
                                  child: Text(
                                      '${widget.school.annualFees} L.E.',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.language),
                            title: Row(
                              children: [
                                Text('Main Teaching Language: '),
                                Expanded(
                                  child: Text('${widget.school.mainLanguage}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.history_edu),
                            title: Row(
                              children: [
                                Text('Estiblashing Year: '),
                                Expanded(
                                  child: Text(
                                      '${widget.school.estiblashingYear}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.person),
                            title: Row(
                              children: [
                                Text('Gender in school: '),
                                Expanded(
                                  child: Text('${widget.school.gender}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.school),
                            title: Row(
                              children: [
                                Text('Certificates: '),
                                Expanded(
                                  child: Text('${getAllCertificates()}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.school),
                            title: Row(
                              children: [
                                Text('Stages in School: '),
                                Expanded(
                                  child: Text('${getAllStages()}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    'More about the School:',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: ScreenUtil().setSp(60),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${widget.school.description}',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: ScreenUtil().setSp(42),
                                      fontWeight: FontWeight.w500),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    "Some of it's facilities:",
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(42),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: getAllFacilities(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
