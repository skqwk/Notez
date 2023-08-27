part of 'vault_bloc.dart';

@immutable
abstract class VaultEvent {}

class LoadVaultsEvent extends VaultEvent {
  final String username;

  LoadVaultsEvent(this.username);
}
