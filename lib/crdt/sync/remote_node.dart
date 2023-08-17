import 'dart:convert';

import 'package:http/http.dart';
import 'package:notez/common/config.dart';
import 'package:notez/common/log.dart';
import 'package:notez/crdt/event/event.dart';
import 'package:notez/crdt/versionvector/version_vector.dart';

/// Абстрактный удаленный узел
abstract class RemoteNode {
  /// Получить состояние удаленного узла на основе
  /// локального вектора версий [local]
  Future<RemoteState?> getRemoteState(VersionVector local);

  /// Отправить недостающие локальные события [missingEvents]
  /// на удаленный узел
  Future<void> sendLocalEvents(List<Event> missingEvents);
}

class RemoteState {
  /// Недостающие события
  final List<Event> missingEvents;

  /// Удаленный вектор версий
  final VersionVector remoteVector;

  RemoteState(
    this.missingEvents,
    this.remoteVector,
  );

  factory RemoteState.fromJson(Map<String, dynamic> json) {
    return RemoteState(
      _events(json['events']),
      VersionVector.fromJson(json['versionVector']),
    );
  }

  static List<Event> _events(List<dynamic> jsonEvents) {
    return jsonEvents
        .map((event) => Event.fromJson(Map.castFrom(event)))
        .toList();
  }
}

class HttpRemoteNode implements RemoteNode {
  static const int SUCCESS = 200;
  static const Map<String, String> HEADERS = {
    'Content-Type': 'application/json'
  };

  final Client httpClient;
  final Config config;

  HttpRemoteNode(
    this.httpClient,
    this.config,
  );

  @override
  Future<RemoteState?> getRemoteState(VersionVector local) async {
    try {
      Response response = await httpClient.get(
        Uri.http(config.syncUrl),
        headers: HEADERS,
      );

      if (response.statusCode == SUCCESS) {
        log.info("Получен ответ от удаленного узла: ${response.body}");
      } else {
        return RemoteState.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  @override
  Future<void> sendLocalEvents(List<Event> missingEvents) async {

  }
}
