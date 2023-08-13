import 'package:notez/crdt/event/event.dart';
import 'package:notez/crdt/event/event_handler.dart';
import 'package:notez/crdt/state/state.dart';

class RemoveNoteEventHandler implements EventHandler {
  @override
  void handle(Event event, State state) {
    String id = event.payload['id']!;
    String vaultId = event.payload['vaultId']!;
    Map<String, dynamic> note = state.get('$vaultId/notes/$id');
    note['deleted'] = true;
  }

  @override
  EventType get type => EventType.REMOVE_NOTE;
}
