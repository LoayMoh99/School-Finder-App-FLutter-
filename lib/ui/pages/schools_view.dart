import 'package:flutter/material.dart';
import 'package:school_finder_app/model/school_data.dart';
import 'package:school_finder_app/viewmodels/schools_view_model.dart';

class SchoolsView extends StatefulWidget {
  final Size size;

  const SchoolsView({this.size});

  @override
  _SchoolsViewState createState() => _SchoolsViewState();
}

class _SchoolsViewState extends State<SchoolsView> {
  SchoolsViewModel _schoolsViewModel = new SchoolsViewModel();
  List<School> schools;
  @override
  void initState() {
    super.initState();
    _schoolsViewModel.getSchools().then((schools) {
      if (schools != null) {
        setState(() {
          this.schools = schools;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool showSchool = (schools != null && schools.isNotEmpty);
    return Expanded(
      child: Container(
        width: this.widget.size.width,
        child: (schools == null)
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: showSchool ? schools.length : 1,
                itemBuilder: (context, index) {
                  return Container(
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
                                      colors: [
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
                              ],
                            ),
                          )
                        : Center(
                            child: Text('No Schools'),
                          ),
                  );
                },
              ),
      ),
    );
  }
}
