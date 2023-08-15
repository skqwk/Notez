/// Гибридная метка времени состоит из двух компонентов:
/// _wallClockTime - поддерживает максимальное значение физического времени, известное на данный момент
/// _ticks - используется для сбора обновлений причинно-следственной связи только тогда, когда значения _wallClockTime равны

/// В [https://cse.buffalo.edu/tech-reports/2014-04.pdf] были использованы следующие обозначения
/// Для события e:
/// _wallClockTime(e) == l.e
/// _ticks(e) == c.e
class HybridTimestamp implements Comparable<HybridTimestamp> {
  final int _wallClockTime;
  final int _ticks;
  final String _nodeId;

  int get wallClockTime => _wallClockTime;

  int get ticks => _ticks;

  String get nodeId => _nodeId;

  HybridTimestamp(this._wallClockTime, this._ticks, this._nodeId);

  // инициализируем с -1, так что addTicks() вернет к 0
  static HybridTimestamp fromSystemTime(int systemTime, String nodeId) =>
      HybridTimestamp(systemTime, -1, nodeId);

  HybridTimestamp max(HybridTimestamp other) {
    if (wallClockTime == other.wallClockTime) {
      return ticks > other.ticks ? this : other;
    }
    return ((wallClockTime > other.wallClockTime) ? this : other);
  }

  HybridTimestamp addTicks(int ticks) =>
      HybridTimestamp(_wallClockTime, this._ticks + ticks, _nodeId);

  // Гибридные метки времени сравниваются в лексикографичеком порядке, т.е:
  // [l.e, c.e] < [l.f, c.f] == true <=> (l.e < l.f) OR ((l.e == l.f) AND (c.e < c.f))
  @override
  int compareTo(HybridTimestamp other) {
    if (wallClockTime != other.wallClockTime) {
      return (wallClockTime - other.wallClockTime).sign;
    }

    if (ticks != other.ticks) {
      return (ticks - other.ticks).sign;
    }

    return nodeId.compareTo(other.nodeId);
  }

  @override
  String toString() =>
      '${DateTime.fromMillisecondsSinceEpoch(_wallClockTime, isUtc: true).toIso8601String()}'
      '-${_ticks.toRadixString(16).toUpperCase().padLeft(4, '0')}'
      '-$_nodeId';

  factory HybridTimestamp.parse(String timestamp) {
    final counterDash = timestamp.indexOf('-', timestamp.lastIndexOf(':'));
    final nodeIdDash = timestamp.indexOf('-', counterDash + 1);

    int wallClockTime = DateTime.parse(timestamp.substring(0, counterDash))
        .millisecondsSinceEpoch;

    int ticks =
        int.parse(timestamp.substring(counterDash + 1, nodeIdDash), radix: 16);

    String nodeId = timestamp.substring(nodeIdDash + 1);
    return HybridTimestamp(wallClockTime, ticks, nodeId);
  }

  bool happenedBefore(HybridTimestamp other) {
    return compareTo(other) < 0;
  }
}
