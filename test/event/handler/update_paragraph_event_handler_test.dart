import 'package:flutter_test/flutter_test.dart';
import 'package:notez/crdt/event/event.dart';
import 'package:notez/crdt/event/handler/update_paragraph_event_handler.dart';
import 'package:notez/crdt/state.dart';

void main() {
  test(
      'Должен обновлять содержимое параграфа N, если N["deleteKey"] < happenAt',
      () {
    // GIVEN
    UpdateParagraphEventHandler eventHandler = UpdateParagraphEventHandler();

    Map<String, dynamic> note = {
      'id': '1234',
      'paragraphs': {
        '444': {'content': 'Some old text', 'deleteKey': '444'}
      }
    };

    State state = State();
    state.put('1234', note);

    Map<String, dynamic> payload = {
      'noteId': '1234',
      'updateKey': '444',
      'content': 'Some new text',
    };

    Event event = Event(EventType.UPDATE_PARAGRAPH, '999', payload);

    // WHEN
    eventHandler.handle(event, state);

    // THEN
    Map<String, dynamic> expectedParagraphs = {
      '444': {'content': 'Some new text', 'deleteKey': '999'}
    };

    Map<String, dynamic> actualNote = state.get('1234');
    expect(actualNote['paragraphs'], expectedParagraphs);
  });

  test('''Не должен обновлять содержимое параграфа N, 
      если параграф уже был удален (N["content"] == null)''', () {
    // GIVEN
    UpdateParagraphEventHandler eventHandler = UpdateParagraphEventHandler();

    Map<String, dynamic> note = {
      'id': '1234',
      'paragraphs': {
        '444': {'content': null, 'deleteKey': '777'}
      }
    };

    State state = State();
    state.put('1234', note);

    Map<String, dynamic> payload = {
      'noteId': '1234',
      'updateKey': '444',
      'content': 'Some new text',
    };

    Event event = Event(EventType.UPDATE_PARAGRAPH, '999', payload);

    // WHEN
    eventHandler.handle(event, state);

    // THEN
    Map<String, dynamic> expectedParagraphs = {
      '444': {'content': null, 'deleteKey': '777'}
    };

    Map<String, dynamic> actualNote = state.get('1234');
    expect(actualNote['paragraphs'], expectedParagraphs);
  });

  test('''Не должен обновлять содержимое параграфа N, 
      если событие обновления запоздало (event.happenAt > N["updateKey"])''', () {
    // GIVEN
    UpdateParagraphEventHandler eventHandler = UpdateParagraphEventHandler();

    Map<String, dynamic> note = {
      'id': '1234',
      'paragraphs': {
        '444': {'content': 'Some updated text', 'deleteKey': '777'}
      }
    };

    State state = State();
    state.put('1234', note);

    Map<String, dynamic> payload = {
      'noteId': '1234',
      'updateKey': '444',
      'content': 'Some new text',
    };

    Event event = Event(EventType.UPDATE_PARAGRAPH, '555', payload);

    // WHEN
    eventHandler.handle(event, state);

    // THEN
    Map<String, dynamic> expectedParagraphs = {
      '444': {'content': 'Some updated text', 'deleteKey': '777'}
    };

    Map<String, dynamic> actualNote = state.get('1234');
    expect(actualNote['paragraphs'], expectedParagraphs);
  });
}
