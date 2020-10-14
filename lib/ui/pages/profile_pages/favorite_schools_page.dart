import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:school_finder_app/ui/pages/school_pages/school_page.dart';
import 'package:school_finder_app/viewmodels/change_ntifier_helper.dart';
import 'package:school_finder_app/viewmodels/user_view_model.dart';

class FavSchoolsPage extends StatefulWidget {
  final accessToken;

  const FavSchoolsPage({Key key, this.accessToken}) : super(key: key);

  @override
  _FavSchoolsPageState createState() => _FavSchoolsPageState();
}

class _FavSchoolsPageState extends State<FavSchoolsPage> {
  String accessToken;
  @override
  void initState() {
    super.initState();
    accessToken = this.widget.accessToken;
    Provider.of<UserViewModel>(context, listen: false)
        .getFavorites(accessToken);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Favorite Schools'),
        ),
        body: Container(
          width: size.width,
          height: size.height,
          child: Consumer<UserViewModel>(builder: (_, notifier, __) {
            if (notifier.state == NotifierState.initial) {
              return Center(
                child: Text('No Schools'),
              );
            } else if (notifier.state == NotifierState.loading) {
              return Center(child: CircularProgressIndicator());
            } else {
              return notifier.favorites.fold((failure) {
                return Center(
                  child: Text(failure.message()),
                );
              }, (schools) {
                bool showSchool = (schools != null && schools.isNotEmpty);
                return showSchool
                    ? ListView.builder(
                        itemCount: schools.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                PageTransition(
                                  type: PageTransitionType.scale,
                                  child: SchoolPage(
                                    school: schools[index],
                                  ),
                                  inheritTheme: true,
                                  ctx: context,
                                  alignment: Alignment.bottomCenter,
                                ),
                              );
                            },
                            child: Container(
                                margin: EdgeInsets.all(8),
                                width: size.width,
                                height: size.height * 0.25,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: FittedBox(
                                          fit: BoxFit.fill,
                                          child: Image.asset(schools[index]
                                                      .gallery[0] !=
                                                  null
                                              ? '${schools[index].gallery[0]}'
                                              : 'imgs/placeholder.jpg'),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.black87,
                                              Colors.transparent
                                            ],
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.center,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.black54,
                                              Colors.transparent
                                            ],
                                            begin: Alignment.centerRight,
                                            end: Alignment.center,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 10, 10),
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${schools[index].name}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                'Rating: ${schools[index].rating}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 10, 10, 0),
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          );
                        },
                      )
                    : Center(
                        child: Text('No Schools'),
                      );
              });
            }
          }),
        ),
      ),
    );
  }
}
