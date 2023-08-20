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
      Response response = await httpClient.post(Uri.http(config.syncUrl),
          headers: HEADERS, body: local.toJson());

      if (response.statusCode == SUCCESS) {
        log.info("Получен ответ от удаленного узла: ${response.body}");
        return RemoteState.fromJson(jsonDecode(response.body));
      }
    } on Exception catch (e) {
      log.error("Ошибка при получении состояния удаленного узла: $e");
      return null;
    }
    return null;
  }

  @override
  Future<void> sendLocalEvents(List<Event> missingEvents) async {
    try {
      Response response = await httpClient.post(Uri.http(config.shareUrl),
          headers: HEADERS, body: jsonEncode(missingEvents));
      if (response.statusCode == SUCCESS) {
        log.info("События успешно отправлены");
      } else {
        throw RemoteNodeException(
            "Ошибка при отправке событий. Код ответа - ${response.statusCode}");
      }
    } on Exception catch (e) {
      log.error("Ошибка при отправке событий: $e");
      throw RemoteNodeException("Ошибка при отправке событий. Исключение - $e");
    }
  }
}

class RemoteNodeException implements Exception {
  String? message;

  RemoteNodeException([this.message]);
}
