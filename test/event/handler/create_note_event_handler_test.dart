import 'package:flutter_test/flutter_test.dart';
import 'package:notez/crdt/event/event.dart';
import 'package:notez/crdt/event/handler/create_note_event_handler.dart';
import 'package:notez/crdt/state.dart';

void main() {
  CreateNoteEventHandler eventHandler = CreateNoteEventHandler();

  test('Обрабатывает соответствующее событие', () {
    expect(eventHandler.type, EventType.CREATE_NOTE);
  });

  test('Должен создавать заметку', () {
    // GIVEN
    State state = State();
    Map<String, dynamic> payload = {'id': '4567', 'createdAt': '12'};

    Event event = Event(EventType.CREATE_NOTE, '1234', payload);

    // WHEN
    eventHandler.handle(event, state);

    // THEN
    Map<String, dynamic> expected = {
      'id': '4567',
      'createdAt': '12',
      'deleted': false,
      'color': '',
      'paragraphs': [],
    };

    expect(state.get('4567'), expected);
  });
}
