import 'package:flutter_test/flutter_test.dart';
import 'package:notez/crdt/event/event.dart';
import 'package:notez/crdt/event/handler/remove_paragraph_event_handler.dart';
import 'package:notez/crdt/state.dart';

const String INSERT_KEY = 'insertKey';
const String DELETE_KEY = 'deleteKey';
const String PARAGRAPHS = 'paragraphs';
const String CONTENT = 'content';
const String NEXT = 'next';
const String HEAD = 'head';

void main() {
  RemoveParagraphEventHandler eventHandler = RemoveParagraphEventHandler();

  test('Обрабатывает соответствующее событие', () {
    expect(eventHandler.type, EventType.REMOVE_PARAGRAPH);
  });

  test(
      'Должен удалять параграф, изменяя его содержимое в null и обновлять deleteKey',
      () {
    // GIVEN
    Map<String, dynamic> note = {
      'id': '1234',
      'paragraphs': {
        '777': {
          CONTENT: 'Some text',
          INSERT_KEY: '777',
          DELETE_KEY: '777',
          NEXT: null
        }
      }
    };

    State state = State();
    state.put('111', {'notes': {'1234': note}});

    Map<String, dynamic> payload = {'noteId': '1234', 'deleteKey': '777', 'vaultId': '111'};
    Event event = Event(EventType.REMOVE_PARAGRAPH, '888', payload);

    // WHEN
    eventHandler.handle(event, state);

    // THEN
    Map<String, dynamic> actualNote = state.get('111/notes/1234');

    Map<String, dynamic> expectedParagraphs = {
      '777': {
        CONTENT: null,
        INSERT_KEY: '777',
        DELETE_KEY: '888',
        NEXT: null,
      }
    };
    expect(actualNote['paragraphs'], expectedParagraphs);
  });

  test(
      'Если параграф уже удален (его содержимое == null), то ничего делать не нужно',
          () {
        // GIVEN
        Map<String, dynamic> note = {
          'id': '1234',
          'paragraphs': {
            '777': {
              CONTENT: null,
              INSERT_KEY: '777',
              DELETE_KEY: '888',
              NEXT: null
            }
          }
        };

        State state = State();
        state.put('111', {'notes': {'1234': note}});

        Map<String, dynamic> payload = {'noteId': '1234', 'deleteKey': '777', 'vaultId': '111'};
        Event event = Event(EventType.REMOVE_PARAGRAPH, '999', payload);

        // WHEN
        eventHandler.handle(event, state);

        // THEN
        Map<String, dynamic> actualNote = state.get('111/notes/1234');

        Map<String, dynamic> expectedParagraphs = {
          '777': {
            CONTENT: null,
            INSERT_KEY: '777',
            DELETE_KEY: '888',
            NEXT: null,
          }
        };
        expect(actualNote['paragraphs'], expectedParagraphs);
      });

  test(
      'Должен бросать исключение при попытке удалить параграф, которого нет',
          () {
        // GIVEN
        Map<String, dynamic> note = {
          'id': '1234',
          'paragraphs': {}
        };

        State state = State();
        state.put('111', {'notes': {'1234': note}});

        Map<String, dynamic> payload = {'noteId': '1234', 'deleteKey': '777', 'vaultId': '111'};
        Event event = Event(EventType.REMOVE_PARAGRAPH, '888', payload);

        // WHEN
        final call = eventHandler.handle;

        // THEN
        expect(() => call(event, state), throwsA(isA<Exception>()));
      });
}
