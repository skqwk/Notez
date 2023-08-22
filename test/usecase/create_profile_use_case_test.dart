
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notez/common/exception.dart';
import 'package:notez/domain/profile.dart';
import 'package:notez/repo/profile_repo.dart';
import 'package:notez/usecase/create_profile.dart';

class ProfileRepoMock extends Mock implements ProfileRepo {}

void main() {
  const String USERNAME = 'username';

  late CreateProfileUseCase useCase;
  late ProfileRepo profileRepo;

  setUp(() {
    profileRepo = ProfileRepoMock();

    useCase = CreateProfileUseCase(profileRepo);
  });

  group('Должен создавать профиль', () {
    test('если профиль уже занят - выбросить исключение', () async {
      // GIVEN
      when(() => profileRepo.getProfile(USERNAME))
          .thenAnswer((_) async => Profile(USERNAME));

      // WHEN
      final call = useCase.call;

      // THEN
      expectLater(call(USERNAME), throwsA(isA<UsernameAlreadyInUseException>()));
    });

    test('Если профиль свободен - создать и вернуть его', () async {
      // GIVEN
      when(() => profileRepo.getProfile(USERNAME))
          .thenAnswer((_) async => null);

      Profile expected = Profile(USERNAME);
      when(() => profileRepo.createProfile(USERNAME))
          .thenAnswer((_) async => expected);

      // WHEN
      Profile actual = await useCase.call(USERNAME);

      // THEN
      expect(actual, expected);
    });
  });
}