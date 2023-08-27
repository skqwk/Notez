import 'package:notez/common/log.dart';
import 'package:notez/domain/profile.dart';
import 'package:notez/repo/profile_repo.dart';

class LoginProfileUseCase {
  final ProfileRepo profileRepo;

  LoginProfileUseCase(this.profileRepo);

  Future<Profile?> call(String username) async {
    log.info("Попытка входа в профиль - $username");
    return await profileRepo.getProfile(username);
  }
}