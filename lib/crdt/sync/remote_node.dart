import 'package:notez/crdt/event/event.dart';
import 'package:notez/crdt/versionvector/version_vector.dart';

/// Абстрактный удаленный узел
abstract class RemoteNode {
  /// Получить состояние удаленного узла на основе
  /// локального вектора версий [local]
  RemoteState? getRemoteState(VersionVector local);

  /// Отправить недостающие локальные события [missingEvents]
  /// на удаленный узел
  void sendLocalEvents(List<Event> missingEvents);
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
}
