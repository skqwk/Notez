import 'package:flutter_test/flutter_test.dart';
import 'package:notez/crdt/hlc/hybrid_timestamp.dart';

void main() {
  test("должен корректно переводится в строку", () {
    // GIVEN
    var datetime = '2023-04-25T19:10:07.914Z';
    var wallClockTime = DateTime.parse(datetime).millisecondsSinceEpoch;
    var ticks = 255;
    var nodeId = 'node1';

    // WHEN
    var timestamp = HybridTimestamp(wallClockTime, ticks, nodeId);

    // THEN
    var expectedTimestamp = '2023-04-25T19:10:07.914Z-00FF-node1';

    expect(timestamp.toString(), expectedTimestamp);
  });

  test("должен корректно парситься", () {
    // GIVEN
    var timestamp = '2023-04-25T19:10:07.914Z-0000-node1';

    // WHEN
    var parsedTimestamp = HybridTimestamp.parse(timestamp);

    // THEN
    expect(parsedTimestamp.toString(), timestamp);
    expect(parsedTimestamp.wallClockTime,
        DateTime.parse('2023-04-25T19:10:07.914Z').millisecondsSinceEpoch);
    expect(parsedTimestamp.ticks, 0);
    expect(parsedTimestamp.nodeId, 'node1');
  });

  group("должен корректно сравниваться с другими временными метками, ", () {
    test("если метки имеют разное физическое время", () {
      // GIVEN
      var t1 = HybridTimestamp.parse('2023-04-25T19:10:07.914Z-0001-node1');
      var t2 = HybridTimestamp.parse('2023-04-25T20:10:07.914Z-0002-node2');

      // WHEN | THEN
      expect(t1.compareTo(t2), -1);
      expect(t2.compareTo(t1), 1);
    });

    test("если метки имеют одинаковое физическое время, но разное логическое",
        () {
      // GIVEN
      var t1 = HybridTimestamp.parse('2023-04-25T19:10:07.914Z-0001-node1');
      var t2 = HybridTimestamp.parse('2023-04-25T19:10:07.914Z-0002-node2');

      // WHEN | THEN
      expect(t1.compareTo(t2), -1);
      expect(t2.compareTo(t1), 1);
    });

    test(
        "если метки имеют одинаковое физическое время  и логическое, но разные узлы",
        () {
      // GIVEN
      var t1 = HybridTimestamp.parse('2023-04-25T19:10:07.914Z-0002-node1');
      var t2 = HybridTimestamp.parse('2023-04-25T19:10:07.914Z-0002-node2');

      // WHEN | THEN
      expect(t1.compareTo(t2), -1);
      expect(t2.compareTo(t1), 1);
    });
  });

  test("должен корректно определять отношение 'happened before'", () {
    // GIVEN
    var t1 = HybridTimestamp.parse('2023-04-25T19:10:07.914Z-0002-node1');
    var t2 = HybridTimestamp.parse('2023-04-25T19:10:07.914Z-0002-node2');
    var t3 = HybridTimestamp.parse('2023-04-25T19:10:07.914Z-0003-node2');

    // WHEN | THEN
    expect(t1.happenedBefore(t2), true);
    expect(t2.happenedBefore(t3), true);
    expect(t1.happenedBefore(t3), true);

    expect(t2.happenedBefore(t1), false);
    expect(t3.happenedBefore(t1), false);

    expect(t1.happenedBefore(t1), false);
  });

  test("должен инкрементировать логическое время", () {
    // GIVEN
    var t1 = HybridTimestamp.parse('2023-04-25T19:10:07.914Z-0002-node1');

    // WHEN
    var t2 = t1.addTicks(2);

    // THEN
    expect(t1 != t2, true);
    expect(t1.happenedBefore(t2), true);
    expect(t2.toString(), '2023-04-25T19:10:07.914Z-0004-node1');
  });

  test("должен сравниваться лексикографически, также как и логически", () {
    // GIVEN
    var t0 = "2023-04-25T10:10:07.914Z-0002-node1";
    var t1 = "2023-04-25T19:10:07.914Z-0002-node1";
    var t2 = "2023-04-25T19:10:07.914Z-0002-node1";
    var t3 = "2023-04-25T19:10:07.914Z-0002-node2";
    var t4 = "2023-04-25T19:15:07.914Z-0002-node1";

    var ht0 = HybridTimestamp.parse(t0);
    var ht1 = HybridTimestamp.parse(t1);
    var ht2 = HybridTimestamp.parse(t2);
    var ht3 = HybridTimestamp.parse(t3);
    var ht4 = HybridTimestamp.parse(t4);

    // WHEN | THEN
    expect(ht0.compareTo(ht1), t0.compareTo(t1));
    expect(ht2.compareTo(ht1), t2.compareTo(t1));
    expect(ht2.compareTo(ht3), t2.compareTo(t3));
    expect(ht3.compareTo(ht4), t3.compareTo(t4));
  });
}
