import 'package:notez/domain/vault.dart';

abstract class VaultRepo {
  Future<Vault> getVault(String vaultId);
}

class InMemoryVaultRepo implements VaultRepo {
  final List<Vault> vaults = [];

  @override
  Future<Vault> getVault(String vaultId) async {
    Vault foundedVault = vaults
        .where((vault) => vault.id == vaultId)
        .first;
    return Future.value(foundedVault);
  }
}