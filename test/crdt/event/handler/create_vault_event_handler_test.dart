import 'package:flutter_test/flutter_test.dart';
import 'package:notez/crdt/event/event.dart';
import 'package:notez/crdt/event/handler/create_vault_event_handler.dart';
import 'package:notez/crdt/state/state.dart';

void main() {
  CreateVaultEventHandler eventHandler = CreateVaultEventHandler();

  test('Должен обрабатывать соответствующее событие', () {
    expect(eventHandler.type, EventType.CREATE_VAULT);
  });

  test('Должен создавать хранилище и помещать его в State', () {
    // GIVEN
    Map<String, dynamic> payload = {
      'name': 'New vault'
    };
    Event event = Event(EventType.CREATE_VAULT, '4567', payload);
    State state = State();

    // WHEN
    eventHandler.handle(event, state);

    // THEN
    Map<String, dynamic> actualVault = state.get('4567');
    Map<String, dynamic> expectedVault = {
      'id': '4567',
      'deleted': false,
      'name': 'New vault'
    };
    expect(actualVault, expectedVault);
  });
}