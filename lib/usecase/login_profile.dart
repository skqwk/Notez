import 'package:notez/domain/profile.dart';
import 'package:notez/repo/profile_repo.dart';

class LoginProfileUseCase {
  final ProfileRepo profileRepo;

  LoginProfileUseCase(this.profileRepo);

  Future<Profile?> call(String username) async {
    return await profileRepo.getProfile(username);
  }
}