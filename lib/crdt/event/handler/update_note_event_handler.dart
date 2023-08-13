import 'package:notez/crdt/event/event.dart';
import 'package:notez/crdt/event/event_handler.dart';
import 'package:notez/crdt/state/state.dart';

class UpdateNoteEventHandler implements EventHandler {
  @override
  void handle(Event event, State state) {
    String id = event.payload['id']!;
    String vaultId = event.payload['vaultId']!;
    Map<String, dynamic> note = state.get('$vaultId/notes/$id');
    Map<String, dynamic> payload = event.payload;
    // Происходит перезапись уже записанных значений
    note.addAll(payload);
  }

  @override
  EventType get type => EventType.UPDATE_NOTE;
}

