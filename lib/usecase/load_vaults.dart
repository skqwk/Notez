import 'package:notez/common/log.dart';
import 'package:notez/domain/vault.dart';
import 'package:notez/repo/domain_repo.dart';

class LoadVaultsUseCase {
  final DomainRepo domainRepo;

  LoadVaultsUseCase(this.domainRepo);

  Future<List<Vault>> call(String username) async {
    log.info('Загрузка заметок для пользователя: $username');
    return domainRepo.getAllVaults(username);
  }
}