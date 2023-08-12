import 'package:flutter_test/flutter_test.dart';
import 'package:notez/crdt/event/event.dart';
import 'package:notez/crdt/event/handler/remove_vault_event_handler.dart';
import 'package:notez/crdt/state.dart';

void main() {
  RemoveVaultEventHandler eventHandler = RemoveVaultEventHandler();

  test('Должен обрабатывать соответствующее событие', () {
    expect(eventHandler.type, EventType.REMOVE_VAULT);
  });

  test('При удалении должен помечать хранилище deleted = true', () {
    // GIVEN
    Map<String, dynamic> payload = {
      'id': '1234'
    };
    Event event = Event(EventType.REMOVE_VAULT, '4567', payload);

    Map<String, dynamic> vault = {
      'name': 'New vault',
      'deleted': false,
      'id': '1234'
    };
    State state = State();
    state.put('1234', vault);

    // WHEN
    eventHandler.handle(event, state);

    // THEN
    Map<String, dynamic> actualVault = state.get('1234');
    Map<String, dynamic> expectedVault = {
      'id': '1234',
      'deleted': true,
      'name': 'New vault'
    };
    expect(actualVault, expectedVault);
  });
}