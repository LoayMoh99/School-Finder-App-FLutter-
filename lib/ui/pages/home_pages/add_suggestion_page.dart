import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_finder_app/model/user_data.dart';
import 'package:school_finder_app/ui/helper_widgets/textfield_widget.dart';
import 'package:school_finder_app/viewmodels/user_view_model.dart';

class AddSchoolSuggestionPage extends StatefulWidget {
  final accessToken;

  const AddSchoolSuggestionPage({Key key, this.accessToken}) : super(key: key);
  @override
  _AddSchoolSuggestionPageState createState() =>
      _AddSchoolSuggestionPageState();
}

class _AddSchoolSuggestionPageState extends State<AddSchoolSuggestionPage> {
  String _selectedLanguage, _selectedCertificate, _selectedStage;

  @override
  void initState() {
    super.initState();
    Provider.of<UserViewModel>(context, listen: false)
        .getProfile(this.widget.accessToken);
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserViewModel>(context).user;
    String _role = (user == null) ? 'error' : user.role;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add School Suggestion'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFieldWidget(
                              keyboardType: TextInputType.name,
                              autoFocus: false,
                              hintText: 'Name',
                              obscureText: false,
                              prefixIconData: Icons.school,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                                (_role != null && _role == 'app_admin')
                                    ? '*All is required'
                                    : '*Name is required',
                                style: TextStyle(
                                  color: Colors.red,
                                )),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFieldWidget(
                              autoFocus: false,
                              keyboardType: TextInputType.phone,
                              hintText: 'Phone Number',
                              obscureText: false,
                              prefixIconData: Icons.phone,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFieldWidget(
                              keyboardType: TextInputType.number,
                              autoFocus: false,
                              hintText: 'Average Annual Fees',
                              obscureText: false,
                              prefixIconData: Icons.money,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFieldWidget(
                              keyboardType: TextInputType.streetAddress,
                              autoFocus: false,
                              hintText: 'Address',
                              obscureText: false,
                              prefixIconData: Icons.location_on,
                            ),
                          ),
                          //language dropdown
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.all(16),
                            child: DropdownButton<String>(
                              dropdownColor: Colors.teal[50],
                              value: _selectedLanguage,
                              hint: Row(
                                children: [
                                  (_selectedLanguage != null)
                                      ? Text('$_selectedLanguage')
                                      : Text('Main Language:'),
                                ],
                              ),
                              isDense: true,
                              focusColor: Colors.teal[300],
                              items: <String>[
                                'Arabic',
                                'French',
                                'English',
                                'German'
                              ].map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList(),
                              onChanged: (chosen) {
                                setState(() {
                                  _selectedLanguage = chosen;
                                });
                              },
                            ),
                          ),

                          //certificate dropdown
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.all(16),
                            child: DropdownButton<String>(
                              dropdownColor: Colors.teal[50],
                              value: _selectedCertificate,
                              hint: Row(
                                children: [
                                  (_selectedCertificate != null)
                                      ? Text('$_selectedCertificate')
                                      : Text('Certificate:'),
                                ],
                              ),
                              isDense: true,
                              focusColor: Colors.teal[300],
                              items: <String>['National', 'IGCSE', 'SAT', 'IB']
                                  .map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList(),
                              onChanged: (chosen) {
                                setState(() {
                                  _selectedCertificate = chosen;
                                });
                              },
                            ),
                          ),
                          //stage dropdown
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.all(16),
                            child: DropdownButton<String>(
                              dropdownColor: Colors.teal[50],
                              value: _selectedStage,
                              hint: Row(
                                children: [
                                  (_selectedStage != null)
                                      ? Text('$_selectedStage')
                                      : Text('Stage:'),
                                ],
                              ),
                              isDense: true,
                              focusColor: Colors.teal[300],
                              items: <String>[
                                'nursery',
                                'KG',
                                'Primary',
                                'Secondary'
                              ].map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList(),
                              onChanged: (chosen) {
                                setState(() {
                                  _selectedStage = chosen;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                height: size.height * 0.09,
                color: Theme.of(context).primaryColor,
                child: Center(
                  child: Text(
                    (_role != null && _role == 'app_admin')
                        ? 'Add School'
                        : 'Add Suggestion',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.height * 0.035,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
