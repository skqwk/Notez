part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class LoadingProfile extends ProfileState {}

class ProfileNotFound extends ProfileState {}

class LoadedProfile extends ProfileState {
  final Profile profile;

  LoadedProfile(this.profile);
}

class CreatedProfile extends ProfileState {
  final Profile profile;

  CreatedProfile(this.profile);
}