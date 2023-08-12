import 'package:notez/crdt/event/event.dart';
import 'package:notez/crdt/event/event_handler.dart';
import 'package:notez/crdt/state.dart';

class CreateParagraphEventHandler implements EventHandler {
  static const String INSERT_KEY = 'insertKey';
  static const String DELETE_KEY = 'deleteKey';
  static const String CONTENT = 'content';
  static const String NEXT = 'next';
  static const String HEAD = 'head';
  static const String PARAGRAPHS = 'paragraphs';
  static const String HAPPEN_AT = 'happenAt';

  @override
  void handle(Event event, State state) {
    Map<String, dynamic> payload = event.payload;
    Map<String, dynamic> paragraph = {
      INSERT_KEY: event.happenAt,
      DELETE_KEY: event.happenAt,
      CONTENT: payload[CONTENT],
      NEXT: null,
    };

    String noteId = payload['noteId']!;
    Map<String, dynamic> note = state.get(noteId);
    Map<dynamic, dynamic> paragraphs = note[PARAGRAPHS];

    Map<String, dynamic> previousParagraph;
    // TODO: отрефакторить с применением стратегии fail-fast
    // Параграф вставляется за другим параграфом
    if (payload[INSERT_KEY] != null) {
      previousParagraph = paragraphs[payload[INSERT_KEY]];
    } else {
      // Параграф вставляется в начало
      if (_canReplaceHead(note, paragraph)) {
        _replaceHeadParagraph(note, paragraph);
        return;
      } else {
        previousParagraph = paragraphs[note[HEAD]];
      }
    }

    while (previousParagraph[NEXT] != null &&
        _lessThan(
          paragraph[INSERT_KEY],
          paragraphs[previousParagraph[NEXT]][INSERT_KEY],
        )) {
      previousParagraph = paragraphs[previousParagraph[NEXT]];
    }

    paragraph[NEXT] = previousParagraph[NEXT];
    previousParagraph[NEXT] = paragraph[INSERT_KEY];
    paragraphs[paragraph[INSERT_KEY]] = paragraph;
  }

  bool _canReplaceHead(
      Map<String, dynamic> note, Map<String, dynamic> paragraph) {
    return note[HEAD] == null ||
        _lessThan(note[HEAD], paragraph[INSERT_KEY]);
  }

  void _replaceHeadParagraph(
      Map<String, dynamic> note,
      Map<String, dynamic> paragraph,
      ) {
    Map<dynamic, dynamic> paragraphs = note[PARAGRAPHS];
    if (note[HEAD] != null) {
      paragraph[NEXT] = note[HEAD];
    }
    note[HEAD] = paragraph[INSERT_KEY];
    paragraphs[paragraph[INSERT_KEY]] = paragraph;
  }

  bool _lessThan(String firstTimestamp, String secondTimestamp) {
    return firstTimestamp.compareTo(secondTimestamp) < 0;
  }

  @override
  EventType get type => EventType.CREATE_PARAGRAPH;
}