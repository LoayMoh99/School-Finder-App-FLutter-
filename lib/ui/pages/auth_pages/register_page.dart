import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_finder_app/ui/pages/home_pages/home_page.dart';
import 'package:school_finder_app/ui/helper_widgets/custom_round_button.dart';
import 'package:school_finder_app/ui/helper_widgets/role_radio_btns.dart';
import 'package:school_finder_app/ui/helper_widgets/textfield_widget.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  File _image;

  Future<void> selectAvatar(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            title: Text('Add Profile Picture'),
            actions: <Widget>[
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  getImageFromCamera();
                  Navigator.pop(context);
                },
                child: Text('Camera'),
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  getImageFromGallery();
                  Navigator.pop(context);
                },
                child: Text('Gallery'),
              ),
              Padding(
                padding: EdgeInsets.only(right: 12.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    setState(() {
                      _image = null;
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Remove it'),
                ),
              ),
            ],
          );
        });
  }

  Future getImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    this.setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    this.setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

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
                    child: SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: size.width * 0.1,
                          vertical: size.height * 0.01,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.02,
                          horizontal: size.width * 0.1,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            InkWell(
                              onTap: () => selectAvatar(context),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        size.height * 0.05,
                                      ),
                                      border: Border.all(color: Colors.teal),
                                    ),
                                    width: size.height * 0.1,
                                    height: size.height * 0.1,
                                    child: (_image == null)
                                        ? Icon(Icons.person)
                                        : ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              size.height * 0.05,
                                            ),
                                            child: FittedBox(
                                              fit: BoxFit.fill,
                                              child: Image.file(_image),
                                            ),
                                          ),
                                  ),
                                  Container(
                                    height: size.height * 0.1,
                                    width: size.width * 0.01,
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Icon(
                                        Icons.add_a_photo,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.015,
                            ),
                            TextFieldWidget(
                              controller: emailController,
                              hintText: 'Name',
                              obscureText: false,
                              prefixIconData: Icons.person,
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            TextFieldWidget(
                              controller: emailController,
                              hintText: 'Email',
                              obscureText: false,
                              prefixIconData: Icons.mail,
                            ),
                            SizedBox(
                              height: size.height * 0.01,
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
                              suffixIconData: isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            TextFieldWidget(
                              controller: passwordController,
                              hintText: 'Confirm Password',
                              prefixIconData: Icons.lock,
                              obscureText: isVisible ? false : true,
                              suffixOnTap: () {
                                setState(() {
                                  isVisible = !isVisible;
                                });
                              },
                              suffixIconData: isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            TextFieldWidget(
                              controller: emailController,
                              hintText: '+201xxxxxxxxx ',
                              labelText: 'Phone No.',
                              obscureText: false,
                              prefixIconData: Icons.phone,
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            TextFieldWidget(
                              controller: emailController,
                              hintText: 'Street - City ',
                              labelText: 'Location',
                              obscureText: false,
                              prefixIconData: Icons.location_on,
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: RoleRadioButtons(),
                            ),
                            SizedBox(
                              height: size.height * 0.015,
                            ),
                            CustomRoundButton(
                              size: size,
                              text: 'Register',
                              onPress: () {}, //register
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              }, //go to loginPage
                              child: Text(
                                'Login',
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

  logIn() async {
    setState(() {
      isLoading = true;
    });
    String name = emailController.text.trim();
    String password = passwordController.text;
    if (name.isEmpty || password.isEmpty) {
      print('error');
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final Map data = {
      'name': name,
      'password': password,
    };
    var response =
        await http.post("http://10.0.2.2:8000/api/login", body: data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          isLoading = false;
        });
        sharedPreferences.setString(
            "access_token", jsonResponse['access_token']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => HomePage()),
            (Route<dynamic> route) => false);
      }
    } else {
      setState(() {
        isLoading = false;
      });
      print(response.body);
    }
  }
}
