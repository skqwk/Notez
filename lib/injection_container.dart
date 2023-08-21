import 'package:get_it/get_it.dart';
import 'package:notez/presentation/bloc/profile_bloc.dart';
import 'package:notez/repo/profile_repo.dart';
import 'package:notez/usecase/create_profile.dart';
import 'package:notez/usecase/login_profile.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(() => ProfileBloc(
        sl(),
        sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => CreateProfileUseCase(sl()));
  sl.registerLazySingleton(() => LoginProfileUseCase(sl()));

  // Repo
  sl.registerLazySingleton<ProfileRepo>(() => InMemoryProfileRepo());
}
