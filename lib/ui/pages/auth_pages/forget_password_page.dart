import 'package:flutter/material.dart';
import 'package:school_finder_app/ui/widgets/custom_round_button.dart';
import 'package:school_finder_app/ui/widgets/textfield_widget.dart';

class ForgetPasswordPage extends StatefulWidget {
  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final emailController = TextEditingController();

  bool isLoading;
  bool isVisible;
  @override
  void initState() {
    super.initState();
    isVisible = false;
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: SafeArea(
        child: isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Stack(
                children: <Widget>[
                  Center(
                    child: Container(
                      margin: EdgeInsets.all(size.width * 0.1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: size.width * 0.075,
                        horizontal: size.width * 0.1,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              'School Finder',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.05,
                            ),
                            TextFieldWidget(
                              controller: emailController,
                              hintText: 'Email',
                              obscureText: false,
                              prefixIconData: Icons.mail_outline,
                            ),
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            CustomRoundButton(
                              size: size,
                              text: 'Recover',
                              onPress: () {}, //recover the password
                            ),
                            SizedBox(
                              height: size.height * 0.015,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              }, //go to registerPage
                              child: Text(
                                'Back',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ],
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
