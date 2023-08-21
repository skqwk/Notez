import 'package:notez/domain/profile.dart';

abstract class ProfileRepo {
  // TODO: 21.08.23 может возвращать Optional?
  Future<Profile?> getProfile(String username);

  Future<Profile> createProfile(String username);
}

class InMemoryProfileRepo extends ProfileRepo {
  final List<Profile> profiles = [];

  @override
  Future<Profile?> getProfile(String username) {
    Profile? foundProfile =
        profiles.where((profile) => profile.username == username).firstOrNull;

    return Future.value(foundProfile);
  }

  @override
  Future<Profile> createProfile(String username) async {
    Profile profile = Profile(username);
    profiles.add(profile);
    return Future.value(profile);
  }
}
