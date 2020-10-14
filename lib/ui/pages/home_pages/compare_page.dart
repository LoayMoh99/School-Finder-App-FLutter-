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
              VerticalDivider(
                thickness: 5,
                color: Colors.black,
              ),
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
  String getAllCertificates() {
    String certifcates = '';
    for (int i = 0; i < schoolDetails.certificates.length - 1; i++) {
      certifcates += schoolDetails.certificates[i] + ' , ';
    }
    certifcates +=
        schoolDetails.certificates[schoolDetails.certificates.length - 1];
    return certifcates;
  }

  String getAllStages() {
    String stages = '';
    for (int i = 0; i < schoolDetails.stages.length - 1; i++) {
      stages = stages + schoolDetails.stages[i] + ' , ';
    }
    stages += schoolDetails.stages[schoolDetails.stages.length - 1];
    return stages;
  }

  List<Widget> getAllFacilities() {
    List<Widget> facilities = <Widget>[];
    for (int i = 0; i < schoolDetails.facilities.length; i++) {
      facilities.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "${schoolDetails.facilities[i].type} x${schoolDetails.facilities[i].number} one of it:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              )),
          Text('${schoolDetails.facilities[i].description}'),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Wrap(
                          children: [
                            Text('Phone No. '),
                            Text('(+2)${schoolDetails.phoneNumber}',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Wrap(
                        children: [
                          Text('Address: '),
                          Text('${schoolDetails.addresss}',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Wrap(
                          children: [
                            Text('Avg. Annual Fees: '),
                            Text('${schoolDetails.annualFees} L.E.',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Wrap(
                        children: [
                          Text('Main Teaching Language: '),
                          Text('${schoolDetails.mainLanguage}',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Wrap(
                          children: [
                            Text('Estiblashing Year: '),
                            Text('${schoolDetails.estiblashingYear}',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Wrap(
                        children: [
                          Text('Gender in school: '),
                          Text('${schoolDetails.gender}',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Wrap(
                          children: [
                            Text('Certificates: '),
                            Text('${getAllCertificates()}',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Wrap(
                        children: [
                          Text('Certificates: '),
                          Text('${getAllStages()}',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              "Some of it's facilities:",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: getAllFacilities(),
                          ),
                        ],
                      ),
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
