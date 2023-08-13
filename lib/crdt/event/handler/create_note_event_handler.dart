import 'package:notez/crdt/event/event.dart';
import 'package:notez/crdt/event/event_handler.dart';
import 'package:notez/crdt/state/state.dart';

class CreateNoteEventHandler implements EventHandler {
  @override
  void handle(Event event, State state) {
    Map<String, dynamic> payload = event.payload;
    String id = payload['id']!;
    String vaultId = payload['vaultId']!;
    Map<String, dynamic> note = {
      'id': id,
      'deleted': false,
      'createdAt': payload['createdAt'],
      'title': payload['title'],
      'color': '',
      'paragraphs': []
    };
    state.put('$vaultId/notes/$id', note);
  }

  @override
  EventType get type => EventType.CREATE_NOTE;
}
