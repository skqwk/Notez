import 'package:notez/crdt/event/event.dart';
import 'package:notez/crdt/event/event_handler.dart';
import 'package:notez/crdt/state.dart';

class RemoveParagraphEventHandler extends EventHandler {
  @override
  void handle(Event event, State state) {
    Map<String, dynamic> payload = event.payload;
    String deleteKey = payload['deleteKey'];
    String noteId = payload['noteId']!;
    String vaultId = payload['vaultId']!;
    Map<String, dynamic> note = state.get('$vaultId/notes/$noteId');
    Map<String, dynamic>? paragraph = note['paragraphs'][deleteKey];

    if (paragraph == null ) {
      throw Exception('Попытка удалить несуществующий параграф с id = $deleteKey');
    } else if (paragraph['content'] != null) {
      paragraph['content'] = null;
      paragraph['deleteKey'] = event.happenAt;
    }
  }

  @override
  EventType get type => EventType.REMOVE_PARAGRAPH;
}