//when exception or error happens..
class Failure implements Exception {
  final _message;

  Failure([this._message]);

  String message() {
    if (_message == null) return "Exception Occured";
    return "$_message";
  }
}
