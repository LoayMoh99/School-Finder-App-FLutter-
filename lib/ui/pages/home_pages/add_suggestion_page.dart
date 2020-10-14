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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFieldWidget(
                          autoFocus: false,
                          hintText: 'Name',
                          obscureText: false,
                          prefixIconData: Icons.school,
                        ),
                      ),
                      Text('*required'),
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFieldWidget(
                              autoFocus: false,
                              hintText: 'Name',
                              obscureText: false,
                              prefixIconData: Icons.school,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFieldWidget(
                              autoFocus: false,
                              hintText: 'Name',
                              obscureText: false,
                              prefixIconData: Icons.school,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFieldWidget(
                              autoFocus: false,
                              hintText: 'Name',
                              obscureText: false,
                              prefixIconData: Icons.school,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFieldWidget(
                              autoFocus: false,
                              hintText: 'Name',
                              obscureText: false,
                              prefixIconData: Icons.school,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFieldWidget(
                              autoFocus: false,
                              hintText: 'Name',
                              obscureText: false,
                              prefixIconData: Icons.school,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFieldWidget(
                              autoFocus: false,
                              hintText: 'Name',
                              obscureText: false,
                              prefixIconData: Icons.school,
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
