import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:school_finder_app/core/config.dart';
import 'package:school_finder_app/ui/helper_widgets/logo_widget.dart';
import 'package:school_finder_app/ui/pages/auth_pages/forget_password_page.dart';
import 'package:school_finder_app/ui/pages/auth_pages/register_page.dart';
import 'package:school_finder_app/ui/helper_widgets/custom_round_button.dart';
import 'package:school_finder_app/ui/helper_widgets/textfield_widget.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper_widgets/custom_dialog.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading;
  bool isVisible;

  dialogGuest() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          title: Text(
            'Login as Guest',
            style: TextStyle(color: Theme.of(context).primaryColorDark),
          ),
          content: Text(
              'You will be missing a lot of the Features that Authenticated users have..'),
          actions: <Widget>[
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.pop(context);
                navigateHomePage(context);
              },
              child: Text('Fine'),
            ),
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    isVisible = false;
    isLoading = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ScreenUtil.init(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: SafeArea(
        child: isLoading
            ? Container(
                width: size.width,
                height: size.height,
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                ),
              )
            : Stack(
                children: <Widget>[
                  Center(
                    child: SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.all(size.width * 0.075),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: size.width * 0.075,
                          horizontal: size.width * 0.06,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              'Schools Finder',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: ScreenUtil().setSp(70),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.03,
                              ),
                              child: Column(
                                children: <Widget>[
                                  LogoWidget(),
                                ],
                              ),
                            ),
                            TextFieldWidget(
                              controller: emailController,
                              hintText: 'Name / Email',
                              obscureText: false,
                              prefixIconData: Icons.person,
                              autoFocus: false,
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            TextFieldWidget(
                              controller: passwordController,
                              hintText: 'Password',
                              prefixIconData: Icons.lock,
                              obscureText: isVisible ? false : true,
                              suffixOnTap: () {
                                setState(() {
                                  isVisible = !isVisible;
                                });
                              },
                              autoFocus: false,
                              suffixIconData: isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rotate,
                                    duration: Duration(milliseconds: 400),
                                    child: ForgetPasswordPage(),
                                    inheritTheme: true,
                                    ctx: context,
                                  ),
                                );
                              }, //go to forgetpassword page
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Forget Password?',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            CustomRoundButton(
                              size: size,
                              text: 'Login',
                              onPress: () {
                                logIn();
                              }, //logIn
                            ),
                            SizedBox(
                              height: size.height * 0.025,
                            ),
                            GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                emailController.clear();
                                passwordController.clear();
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.scale,
                                    alignment: Alignment.bottomCenter,
                                    child: RegisterPage(),
                                    inheritTheme: true,
                                    ctx: context,
                                  ),
                                );
                              }, //go to registerPage
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.025,
                            ),
                            GestureDetector(
                              onTap: () {
                                dialogGuest();
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 4),
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'Login as Guest',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
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

  logIn() async {
    setState(() {
      isLoading = true;
    });
    String name = emailController.text.trim();
    String password = passwordController.text;
    if (name.isEmpty || password.isEmpty) {
      setState(() {
        isLoading = false;
      });
      customDialog(
          'Error Occured', context, "Name/Email and Password can't be Empty!!",
          () {
        Navigator.pop(context);
      });
    } else {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final data = {
        'name': name,
        'password': password,
      };
      final headers = {
        'APP_KEY': getAppKey(),
      };
      var response;
      var jsonResponse;
      try {
        response = await http.post(
          "$domain/api/login",
          body: data,
          headers: headers,
        );
        jsonResponse = json.decode(response.body);
        if (response.statusCode == 200) {
          if (jsonResponse != null) {
            setState(() {
              isLoading = false;
            });
            sharedPreferences.setString(
                "access_token", jsonResponse['access_token']);
            navigateHomePage(context);
          }
        } else {
          if (jsonResponse != null) {
            setState(() {
              isLoading = false;
            });
            customDialog('Error Occured', context,
                jsonResponse['message'] ?? 'Unexpected Error', () {
              Navigator.pop(context);
            });
          }
        }
      } on FormatException {
        setState(() {
          isLoading = false;
        });
        customDialog('Error Occured', context, 'Bad Format 👎 ', () {
          Navigator.pop(context);
        });
      } catch (SocketException) {
        setState(() {
          isLoading = false;
        });
        customDialog('Error Occured', context, 'Server Failed 😲 ', () {
          Navigator.pop(context);
        });
      }
    }
  }
}
