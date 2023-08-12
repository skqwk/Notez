import 'package:notez/crdt/event/event.dart';
import 'package:notez/crdt/event/event_handler.dart';
import 'package:notez/crdt/state.dart';

class CreateVaultEventHandler extends EventHandler {
  @override
  void handle(Event event, State state) {
    Map<String, dynamic> payload = event.payload;
    Map<String, dynamic> vault = {
      'id': event.happenAt,
      'name': payload['name'],
      'deleted': false,
    };
    state.put(event.happenAt, vault);
  }

  @override
  EventType get type => EventType.CREATE_VAULT;
}