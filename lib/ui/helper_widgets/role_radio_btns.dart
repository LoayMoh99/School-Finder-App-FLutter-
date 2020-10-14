import 'package:flutter/material.dart';

typedef void StringCallback(String val);

class RoleRadioButtons extends StatefulWidget {
  final StringCallback callback;

  const RoleRadioButtons({Key key, this.callback}) : super(key: key);

  @override
  _RoleRadioButtonsState createState() => _RoleRadioButtonsState();
}

class _RoleRadioButtonsState extends State<RoleRadioButtons> {
  int role = 1;
  String selectedSchool = "";
  List<String> schools;
  getSchoolsNames() {
    List<String> schools = <String>['My school not here'];
    for (int i = 1; i < 21; i++) {
      String school = 'School $i';
      schools.add(school);
    }
    return schools;
  }

  @override
  void initState() {
    super.initState();
    schools = getSchoolsNames();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
          child: Text(
            'Registered As:',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Radio(
                value: 1,
                groupValue: role,
                onChanged: (T) {
                  setState(() {
                    role = T;
                  });
                  this.widget.callback('school_finder_client');
                }),
            Text('School Finders'),
          ],
        ),
        Row(
          children: <Widget>[
            Radio(
                value: 2,
                groupValue: role,
                onChanged: (T) {
                  setState(() {
                    role = T;
                  });
                  this.widget.callback('school_admin');
                }),
            Text('School Admin'),
          ],
        ),
        /*if (role == 2)
          DropDownField(
            strict: false,
            value: selectedSchool,
            hintText: 'Your School',
            hintStyle: TextStyle(fontSize: 14),
            icon: Icon(Icons.school),
            enabled: true,
            items: schools,
            setter: (school) {
              setState(() {
                selectedSchool = school;
              });
            },
          ),*/
      ],
    );
  }
}
