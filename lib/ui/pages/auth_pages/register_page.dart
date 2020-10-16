import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:school_finder_app/core/config.dart';
import 'package:school_finder_app/core/validation.dart';
import 'package:school_finder_app/ui/helper_widgets/custom_dialog.dart';
import 'package:school_finder_app/ui/helper_widgets/custom_round_button.dart';
import 'package:school_finder_app/ui/helper_widgets/role_radio_btns.dart';
import 'package:school_finder_app/ui/helper_widgets/textfield_widget.dart';

import 'package:school_finder_app/ui/pages/auth_pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneNoController = TextEditingController();
  final addressController = TextEditingController();

  String _role = "school_finder_client";

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
  bool isVisible1;
  bool isVisible2;
  @override
  void initState() {
    super.initState();
    isVisible1 = false;
    isVisible2 = false;
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
                        margin: EdgeInsets.symmetric(
                          horizontal: size.width * 0.05,
                          vertical: size.height * 0.01,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.02,
                          horizontal: size.width * 0.05,
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
                              keyboardType: TextInputType.name,
                              controller: nameController,
                              hintText: 'Name',
                              obscureText: false,
                              prefixIconData: Icons.person,
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            TextFieldWidget(
                              keyboardType: TextInputType.emailAddress,
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
                              obscureText: isVisible1 ? false : true,
                              suffixOnTap: () {
                                setState(() {
                                  isVisible1 = !isVisible1;
                                });
                              },
                              suffixIconData: isVisible1
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            TextFieldWidget(
                              controller: confirmPasswordController,
                              hintText: 'Confirm Password',
                              prefixIconData: Icons.lock,
                              obscureText: isVisible2 ? false : true,
                              suffixOnTap: () {
                                setState(() {
                                  isVisible2 = !isVisible2;
                                });
                              },
                              suffixIconData: isVisible2
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            TextFieldWidget(
                              keyboardType: TextInputType.phone,
                              controller: phoneNoController,
                              hintText: '01xxxxxxxxx ',
                              labelText: 'Phone No.',
                              obscureText: false,
                              prefixIconData: Icons.phone,
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            TextFieldWidget(
                              keyboardType: TextInputType.streetAddress,
                              controller: addressController,
                              hintText: 'Street - City ',
                              labelText: 'Address',
                              obscureText: false,
                              prefixIconData: Icons.location_on,
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: RoleRadioButtons(
                                callback: (val) => setState(() => _role = val),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.015,
                            ),
                            CustomRoundButton(
                              size: size,
                              text: 'Register',
                              onPress: () {
                                register();
                              }, //register
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

  register() async {
    setState(() {
      isLoading = true;
    });
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;
    String phoneNo = phoneNoController.text.trim();
    String address = addressController.text.trim();
    if (name.isEmpty ||
        password.isEmpty ||
        email.isEmpty ||
        confirmPassword.isEmpty) {
      setState(() {
        isLoading = false;
      });
      customDialog('Error Occured', context,
          "Name, Email and Password & it's confirmation are Required!!", () {
        Navigator.pop(context);
      });
    } else if (password != confirmPassword) {
      setState(() {
        isLoading = false;
      });
      customDialog('Error Occured', context,
          "Password & it's confirmation aren't the Same!!", () {
        Navigator.pop(context);
      });
    } else {
      if (!nameValidation(name)) {
        setState(() {
          isLoading = false;
        });
        customDialog('Error Occured', context,
            "Wrong 'Name' Format Min:3 and Max:64 characters", () {
          Navigator.pop(context);
        });
      } else if (!emailValidation(email)) {
        setState(() {
          isLoading = false;
        });
        customDialog('Error Occured', context,
            "Wrong 'Email' Format; check @ or the dot", () {
          Navigator.pop(context);
        });
      } else if (!phoneValidation(phoneNo)) {
        setState(() {
          isLoading = false;
        });
        customDialog('Error Occured', context,
            "Wrong 'Phone Number' Format; must be 11 numbers i.e:(01xxxxxxxxx)",
            () {
          Navigator.pop(context);
        });
      } else {
        var data = {
          'name': name,
          //'avatar': bytes,
          'email': email,
          'password': password,
          'password_confirmation': confirmPassword,
          //'avatar': _image,
          if (phoneNo != null && phoneNo.isNotEmpty) 'phone_no': phoneNo,
          if (address != null && address.isNotEmpty) 'address': address,
          'role': _role,
          'APP_KEY': getAppKey(),
        };
        try {
          var url = "$domain/api/register";
          var request = http.MultipartRequest('POST', Uri.parse(url));
          if (_image != null)
            request.files
                .add(await http.MultipartFile.fromPath('avatar', _image.path));
          request.fields.addAll(data);
          var streamedResponse = await request.send();
          var response = await http.Response.fromStream(streamedResponse);

          /*var response = await http.post(
        url,
        body: data,
        headers: headers,
      );*/
          var jsonResponse = json.decode(response.body);
          if (response.statusCode == 201) {
            if (jsonResponse != null) {
              setState(() {
                isLoading = false;
              });
              customDialog(
                  'Register Complete', context, jsonResponse['message'], () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.scale,
                    alignment: Alignment.bottomCenter,
                    child: LoginPage(),
                    inheritTheme: true,
                    ctx: context,
                  ),
                );
              });
            }
          } else {
            if (jsonResponse != null) {
              setState(() {
                isLoading = false;
              });
              customDialog('Error Occured', context, jsonResponse['message'],
                  () {
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
}
