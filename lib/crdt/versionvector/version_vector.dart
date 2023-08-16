import 'package:notez/crdt/hlc/hybrid_timestamp.dart';

/// Вектор версий предназначен для хранения на каждом узле
/// информации об актуальных значениях временных меток
///
/// Каждый узел может обладать разным состоянием и при синхронизации
/// узлов необходимо, чтобы состояние узлов сходилось к одному
///
/// Для этого используется две операции: [merge], [diff]
class VersionVector {
  final Map<String, HybridTimestamp> _stamps = {};

  Map<String, HybridTimestamp> get stamps => _stamps;

  VersionVector(List<HybridTimestamp> stamps) {
    for (HybridTimestamp stamp in stamps) {
      _stamps[stamp.nodeId] = stamp;
    }
  }

  /// Принимает вектор версий [other] с удаленного узла
  /// Возвращает вектор версий, который содержит и локальные метки
  /// и удаленные, если метки относятся к одному узлу - выбирает максимальное
  VersionVector merge(VersionVector other) {
    Set<String> nodeIds = {...other.stamps.keys, ...stamps.keys};

    List<HybridTimestamp> mergedStamps = nodeIds
        .map((nodeId) => _max([other.stamps[nodeId], stamps[nodeId]]))
        .toList();

    return VersionVector(mergedStamps);
  }

  HybridTimestamp _max(List<HybridTimestamp?> stamps) {
    return stamps.nonNulls.reduce((t1, t2) => t1.max(t2));
  }

  /// Принимает вектор версий [other] с удаленного узла
  /// Возвращает вектор версий, по которому определяется событии с какими
  /// метками нужно отправить при синхронизации
  ///
  /// Возможно несколько кейсов:
  ///
  /// 1. Если на удаленном узле нет никакой информации об одном из узлов
  /// => значит нужно отдать все события данного узла
  ///
  /// 2. Если на удаленном узле устаревшие события с одного из услов
  /// => значит нужно отдать все события данного узла,
  /// к-е старше версии удаленного узла
  ///
  /// 3. Если на удаленном узле события для конкретного узла актуальнее,
  /// чем локальные события => ничего делать не нужно
  VersionVector diff(VersionVector other) {
    List<HybridTimestamp> convertedStamps = [];

    for (String nodeId in stamps.keys) {
      if (other.stamps[nodeId] != null) {
        if (other.stamps[nodeId]!.happenedBefore(stamps[nodeId]!)) {
          convertedStamps.add(other.stamps[nodeId]!);
        }
      } else {
        convertedStamps.add(HybridTimestamp(0, 0, nodeId));
      }
    }

    return VersionVector(convertedStamps);
  }
}
