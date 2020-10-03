//when exception or error happens..
class FetchDataException implements Exception {
  final _message;

  FetchDataException([this._message]);

  String toString() {
    if (_message == null) return "Exception Occured";
    return "Exception: $_message";
  }
}
