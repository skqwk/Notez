import 'package:notez/crdt/event/event.dart';
import 'package:notez/crdt/event/event_handler.dart';
import 'package:notez/crdt/state.dart';

class CreateVaultEventHandler extends EventHandler {
  @override
  void handle(Event event, State state) {
    // TODO: implement handle
  }

  @override
  EventType get type => EventType.CREATE_VAULT;
}