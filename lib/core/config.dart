import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

String base64Encode(String str) {
  var bytes = utf8.encode(str);
  var base64Str = base64.encode(bytes);
  return base64Str;
}

String getAppKey() {
  var appId = 'fbdjhjxchkcvjxjcjvbhxjc';
  var appSecret = 'vasdhhasdhjadskdsfamcnhdsuhduhcsj';
  var key = '$appId:$appSecret';
  var keyBase64 = base64Encode(key);
  var sfaBase64 = base64Encode('school_finder_app_key');
  var finalKey = '$sfaBase64$keyBase64';
  return finalKey;
}

final String publicFolder = 'C:/Users/Otrebor Azilab/Desktop/public/';

Future<String> getAccessToken() async {
  String accessToken;
  await SharedPreferences.getInstance().then((sharedPreferences) {
    accessToken = sharedPreferences.getString("access_token");
    return accessToken;
  });
  return accessToken;
}
