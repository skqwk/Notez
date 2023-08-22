import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notez/domain/profile.dart';
import 'package:notez/repo/profile_repo.dart';
import 'package:notez/usecase/login_profile.dart';

class ProfileRepoMock extends Mock implements ProfileRepo {}

void main() {
  const String USERNAME = 'username';

  late LoginProfileUseCase useCase;
  late ProfileRepo profileRepo;

  setUp(() {
    profileRepo = ProfileRepoMock();

    useCase = LoginProfileUseCase(profileRepo);
  });

  group('При входе в профиль', () {
    test('должен возвращать профиль, если он существует', () async {
      // GIVEN
      when(() => profileRepo.getProfile(USERNAME))
          .thenAnswer((_) async => Profile(USERNAME));

      // WHEN
      Profile? profile = await useCase.call(USERNAME);

      // THEN
      expect(profile!.username, USERNAME);
    });

    test('должен возвращать null, если профиль не существует', () async {
      // GIVEN
      when(() => profileRepo.getProfile(USERNAME))
          .thenAnswer((_) async => null);

      // WHEN
      Profile? profile = await useCase.call(USERNAME);

      // THEN
      expect(profile, isNull);
    });
  });
}