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
  final favSchools;

  const SchoolsView({Key key, this.size, this.accessToken, this.favSchools})
      : super(key: key);

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
    Provider.of<UserViewModel>(context, listen: false).getProfile(accessToken);
  }

  @override
  Widget build(BuildContext context) {
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
              Provider.of<UserViewModel>(context, listen: false)
                  .getProfile(accessToken);
              var favSchools = Provider.of<UserViewModel>(context).favSchools;
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
                              margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                              child: Stack(
                                fit: StackFit.expand,
                                children: <Widget>[
                                  FittedBox(
                                    fit: BoxFit.fill,
                                    child: Image.asset(
                                        schools[index].gallery[0] != null
                                            ? '${schools[index].gallery[0]}'
                                            : 'imgs/placeholder.jpg'),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        List: [
                                          Colors.black87,
                                          Colors.transparent
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.center,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(8, 0, 0, 8),
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        '${schools[index].name}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child:
                                        (favSchools.contains(schools[index].id))
                                            ? Icon(
                                                Icons.favorite,
                                                color: Colors.red,
                                              )
                                            : Icon(
                                                Icons.favorite_border,
                                                color: Colors.red,
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
