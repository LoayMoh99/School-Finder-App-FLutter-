import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:school_finder_app/ui/pages/school_pages/school_page.dart';
import 'package:school_finder_app/viewmodels/change_ntifier_helper.dart';
import 'package:school_finder_app/viewmodels/user_view_model.dart';
import 'package:school_finder_app/viewmodels/schools_view_model.dart';

class SchoolsView extends StatefulWidget {
  final Size size;
  final String accessToken;

  const SchoolsView({Key key, this.size, this.accessToken}) : super(key: key);

  @override
  _SchoolsViewState createState() => _SchoolsViewState();
}

class _SchoolsViewState extends State<SchoolsView> {
  String accessToken;
  @override
  void initState() {
    super.initState();
    Provider.of<SchoolsViewModel>(context, listen: false).getSchools();
    accessToken = this.widget.accessToken;
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<UserViewModel>(context, listen: false).getProfile(accessToken);
    var favSchools = Provider.of<UserViewModel>(context).favSchools;
    return Expanded(
      child: Container(
        width: this.widget.size.width,
        child: Consumer<SchoolsViewModel>(builder: (_, notifier, __) {
          if (notifier.state == NotifierState.initial) {
            return Center(
              child: Text('No Schools'),
            );
          } else if (notifier.state == NotifierState.loading) {
            return Center(child: CircularProgressIndicator());
          } else {
            return notifier.schools.fold((failure) {
              return Center(
                child: Text(failure.message()),
              );
            }, (schools) {
              //var favSchools = this.widget.favSchools;
              Provider.of<SchoolsViewModel>(context, listen: false)
                  .setSuccSchools(schools);
              bool showSchool = (schools != null && schools.isNotEmpty);

              return ListView.builder(
                itemCount: showSchool ? schools.length : 1,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
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
                      width: this.widget.size.width,
                      height: this.widget.size.height * 0.25,
                      child: showSchool
                          ? Container(
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
                                      child: Image.asset(
                                          schools[index].gallery[0] != null
                                              ? '${schools[index].gallery[0]}'
                                              : 'imgs/placeholder.jpg'),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
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
                                      borderRadius: BorderRadius.circular(15),
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
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
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
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 6, 6, 0),
                                      child: (favSchools
                                              .contains(schools[index].id))
                                          ? Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                            )
                                          : Icon(
                                              Icons.favorite_border,
                                              color: Colors.red,
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Center(
                              child: Text('No Schools'),
                            ),
                    ),
                  );
                },
              );
            });
          }
        }),
      ),
    );
  }
}
