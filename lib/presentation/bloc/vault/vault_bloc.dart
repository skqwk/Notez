import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:notez/domain/vault.dart';
import 'package:notez/usecase/load_vaults.dart';

part 'vault_event.dart';
part 'vault_state.dart';

class VaultBloc extends Bloc<VaultEvent, VaultState> {
  final LoadVaultsUseCase loadVaultsUseCase;

  VaultBloc(this.loadVaultsUseCase) : super(VaultInitial()) {
    on<LoadVaultsEvent>((event, emit) async {
      emit(LoadingVaults());
      List<Vault> vaults = await loadVaultsUseCase.call(event.username);
      emit(LoadedVaults(vaults));
    });
  }
}
