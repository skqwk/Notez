import 'package:flutter_test/flutter_test.dart';
import 'package:notez/crdt/event/event.dart';
import 'package:notez/crdt/event/handler/create_note_event_handler.dart';
import 'package:notez/crdt/state/state.dart';

void main() {
  CreateNoteEventHandler eventHandler = CreateNoteEventHandler();

  test('Обрабатывает соответствующее событие', () {
    expect(eventHandler.type, EventType.CREATE_NOTE);
  });

  test('Должен создавать заметку', () {
    // GIVEN
    State state = State();
    state.put('6789', {'notes': {}});

    Map<String, dynamic> payload = {
      'id': '4567',
      'createdAt': '12',
      'vaultId': '6789',
      'title': 'New note',
    };

    Event event = Event(EventType.CREATE_NOTE, '1234', payload);

    // WHEN
    eventHandler.handle(event, state);

    // THEN
    Map<String, dynamic> expected = {
      'id': '4567',
      'createdAt': '12',
      'deleted': false,
      'title': 'New note',
      'color': '',
      'paragraphs': [],
    };

    expect(state.get('6789/notes/4567'), expected);
  });
}
