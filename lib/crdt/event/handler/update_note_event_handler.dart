import 'package:notez/crdt/event/event.dart';
import 'package:notez/crdt/event/event_handler.dart';
import 'package:notez/crdt/state.dart';

class UpdateNoteEventHandler implements EventHandler {
  @override
  void handle(Event event, State state) {
    String id = event.payload['id']!;
    Map<String, dynamic> note = state.get(id);
    Map<String, dynamic> payload = event.payload;
    // Происходит перезапись уже записанных значений
    note.addAll(payload);
  }

  @override
  EventType get type => EventType.UPDATE_NOTE;
}

