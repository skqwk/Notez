import 'package:notez/crdt/event/event.dart';
import 'package:notez/crdt/event/event_handler.dart';
import 'package:notez/crdt/state.dart';

class RemoveNoteEventHandler implements EventHandler {
  @override
  void handle(Event event, State state) {
    Map<String, dynamic> note = state.get(event.payload['id']!);
    note['deleted'] = true;
  }

  @override
  EventType get type => EventType.REMOVE_NOTE;
}
