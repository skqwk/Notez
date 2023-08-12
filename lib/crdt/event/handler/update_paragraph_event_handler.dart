import 'package:notez/crdt/event/event.dart';
import 'package:notez/crdt/event/event_handler.dart';
import 'package:notez/crdt/state.dart';

class UpdateParagraphEventHandler implements EventHandler {
  static const String HAPPEN_AT = 'happenAt';
  static const String CONTENT = 'content';
  static const String DELETE_KEY = 'deleteKey';
  static const String UPDATE_KEY = 'updateKey';
  static const String NOTE_ID = 'noteId';
  static const String VAULT_ID = 'vaultId';
  static const String PARAGRAPHS = 'paragraphs';

  @override
  void handle(Event event, State state) {
    Map<String, dynamic> payload = event.payload;
    String noteId = payload[NOTE_ID]!;
    String vaultId = payload[VAULT_ID]!;
    Map<String, dynamic> note = state.get('$vaultId/notes/$noteId');

    Map<String, dynamic> paragraph = note[PARAGRAPHS][payload[UPDATE_KEY]];
    if (paragraph[CONTENT] == null) {
      return;
    }
    String happenAt = event.happenAt;
    if (happenAt.compareTo(paragraph[DELETE_KEY]) < 0) {
      return;
    }

    paragraph[CONTENT] = payload[CONTENT];
    paragraph[DELETE_KEY] = happenAt;
  }

  @override
  EventType get type => EventType.UPDATE_PARAGRAPH;
}
