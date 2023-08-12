import 'package:flutter_test/flutter_test.dart';
import 'package:notez/crdt/event/event.dart';
import 'package:notez/crdt/event/handler/create_paragraph_event_handler.dart';
import 'package:notez/crdt/state.dart';

const String INSERT_KEY = 'insertKey';
const String DELETE_KEY = 'deleteKey';
const String PARAGRAPHS = 'paragraphs';
const String CONTENT = 'content';
const String NEXT = 'next';
const String HEAD = 'head';

const String NOTE_ID = '5678';
const String HAPPEN_AT = '1234';

void main() {
  CreateParagraphEventHandler eventHandler = CreateParagraphEventHandler();

  test('Обрабатывает соответствующее событие', () {
    expect(eventHandler.type, EventType.CREATE_PARAGRAPH);
  });

  test('''Если параграф X вставляется в заметку N, и N["head"] = null, 
  то N["head"] = X["happenAt"]''', () {
    // GIVEN
    Map<String, dynamic> note = {'id': NOTE_ID, PARAGRAPHS: {}};

    State state = State();
    state.put('111', {
      'notes': {NOTE_ID: note}
    });

    Map<String, dynamic> payload = {
      CONTENT: 'Some text',
      INSERT_KEY: null,
      'noteId': NOTE_ID,
      'vaultId': '111'
    };

    Event event = Event(EventType.CREATE_PARAGRAPH, HAPPEN_AT, payload);

    // WHEN
    eventHandler.handle(event, state);

    // THEN
    Map<String, dynamic> expectedParagraphs = {
      HAPPEN_AT: {
        CONTENT: 'Some text',
        NEXT: null,
        INSERT_KEY: HAPPEN_AT,
        DELETE_KEY: HAPPEN_AT
      }
    };

    Map<String, dynamic> actualNote = state.get('111/notes/$NOTE_ID');
    expect(actualNote[HEAD], HAPPEN_AT);
    expect(actualNote[PARAGRAPHS], expectedParagraphs);
  });

  test('''Если параграф X вставляется в заметку N, когда там уже есть 
      ведущий параграф Y, то X должен стать ведущим, если X["happenAt"] > N["head"], 
      при этом X["next"] = Y["happenAt"]''', () {
    Map<String, dynamic> paragraphs = {
      '777': {
        CONTENT: 'Some text',
        INSERT_KEY: '777',
        DELETE_KEY: '777',
        NEXT: null
      }
    };

    Map<String, dynamic> note = {
      'id': NOTE_ID,
      HEAD: '777',
      PARAGRAPHS: paragraphs,
    };

    State state = State();
    state.put('111', {
      'notes': {NOTE_ID: note}
    });

    Map<String, dynamic> payload = {
      CONTENT: 'Some text',
      INSERT_KEY: null,
      'noteId': NOTE_ID,
      'vaultId': '111'
    };
    Event event = Event(EventType.CREATE_PARAGRAPH, '888', payload);

    // WHEN
    eventHandler.handle(event, state);

    // THEN
    Map<String, dynamic> expectedParagraphs = {
      '888': {
        CONTENT: 'Some text',
        NEXT: '777',
        INSERT_KEY: '888',
        DELETE_KEY: '888'
      },
      '777': {
        CONTENT: 'Some text',
        INSERT_KEY: '777',
        DELETE_KEY: '777',
        NEXT: null
      }
    };

    Map<String, dynamic> actualNote = state.get('111/notes/$NOTE_ID');
    expect(actualNote[PARAGRAPHS], expectedParagraphs);
    expect(actualNote[HEAD], '888');
  });

  test('''Если параграф X вставляется в начало заметки, когда там уже есть 
      ведущий параграф Y, то он должен встать за ним, если X["happenAt"] < Y["happenAt"],
      при этом Y["next] = X["happenAt"]''', () {
    Map<String, dynamic> paragraphs = {
      '999': {
        CONTENT: 'Some text',
        INSERT_KEY: '999',
        DELETE_KEY: '999',
        NEXT: null
      }
    };

    Map<String, dynamic> note = {
      'id': NOTE_ID,
      HEAD: '999',
      PARAGRAPHS: paragraphs,
    };

    State state = State();
    state.put('111', {
      'notes': {NOTE_ID: note}
    });

    Map<String, dynamic> payload = {
      CONTENT: 'Some text',
      INSERT_KEY: null,
      'noteId': NOTE_ID,
      'vaultId': '111'
    };
    Event event = Event(EventType.CREATE_PARAGRAPH, '888', payload);

    // WHEN
    eventHandler.handle(event, state);

    // THEN
    Map<String, dynamic> expectedParagraphs = {
      '888': {
        CONTENT: 'Some text',
        NEXT: null,
        INSERT_KEY: '888',
        DELETE_KEY: '888'
      },
      '999': {
        CONTENT: 'Some text',
        INSERT_KEY: '999',
        DELETE_KEY: '999',
        NEXT: '888'
      }
    };

    Map<String, dynamic> actualNote = state.get('111/notes/$NOTE_ID');
    expect(actualNote[PARAGRAPHS], expectedParagraphs);
    expect(actualNote[HEAD], '999');
  });

  test('''Если вставляется параграф X c "insertKey" != null, в заметку N,
  то N["paragraphs"][X["insertKey"]]["next"] = X["happenAt"]''', () {
    // GIVEN
    Map<String, dynamic> paragraphs = {
      '777': {
        CONTENT: 'Some text',
        INSERT_KEY: '777',
        DELETE_KEY: '777',
        NEXT: null
      }
    };
    Map<String, dynamic> note = {'id': NOTE_ID, PARAGRAPHS: paragraphs};

    State state = State();
    state.put('111', {
      'notes': {NOTE_ID: note}
    });

    Map<String, dynamic> payload = {
      CONTENT: 'Some text',
      INSERT_KEY: '777',
      'noteId': NOTE_ID,
      'vaultId': '111'
    };
    Event event = Event(EventType.CREATE_PARAGRAPH, HAPPEN_AT, payload);

    // WHEN
    eventHandler.handle(event, state);

    // THEN
    Map<String, dynamic> expectedParagraphs = {
      HAPPEN_AT: {
        CONTENT: 'Some text',
        NEXT: null,
        INSERT_KEY: HAPPEN_AT,
        DELETE_KEY: HAPPEN_AT
      },
      '777': {
        CONTENT: 'Some text',
        INSERT_KEY: '777',
        DELETE_KEY: '777',
        NEXT: HAPPEN_AT
      }
    };

    Map<String, dynamic> actualNote = state.get('111/notes/$NOTE_ID');
    expect(actualNote[PARAGRAPHS], expectedParagraphs);
  });

  test('''Если вставляется параграф X c "insertKey" != null, в заметку N,
  причем у заметки Y["happenAt"] == X["insertKey"]: Y["next"] != null,
  если N["paragraphs"][Y["next"]]["happenAt"] < X["happenAt"],
  то X["next"] = Y["next"], Y["next"] = X["happenAt"]''', () {
    // GIVEN
    Map<String, dynamic> paragraphs = {
      '777': {
        CONTENT: 'Some text',
        INSERT_KEY: '777',
        DELETE_KEY: '777',
        NEXT: '555'
      },
      '555': {
        CONTENT: 'Some text',
        INSERT_KEY: '555',
        DELETE_KEY: '555',
        NEXT: null
      }
    };
    Map<String, dynamic> note = {'id': NOTE_ID, PARAGRAPHS: paragraphs};

    State state = State();
    state.put('111', {
      'notes': {NOTE_ID: note}
    });

    Map<String, dynamic> payload = {
      CONTENT: 'Some text',
      INSERT_KEY: '777',
      'noteId': NOTE_ID,
      'vaultId': '111'
    };
    Event event = Event(EventType.CREATE_PARAGRAPH, '888', payload);

    // WHEN
    eventHandler.handle(event, state);

    // THEN
    Map<String, dynamic> expectedParagraphs = {
      '777': {
        CONTENT: 'Some text',
        INSERT_KEY: '777',
        DELETE_KEY: '777',
        NEXT: '888'
      },
      '888': {
        CONTENT: 'Some text',
        INSERT_KEY: '888',
        DELETE_KEY: '888',
        NEXT: '555'
      },
      '555': {
        CONTENT: 'Some text',
        INSERT_KEY: '555',
        DELETE_KEY: '555',
        NEXT: null
      }
    };

    Map<String, dynamic> actualNote = state.get('111/notes/$NOTE_ID');
    expect(actualNote[PARAGRAPHS], expectedParagraphs);
  });

  test('''Если вставляется параграф X c "insertKey" != null, в заметку N,
  причем у заметки Y["happenAt"] == X["insertKey"]: Y["next"] != null,
  если N["paragraphs"][Y["next"]]["happenAt"] > X["happenAt"],
  то X["next"] = N["paragraphs"][Y["next"]]["next"], 
     N["paragraphs"][Y["next"]]["next"] = X["happenAt"]''', () {
    // GIVEN
    Map<String, dynamic> paragraphs = {
      '777': {
        CONTENT: 'Some text',
        INSERT_KEY: '777',
        DELETE_KEY: '777',
        NEXT: '555'
      },
      '555': {
        CONTENT: 'Some text',
        INSERT_KEY: '555',
        DELETE_KEY: '555',
        NEXT: null
      }
    };
    Map<String, dynamic> note = {'id': NOTE_ID, PARAGRAPHS: paragraphs};

    State state = State();
    state.put('111', {
      'notes': {NOTE_ID: note}
    });

    Map<String, dynamic> payload = {
      CONTENT: 'Some text',
      INSERT_KEY: '777',
      'noteId': NOTE_ID,
      'vaultId': '111'
    };
    Event event = Event(EventType.CREATE_PARAGRAPH, '444', payload);

    // WHEN
    eventHandler.handle(event, state);

    // THEN
    Map<String, dynamic> expectedParagraphs = {
      '777': {
        CONTENT: 'Some text',
        INSERT_KEY: '777',
        DELETE_KEY: '777',
        NEXT: '555'
      },
      '555': {
        CONTENT: 'Some text',
        INSERT_KEY: '555',
        DELETE_KEY: '555',
        NEXT: '444'
      },
      '444': {
        CONTENT: 'Some text',
        INSERT_KEY: '444',
        DELETE_KEY: '444',
        NEXT: null
      },
    };

    Map<String, dynamic> actualNote = state.get('111/notes/$NOTE_ID');
    expect(actualNote[PARAGRAPHS], expectedParagraphs);
  });
}
