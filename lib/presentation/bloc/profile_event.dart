part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class LoginProfileEvent extends ProfileEvent {
  final String username;

  LoginProfileEvent(this.username);
}

class CreateProfileEvent extends ProfileEvent {
  final String username;

  CreateProfileEvent(this.username);
}

class LogoutProfileEvent extends ProfileEvent {}