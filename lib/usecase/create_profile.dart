import 'package:notez/domain/profile.dart';
import 'package:notez/repo/profile_repo.dart';

class CreateProfileUseCase {
  final ProfileRepo profileRepo;

  CreateProfileUseCase(this.profileRepo);

  Future<Profile> call(String username) async {
    return await profileRepo.createProfile(username);
  }
}