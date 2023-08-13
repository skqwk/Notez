import 'package:flutter_test/flutter_test.dart';
import 'package:notez/crdt/event/event.dart';
import 'package:notez/crdt/event/event_handler.dart';
import 'package:notez/crdt/event/handler/create_note_event_handler.dart';
import 'package:notez/crdt/event/handler/create_paragraph_event_handler.dart';
import 'package:notez/crdt/event/handler/remove_note_event_handler.dart';
import 'package:notez/crdt/event/handler/update_note_event_handler.dart';
import 'package:notez/crdt/event/handler/update_paragraph_event_handler.dart';
import 'package:notez/crdt/state/state_factory.dart';


void main() {
  test('Фабрика состояния создается и обработчики событий инициализируются', () {
    // GIVEN
    List<EventHandler> handlers = [
      CreateNoteEventHandler(),
      UpdateNoteEventHandler(),
      CreateParagraphEventHandler(),
      RemoveNoteEventHandler(),
      UpdateParagraphEventHandler()
    ];

    // WHEN
    StateFactory factory = StateFactory(handlers);

    // THEN
    Map<EventType, EventHandler> registeredHandlers = factory.handlers;

    expect(handlers[0], registeredHandlers[EventType.CREATE_NOTE]);
    expect(handlers[1], registeredHandlers[EventType.UPDATE_NOTE]);
    expect(handlers[2], registeredHandlers[EventType.CREATE_PARAGRAPH]);
    expect(handlers[3], registeredHandlers[EventType.REMOVE_NOTE]);
    expect(handlers[4], registeredHandlers[EventType.UPDATE_PARAGRAPH]);
  });
}