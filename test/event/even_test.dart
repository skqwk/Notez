import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:notez/crdt/event/event.dart';

void main() {
  test('Событие должно конвертироваться из Json', () {
    // GIVEN
    String json =
        '{"payload": {"id": 123, "insertKey": 456}, "happenAt": "1234", "type": "UPDATE_NOTE"}';

    // WHEN
    Event event = Event.fromJson(jsonDecode(json));

    // THEN
    expect({"id": 123, "insertKey": 456}, event.payload);
    expect("1234", event.happenAt);
    expect(EventType.UPDATE_NOTE, event.type);
  });

  test('Событие должно конвертироваться в Json', () {
    // GIVEN
    Event event =
        Event(EventType.UPDATE_NOTE, "1234", {"id": 123, "insertKey": 456});

    // WHEN
     String json = jsonEncode(event.toJson());

    // THEN
    String expectedJson =
        '{"type":"UPDATE_NOTE","happenAt":"1234","payload":{"id":123,"insertKey":456}}';
    expect(json, expectedJson);
  });
}
