import 'package:flutter_test/flutter_test.dart';
import 'package:notez/crdt/event/event.dart';
import 'package:notez/crdt/event/handler/update_vault_event_handler.dart';
import 'package:notez/crdt/state.dart';

void main() {
  UpdateVaultEventHandler eventHandler = UpdateVaultEventHandler();

  test('Должен обрабатывать соответствующее событие', () {
    expect(eventHandler.type, EventType.UPDATE_VAULT);
  });

  test('Должен перезаписывать поля на новые', () {
    // GIVEN
    Map<String, dynamic> payload = {
      'name': 'New vault name',
      'id': '456'
    };
    Event event = Event(EventType.UPDATE_VAULT, '1234', payload);

    Map<String, dynamic> vault = {
      'name': 'Old vault name',
      'deleted': false,
      'id': '456'
    };
    State state = State();
    state.put('456', vault);

    // WHEN
    eventHandler.handle(event, state);

    // THEN
    Map<String, dynamic> actualVault = state.get('456');
    Map<String, dynamic> expectedVault = {
      'name': 'New vault name',
      'deleted': false,
      'id': '456'
    };
    expect(actualVault, expectedVault);
  });
}