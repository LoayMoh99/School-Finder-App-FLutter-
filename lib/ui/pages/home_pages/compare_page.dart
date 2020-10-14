import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_finder_app/model/school_data.dart';
import 'package:school_finder_app/ui/helper_widgets/custom_dialog.dart';
import 'package:school_finder_app/viewmodels/schools_view_model.dart';

class ComparePage extends StatefulWidget {
  ComparePage({Key key}) : super(key: key);

  @override
  _ComparePageState createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage> {
  List<School> schools;
  List<String> schoolNames;
  String school1, school2;
  School schoolDetails1, schoolDetails2;
  TextEditingController sc1, sc2;
  @override
  void initState() {
    super.initState();
    schools = Provider.of<SchoolsViewModel>(context, listen: false).succSchools;
    schoolNames = getSchoolNames(schools);
    sc1 = new TextEditingController();
    sc2 = new TextEditingController();
  }

  List<String> getSchoolNames(List<School> schools) {
    List<String> schoolNames = <String>[];
    if (schools.isNotEmpty) {
      for (School school in schools) {
        schoolNames.add(school.name);
      }
    }
    return schoolNames;
  }

  compare() {
    FocusScope.of(context).unfocus();
    if (sc1.text.isNotEmpty && school1 != null && sc1.text == school1) {
      int index1 = schoolNames.indexOf(school1);
      setState(() {
        schoolDetails1 = schools[index1];
      });
    } else {
      customDialog(
          'Invalid Compare!!', context, 'Both schools must be selected 😃 ',
          () {
        Navigator.pop(context);
      });
    }
    if (sc2.text.isNotEmpty && school2 != null && sc2.text == school2) {
      int index2 = schoolNames.indexOf(school2);
      setState(() {
        schoolDetails2 = schools[index2];
      });
    } else {
      customDialog(
          'Invalid Compare!!', context, 'Both schools must be selected 😃 ',
          () {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    schools = Provider.of<SchoolsViewModel>(context).succSchools;
    schoolNames = getSchoolNames(schools);
    return Scaffold(
      appBar: AppBar(
        title: Text('Compare Schools'),
        centerTitle: true,
      ),
      bottomNavigationBar: RaisedButton(
        color: Theme.of(context).primaryColor,
        onPressed: () {
          compare();
        },
        child: Text(
          'Compare',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Row(
            children: <Widget>[
              CompareColumn(
                schoolNo: 1,
                schoolNames: schoolNames,
                callback: (val) => setState(() => school1 = val),
                controller: sc1,
                schoolDetails: schoolDetails1,
              ),
              VerticalDivider(thickness: 2.5),
              CompareColumn(
                schoolNo: 2,
                schoolNames: schoolNames,
                callback: (val) => setState(() => school2 = val),
                controller: sc2,
                schoolDetails: schoolDetails2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

typedef void StringCallback(String val);

class CompareColumn extends StatelessWidget {
  final schoolNo;
  final schoolNames;
  final controller;
  final StringCallback callback;
  final School schoolDetails;

  const CompareColumn(
      {Key key,
      this.schoolNo,
      this.schoolNames,
      this.controller,
      this.schoolDetails,
      this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Expanded(
      child: Container(
        padding: EdgeInsets.fromLTRB(4, 10, 4, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DropDownField(
              controller: controller,
              strict: false,
              labelText: 'School $schoolNo',
              items: schoolNames,
              enabled: true,
              onValueChanged: (value) {
                this.callback(value);
              },
              required: true,
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            if (schoolDetails != null)
              SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      Text('Fees: ${schoolDetails.annualFees}'),
                      Text('Address: ${schoolDetails.addresss}'),
                      Text(
                          'Estiblashing Year: ${schoolDetails.estiblashingYear}'),
                      Text('Gender Type: ${schoolDetails.gender}'),
                      Text('Main Language: ${schoolDetails.mainLanguage}'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
