import 'package:flutter_test/flutter_test.dart';
import 'package:notez/crdt/event/event.dart';

void main() {
  test('Названия событий корректно конвертируются в enum', () {
    // GIVEN
    final params = {
      "UPDATE_NOTE": EventType.UPDATE_NOTE,
      "REMOVE_NOTE": EventType.REMOVE_NOTE,
      "CREATE_NOTE": EventType.CREATE_NOTE,
      "CREATE_PARAGRAPH": EventType.CREATE_PARAGRAPH,
    };

    // WHEN | THEN
    params.forEach((stringEvent, expectedEvent) {
      final actual = EventType.values.byName(stringEvent);
      expect(actual, expectedEvent);
    });
  });
}
