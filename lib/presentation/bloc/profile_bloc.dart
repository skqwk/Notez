import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:notez/domain/profile.dart';
import 'package:notez/usecase/create_profile.dart';
import 'package:notez/usecase/login_profile.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final LoginProfileUseCase loginProfileUseCase;
  final CreateProfileUseCase createProfileUseCase;

  ProfileBloc(
    this.loginProfileUseCase,
    this.createProfileUseCase,
  ) : super(ProfileInitial()) {

    on<LoginProfileEvent>((event, emit) async {
      emit(LoadingProfile());
      Profile? profile = await loginProfileUseCase.call(event.username);
      if (profile == null) {
        emit(ProfileNotFound());
      } else {
        emit(LoadedProfile(profile));
      }
    });

    on<CreateProfileEvent>((event, emit) async {
      emit(LoadingProfile());
      Profile profile = await createProfileUseCase.call(event.username);
      emit(LoadedProfile(profile));
    });
  }
}
