import 'package:flutter_test/flutter_test.dart';
import 'package:notez/crdt/hlc/hlc.dart';
import 'package:notez/crdt/hlc/hybrid_timestamp.dart';

void main() {
  setUp(() => HLC.init("nodeId"));

  test('Метод instance возвращает каждый раз один и тот же объект', () {
    expect(HLC.instance(), HLC.instance());
  });

  test('Метод now() всегда создает новую гибридную метку с большим значением', () {
    // GIVEN
    HLC clock = HLC.instance();
    HybridTimestamp first = clock.latestTime;

    // WHEN | THEN
    expect(first.happenedBefore(clock.now()), true);
  });

}