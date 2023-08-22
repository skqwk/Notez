class RemoteNodeException implements Exception {
  String? message;

  RemoteNodeException([this.message]);
}

class UsernameAlreadyInUseException implements Exception {
  String? message;

  UsernameAlreadyInUseException([this.message]);
}