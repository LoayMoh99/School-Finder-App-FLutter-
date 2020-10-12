import 'package:email_validator/email_validator.dart';

bool nameValidation(String name) {
  return (name.length >= 3 && name.length <= 64);
}

bool phoneValidation(String phoneNo) {
  if (phoneNo.length == 11) {
    for (int i = 0; i < 11; i++) {
      try {
        int.parse(phoneNo[i]);
      } catch (e) {
        return false;
      }
    }
  }
  return true;
}

bool emailValidation(String email) {
  return EmailValidator.validate(email);
}
