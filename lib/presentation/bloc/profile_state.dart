part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class LoadingProfile extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

class LoadedProfile extends ProfileState {
  final Profile profile;

  LoadedProfile(this.profile);
}

class CreatedProfile extends ProfileState {
  final Profile profile;

  CreatedProfile(this.profile);
}