import 'package:flutter_test/flutter_test.dart';
import 'package:notez/crdt/event/event.dart';
import 'package:notez/crdt/event/handler/remove_note_event_handler.dart';
import 'package:notez/crdt/state.dart';

void main() {
  RemoveNoteEventHandler eventHandler = RemoveNoteEventHandler();

  test('Обрабатывает соответствующее событие', () {
    expect(eventHandler.type, EventType.REMOVE_NOTE);
  });

  test('Должен помечать заметку deleted = true', () {
    // GIVEN
    State state = State();
    final note = {'id': '4567', 'deleted': false};
    state.put('4567', note);
    
    Map<String, dynamic> payload = {'id': '4567'};
    
    Event event = Event(EventType.REMOVE_NOTE, '1234', payload);
    
    // WHEN
    eventHandler.handle(event, state);
    
    // THEN
    expect({'id': '4567', 'deleted': true}, state.get('4567'));
  });
}
