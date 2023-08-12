import 'package:notez/crdt/event/event.dart';
import 'package:notez/crdt/event/event_handler.dart';
import 'package:notez/crdt/state.dart';

class UpdateVaultEventHandler extends EventHandler {
  @override
  void handle(Event event, State state) {
    Map<String, dynamic> payload = event.payload;
    Map<String, dynamic> vault = state.get(payload['id']);
    vault.addAll(payload);
  }

  @override
  EventType get type => EventType.UPDATE_VAULT;
}