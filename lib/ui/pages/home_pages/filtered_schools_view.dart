import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:school_finder_app/ui/pages/school_pages/school_page.dart';
import 'package:school_finder_app/viewmodels/user_view_model.dart';

class FilteredSchoolsView extends StatefulWidget {
  final schools;

  const FilteredSchoolsView({Key key, this.schools}) : super(key: key);

  @override
  _FilteredSchoolsViewState createState() => _FilteredSchoolsViewState();
}

class _FilteredSchoolsViewState extends State<FilteredSchoolsView> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final schools = this.widget.schools;
    var favSchools = Provider.of<UserViewModel>(context).favSchools;
    bool showSchool = (schools != null && schools.isNotEmpty);
    return Scaffold(
      appBar: AppBar(
        title: Text('Filtered Schools'),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: ListView.builder(
          itemCount: schools.length,
          itemBuilder: (context, index) {
            return showSchool
                ? InkWell(
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
                              ),
                            ],
                          ),
                        )),
                  )
                : Center(
                    child: Text('No Schools'),
                  );
          },
        ),
      ),
    );
  }
}
