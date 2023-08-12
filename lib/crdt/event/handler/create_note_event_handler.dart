import 'package:notez/crdt/event/event.dart';
import 'package:notez/crdt/event/event_handler.dart';
import 'package:notez/crdt/state.dart';

class CreateNoteEventHandler implements EventHandler {
  @override
  void handle(Event event, State state) {
    Map<String, dynamic> payload = event.payload;
    String id = payload['id']!;
    Map<String, dynamic> note = {
      'id': id,
      'deleted': false,
      'createdAt': payload['createdAt'],
      'color': '',
      'paragraphs': []
    };
    state.put(id, note);
  }

  @override
  EventType get type => EventType.CREATE_NOTE;
}
