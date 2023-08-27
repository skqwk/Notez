import 'package:get_it/get_it.dart';
import 'package:notez/presentation/bloc/profile_bloc.dart';
import 'package:notez/presentation/bloc/vault/vault_bloc.dart';
import 'package:notez/repo/domain_repo.dart';
import 'package:notez/repo/profile_repo.dart';
import 'package:notez/usecase/create_profile.dart';
import 'package:notez/usecase/load_vaults.dart';
import 'package:notez/usecase/login_profile.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(() => ProfileBloc(
        sl(),
        sl(),
      ));

  sl.registerFactory(() => VaultBloc(
        sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => CreateProfileUseCase(sl()));
  sl.registerLazySingleton(() => LoginProfileUseCase(sl()));
  sl.registerLazySingleton(() => LoadVaultsUseCase(sl()));

  // Repo
  sl.registerLazySingleton<ProfileRepo>(() => InMemoryProfileRepo());
  sl.registerLazySingleton<DomainRepo>(() => InMemoryDomainRepo());
}
