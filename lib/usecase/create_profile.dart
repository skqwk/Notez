import 'package:notez/common/exception.dart';
import 'package:notez/common/log.dart';
import 'package:notez/domain/profile.dart';
import 'package:notez/repo/profile_repo.dart';

class CreateProfileUseCase {
  final ProfileRepo profileRepo;

  CreateProfileUseCase(this.profileRepo);

  Future<Profile> call(String username) async {
    Profile? profile = await profileRepo.getProfile(username);
    if (profile != null) {
      throw UsernameAlreadyInUseException();
    }
    log.info('Создание профиля для пользователя: $username');
    return await profileRepo.createProfile(username);
  }
}