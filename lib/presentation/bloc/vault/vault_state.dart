part of 'vault_bloc.dart';

@immutable
abstract class VaultState {}

class VaultInitial extends VaultState {}

class LoadingVaults extends VaultState {}

class LoadedVaults extends VaultState {
  final List<Vault> vaults;

  LoadedVaults(this.vaults);
}
