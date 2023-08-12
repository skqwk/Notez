import 'package:flutter_test/flutter_test.dart';
import 'package:notez/crdt/event/event.dart';
import 'package:notez/crdt/event/handler/update_note_event_handler.dart';
import 'package:notez/crdt/state.dart';

void main() {
  test('Должен перезаписывать значения в заметке на новые', () {
    // GIVEN
    UpdateNoteEventHandler eventHandler = UpdateNoteEventHandler();
    State state = State();
    Map<String, dynamic> note = {'id': '5678', 'color': 'black', 'title': 'Old note'};
    state.put('5678', note);

    Map<String, dynamic> payload = {
      'id': '5678',
      'color': 'white',
      'title': 'New note',
    };

    Event event = Event(EventType.UPDATE_NOTE, '1234', payload);

    // WHEN
    eventHandler.handle(event, state);

    // THEN
    Map<String, dynamic> expected = {'id': '5678', 'color': 'white', 'title': 'New note'};

    expect(expected, state.get('5678'));
  });
}