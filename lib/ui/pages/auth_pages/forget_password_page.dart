import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:school_finder_app/core/config.dart';
import 'package:school_finder_app/ui/helper_widgets/custom_dialog.dart';
import 'package:school_finder_app/ui/helper_widgets/custom_round_button.dart';
import 'package:school_finder_app/ui/helper_widgets/logo_widget.dart';
import 'package:school_finder_app/ui/helper_widgets/textfield_widget.dart';

class ForgetPasswordPage extends StatefulWidget {
  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final emailController = TextEditingController();

  bool isLoading;
  @override
  void initState() {
    super.initState();
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
                              'Reset Password',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: ScreenUtil().setSp(70),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            LogoWidget(),
                            SizedBox(
                              height: size.height * 0.05,
                            ),
                            TextFieldWidget(
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              hintText: 'Email',
                              obscureText: false,
                              autoFocus: true,
                              prefixIconData: Icons.mail_outline,
                            ),
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            CustomRoundButton(
                              size: size,
                              text: 'Recover',
                              onPress: () {
                                passwordForget();
                              }, //recover the password
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

  passwordForget() async {
    setState(() {
      isLoading = true;
    });
    String email = emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        isLoading = false;
      });
      customDialog('Error Occured', context, "Email can't be Empty!!", () {
        Navigator.pop(context);
      });
    } else {
      final data = {
        'email': email,
      };
      final headers = {
        'APP_KEY': getAppKey(),
      };
      var response = await http.post(
        "$domain/api/password/forget",
        body: data,
        headers: headers,
      );
      var jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        if (jsonResponse != null) {
          setState(() {
            isLoading = false;
          });
          customDialog('Reset Success', context, jsonResponse['message'], () {
            Navigator.pop(context);
            Navigator.pop(context);
          });
        }
      } else {
        if (jsonResponse != null) {
          setState(() {
            isLoading = false;
          });
          customDialog('Error Occured', context, jsonResponse['message'], () {
            Navigator.pop(context);
          });
        }
      }
    }
  }
}
