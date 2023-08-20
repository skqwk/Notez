import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:notez/crdt/sync/remote_node.dart';

import '../../fixture/fixture_reader.dart';

void main() {
  test('Состояние удаленного узла должно корректно конвертироваться из json', () {
    // GIVEN | WHEN
    RemoteState result = RemoteState.fromJson(jsonDecode(fixture('remote_state.json')));
    
    // THEN
    expect(result.missingEvents.length, 4);
    expect(result.remoteVector.stamps.length, 3);
  });
}