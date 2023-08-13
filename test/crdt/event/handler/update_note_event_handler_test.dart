import 'package:flutter_test/flutter_test.dart';
import 'package:notez/crdt/event/event.dart';
import 'package:notez/crdt/event/handler/update_note_event_handler.dart';
import 'package:notez/crdt/state/state.dart';

void main() {
  UpdateNoteEventHandler eventHandler = UpdateNoteEventHandler();

  test('Обрабатывает соответствующее событие', () {
    expect(eventHandler.type, EventType.UPDATE_NOTE);
  });

  test('Должен перезаписывать значения в заметке на новые', () {
    // GIVEN
    State state = State();
    Map<String, dynamic> note = {
      'id': '5678',
      'color': 'black',
      'title': 'Old note'
    };
    state.put('111', {
      'notes': {'5678': note}
    });

    Map<String, dynamic> payload = {
      'id': '5678',
      'vaultId': '111',
      'color': 'white',
      'title': 'New note',
    };

    Event event = Event(EventType.UPDATE_NOTE, '1234', payload);

    // WHEN
    eventHandler.handle(event, state);

    // THEN
    Map<String, dynamic> expected = {
      'id': '5678',
      'color': 'white',
      'title': 'New note',
      'vaultId': '111',
    };

    expect(expected, state.get('111/notes/5678'));
  });
}
