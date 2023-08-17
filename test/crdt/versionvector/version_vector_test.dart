import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:notez/crdt/hlc/hybrid_timestamp.dart';
import 'package:notez/crdt/versionvector/version_vector.dart';

import '../../fixture/fixture_reader.dart';

void main() {
  group('''Вектор версий должен расчитывать разницу (diff)
    между удаленным и локальным экземпляром''', () {

    test("когда на сервере нет никакой информации с узла", () {
      // GIVEN
      String node1 = "556a4927-b728-4c90-8d87-f14f26a2b5ee";
      String node2 = "4dbe409c-22ed-4783-a0fc-e89be8744c9e";

      VersionVector local = VersionVector([
        HybridTimestamp.parse(
            "2023-04-26T04:48:47.770Z-0000-556a4927-b728-4c90-8d87-f14f26a2b5ee"),
        HybridTimestamp.parse(
            "2023-04-19T14:28:37.140Z-0100-4dbe409c-22ed-4783-a0fc-e89be8744c9e")
      ]);

      VersionVector remote = VersionVector([]);

      // WHEN
      VersionVector diff = local.diff(remote);

      // THEN
      expect(diff.stamps[node1].toString(),
          '1970-01-01T00:00:00.000Z-0000-556a4927-b728-4c90-8d87-f14f26a2b5ee');
      expect(diff.stamps[node2].toString(),
          '1970-01-01T00:00:00.000Z-0000-4dbe409c-22ed-4783-a0fc-e89be8744c9e');
    });

    test("когда на сервере неактуальная информация с узла", () {
      // GIVEN
      var node1 = "556a4927-b728-4c90-8d87-f14f26a2b5ee";
      var node2 = "4dbe409c-22ed-4783-a0fc-e89be8744c9e";

      VersionVector local = VersionVector([
        HybridTimestamp.parse(
            "2023-04-26T04:48:47.770Z-0000-556a4927-b728-4c90-8d87-f14f26a2b5ee"),
        HybridTimestamp.parse(
            "2023-04-19T14:28:37.140Z-0100-4dbe409c-22ed-4783-a0fc-e89be8744c9e")
      ]);

      VersionVector remote = VersionVector([
        HybridTimestamp.parse(
            "2023-04-26T02:48:47.770Z-0000-556a4927-b728-4c90-8d87-f14f26a2b5ee"),
        HybridTimestamp.parse(
            "2023-04-19T10:28:37.140Z-0100-4dbe409c-22ed-4783-a0fc-e89be8744c9e")
      ]);

      // WHEN
      VersionVector diff = local.diff(remote);

      expect(diff.stamps[node1].toString(),
          "2023-04-26T02:48:47.770Z-0000-556a4927-b728-4c90-8d87-f14f26a2b5ee");
      expect(diff.stamps[node2].toString(),
          "2023-04-19T10:28:37.140Z-0100-4dbe409c-22ed-4783-a0fc-e89be8744c9e");
    });

    test("когда на локальном узле неактуальная информация с узла", () {
      // GIVEN
      VersionVector remote = VersionVector([
        HybridTimestamp.parse(
            "2023-04-26T04:48:47.770Z-0000-556a4927-b728-4c90-8d87-f14f26a2b5ee"),
        HybridTimestamp.parse(
            "2023-04-19T14:28:37.140Z-0100-4dbe409c-22ed-4783-a0fc-e89be8744c9e")
      ]);

      VersionVector local = VersionVector([
        HybridTimestamp.parse(
            "2023-04-26T02:48:47.770Z-0000-556a4927-b728-4c90-8d87-f14f26a2b5ee"),
        HybridTimestamp.parse(
            "2023-04-19T10:28:37.140Z-0100-4dbe409c-22ed-4783-a0fc-e89be8744c9e")
      ]);

      // WHEN | THEN
      expect(local.diff(remote).stamps.isEmpty, true);
    });
  });

  group('Векто версий должен расчитывать объединение (merge) векторов версий', () {
    test('когда векторы версий оба содержат уникальные значения', () {
      // GIVEN
      String node1 = "556a4927-b728-4c90-8d87-f14f26a2b5ee";
      String time1 = "2023-04-26T04:48:47.770Z-0000-556a4927-b728-4c90-8d87-f14f26a2b5ee";

      String node2 = "4dbe409c-22ed-4783-a0fc-e89be8744c9e";
      String time2 = "2023-04-19T14:28:37.140Z-0100-4dbe409c-22ed-4783-a0fc-e89be8744c9e";

      VersionVector local = VersionVector([
        HybridTimestamp.parse(time1),
        HybridTimestamp.parse(time2)
      ]);

      String node3 = "3f570240-caa4-47e5-9be0-13df707a1dd8";
      String time3 = "2023-04-26T04:46:45.680Z-0000-3f570240-caa4-47e5-9be0-13df707a1dd8";

      String node4 = "a69c4a8f-caa6-4ae6-8f03-cb75561400d6";
      String time4 = "2023-04-26T04:46:12.680Z-0000-a69c4a8f-caa6-4ae6-8f03-cb75561400d6";

      VersionVector remote = VersionVector([
        HybridTimestamp.parse(time3),
        HybridTimestamp.parse(time4)
      ]);

      // WHEN
      VersionVector merge = local.merge(remote);

      // THEN
      expect(merge.stamps[node1].toString(),time1);
      expect(merge.stamps[node2].toString(), time2);
      expect(merge.stamps[node3].toString(), time3);
      expect(merge.stamps[node4].toString(), time4);
    });
    
    test('когда на сервере/клиенте содержится неактуальная информация', () {
      // GIVEN
      String node1 = "556a4927-b728-4c90-8d87-f14f26a2b5ee";
      String localTime1 = "2023-04-26T04:48:47.770Z-0000-556a4927-b728-4c90-8d87-f14f26a2b5ee";

      String node2 = "4dbe409c-22ed-4783-a0fc-e89be8744c9e";
      String localTime2 = "2023-04-19T14:28:37.140Z-0100-4dbe409c-22ed-4783-a0fc-e89be8744c9e";

      VersionVector local = VersionVector([
        HybridTimestamp.parse(localTime1),
        HybridTimestamp.parse(localTime2)
      ]);

      String remoteTime1 = "2023-04-27T04:46:45.680Z-0000-556a4927-b728-4c90-8d87-f14f26a2b5ee";
      String remoteTime2 = "2023-04-18T04:46:12.680Z-0000-4dbe409c-22ed-4783-a0fc-e89be8744c9e";

      VersionVector remote = VersionVector([
        HybridTimestamp.parse(remoteTime1),
        HybridTimestamp.parse(remoteTime2)
      ]);

      // WHEN
      VersionVector merge = local.merge(remote);

      // THEN
      expect(HybridTimestamp.parse(localTime1).happenedBefore(HybridTimestamp.parse(remoteTime1)), true);
      expect(HybridTimestamp.parse(remoteTime2).happenedBefore(HybridTimestamp.parse(localTime2)), true);

      expect(merge.stamps[node1].toString(), remoteTime1);
      expect(merge.stamps[node2].toString(), localTime2);
    });
  });

  test('Должен корректно преобразовываться из списка json', () {
    // GIVEN | WHEN
    VersionVector result =  VersionVector.fromJson(jsonDecode(fixture('version_vector.json')));

    // THEN
    expect(result.stamps.length, 3);
    expect(result.stamps.keys.contains('node1'), isTrue);
    expect(result.stamps.keys.contains('node2'), isTrue);
    expect(result.stamps.keys.contains('node3'), isTrue);
  });
}
