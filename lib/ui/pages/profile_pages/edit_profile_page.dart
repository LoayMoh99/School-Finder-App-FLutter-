import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:school_finder_app/core/config.dart';
import 'package:school_finder_app/model/user_data.dart';
import 'package:school_finder_app/ui/helper_widgets/custom_dialog.dart';
import 'package:school_finder_app/ui/helper_widgets/custom_round_button.dart';
import 'package:school_finder_app/ui/helper_widgets/textfield_widget.dart';
import 'package:school_finder_app/ui/pages/home_pages/home_page.dart';

class EditProfilePage extends StatefulWidget {
  final String accessToken;
  final User user;

  const EditProfilePage(
      {Key key, @required this.accessToken, @required this.user})
      : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final nameController = TextEditingController();
  final phoneNoController = TextEditingController();
  final addressController = TextEditingController();

  File _image;
  Image avatarImage;
  bool showAvatar = false;

  bool removeAvatar = false;

  checkAvatar() {
    String avatarUrl = this.widget.user.avatar;
    if (avatarUrl != null && _image == null) {
      avatarImage = Image.network('http://192.168.1.6:8000$avatarUrl');
      setState(() {
        removeAvatar = false;
        showAvatar = true;
      });
    } else if (_image != null) {
      avatarImage = Image.file(_image);
      setState(() {
        removeAvatar = false;
        showAvatar = true;
      });
    }
  }

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
                      showAvatar = false;
                      removeAvatar = true;
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
      }
    });
    checkAvatar();
  }

  Future getImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    this.setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
    checkAvatar();
  }

  bool isLoading;
  String accessToken;
  @override
  void initState() {
    super.initState();
    isLoading = false;
    nameController.text = this.widget.user.name;
    phoneNoController.text = this.widget.user.phoneNo ?? '';
    addressController.text = this.widget.user.address ?? '';
    accessToken = this.widget.accessToken;
    checkAvatar();
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
                                    child: (_image == null && !showAvatar)
                                        ? Icon(Icons.person)
                                        : ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              size.height * 0.05,
                                            ),
                                            child: FittedBox(
                                              fit: BoxFit.fill,
                                              child: avatarImage,
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
                              controller: nameController,
                              hintText: 'Name',
                              obscureText: false,
                              prefixIconData: Icons.person,
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            TextFieldWidget(
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
                              controller: addressController,
                              hintText: 'Street - City ',
                              labelText: 'Address',
                              obscureText: false,
                              prefixIconData: Icons.location_on,
                            ),
                            SizedBox(
                              height: size.height * 0.015,
                            ),
                            CustomRoundButton(
                              size: size,
                              text: 'Update Info',
                              onPress: () {
                                update();
                              },
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              }, //go to loginPage
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

  update() async {
    setState(() {
      isLoading = true;
    });
    String name = nameController.text.trim();
    String phoneNo = phoneNoController.text.trim();
    String address = addressController.text.trim();
    if (name.isEmpty && phoneNo.isEmpty && address.isEmpty && _image == null) {
      setState(() {
        isLoading = false;
      });
      customDialog('Error Occured', context, "No any new values to update!!",
          () {
        Navigator.pop(context);
      });
    } else if (name == this.widget.user.name &&
        phoneNo == this.widget.user.phoneNo &&
        address == this.widget.user.address &&
        (!removeAvatar && _image == null)) {
      setState(() {
        isLoading = false;
      });
      customDialog('Error Occured', context, "No any new values to update!!",
          () {
        Navigator.pop(context);
      });
    } else {
      var data = {
        if (name != null && name.isNotEmpty) 'name': name,
        if (phoneNo != null && phoneNo.isNotEmpty) 'phone_no': phoneNo,
        if (address != null && address.isNotEmpty) 'address': address,
        if (removeAvatar) 'remove_avatar': 1.toString(),
      };
      final headers = {
        'APP_KEY': getAppKey(),
        'Authorization': 'Bearer $accessToken',
      };
      try {
        var url = "$domain/api/user";
        var request = http.MultipartRequest('POST', Uri.parse(url));
        if (_image != null)
          request.files
              .add(await http.MultipartFile.fromPath('avatar', _image.path));
        request.fields.addAll(data);
        request.headers.addAll(headers);
        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);
        var jsonResponse = json.decode(response.body);
        if (response.statusCode == 200) {
          setState(() {
            isLoading = false;
          });
          customDialog('Update Complete', context, 'Your info is Updated 👍 ',
              () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => HomePage()),
                (Route<dynamic> route) => false);
          });
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
