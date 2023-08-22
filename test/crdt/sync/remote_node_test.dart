import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notez/common/config.dart';
import 'package:notez/common/exception.dart';
import 'package:notez/crdt/event/event.dart';
import 'package:notez/crdt/hlc/hybrid_timestamp.dart';
import 'package:notez/crdt/sync/remote_node.dart';
import 'package:notez/crdt/versionvector/version_vector.dart';

import '../../fixture/fixture_reader.dart';

class MockClient extends Mock implements Client {}

void main() {
  const SYNC = "sync";
  const SHARE = "share";
  const HEADERS = {'Content-Type': 'application/json'};

  late RemoteNode remoteNode;
  late Config config;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    config = Config(SYNC, SHARE);

    remoteNode = HttpRemoteNode(mockHttpClient, config);
  });

  group('При получении состояния удаленного узла', () {
    test('в случае успеха должен вернуть его', () async {
      // GIVEN
      HybridTimestamp stamp = HybridTimestamp(0, 0, 'nodeId');
      when(() => mockHttpClient
              .post(Uri.http(SYNC), headers: HEADERS, body: [stamp.toString()]))
          .thenAnswer((_) async => Response(fixture('remote_state.json'), 200));

      VersionVector versionVector = VersionVector([stamp]);

      // WHEN
      RemoteState? actual = await remoteNode.getRemoteState(versionVector);

      // THEN
      expect(actual, isNotNull);
      expect(actual!.missingEvents.length, 4);
    });

    test('в случае ошибки должен вернуть null', () async {
      // GIVEN
      HybridTimestamp stamp = HybridTimestamp(0, 0, 'nodeId');
      when(() => mockHttpClient.post(Uri.http(SYNC),
          headers: HEADERS,
          body: [stamp.toString()])).thenAnswer((_) async => Response("", 400));

      VersionVector versionVector = VersionVector([stamp]);

      // WHEN
      RemoteState? actual = await remoteNode.getRemoteState(versionVector);

      // THEN
      expect(actual, isNull);
    });

    test('в случае исключения должен вернуть null', () async {
      // GIVEN
      HybridTimestamp stamp = HybridTimestamp(0, 0, 'nodeId');
      when(() {
        return mockHttpClient
            .post(Uri.http(SYNC), headers: HEADERS, body: [stamp.toString()]);
      }).thenThrow(Exception("Возникла ошибка"));

      VersionVector versionVector = VersionVector([stamp]);

      // WHEN
      RemoteState? actual = await remoteNode.getRemoteState(versionVector);

      // THEN
      expect(actual, isNull);
    });
  });

  group('При отправке событий на удаленный узел', () {
    test('в случае успешного ответа должен корректно завершиться', () async {
      // GIVEN
      String rawEvents = fixture('events.json');
      List<Map<String, dynamic>> jsonEvents = List.castFrom(jsonDecode(rawEvents));
      List<Event> events = jsonEvents.map(Event.fromJson).toList();

      when(() => mockHttpClient.post(Uri.http(SHARE),
            headers: HEADERS, body: jsonEncode(events)))
          .thenAnswer((_) async => Response("", 200));

      // WHEN | THEN
      await remoteNode.sendLocalEvents(events);
    });

    test('в случае исключения должен залогировать исключение и перебросить его', () async {
      // GIVEN
      String rawEvents = fixture('events.json');
      List<Map<String, dynamic>> jsonEvents = List.castFrom(jsonDecode(rawEvents));
      List<Event> events = jsonEvents.map(Event.fromJson).toList();

      when(() => mockHttpClient.post(Uri.http(SHARE),
          headers: HEADERS, body: jsonEncode(events)))
          .thenThrow(Exception("Возникла ошибка"));

      // WHEN
      final call = remoteNode.sendLocalEvents;
      
      // THEN
      await expectLater(call(events), throwsA(isA<RemoteNodeException>()));
    });

    test('в случае неуспешного ответа должен залогировать его и выбросить исключение', () async {
      // GIVEN
      String rawEvents = fixture('events.json');
      List<Map<String, dynamic>> jsonEvents = List.castFrom(jsonDecode(rawEvents));
      List<Event> events = jsonEvents.map(Event.fromJson).toList();

      when(() => mockHttpClient.post(Uri.http(SHARE),
          headers: HEADERS, body: jsonEncode(events)))
          .thenAnswer((_) async => Response("", 400));

      // WHEN
      final call = remoteNode.sendLocalEvents;

      // THEN
      await expectLater(call(events), throwsA(isA<RemoteNodeException>()));
    });
  });
}
