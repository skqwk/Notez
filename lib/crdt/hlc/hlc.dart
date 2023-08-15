import 'package:notez/crdt/hlc/hybrid_timestamp.dart';

class HLC {
  static late HLC? _instance;

  late HybridTimestamp _latestTime;
  late String _nodeId;

  HybridTimestamp get latestTime => _latestTime;

  HLC(int wallClockTime, String nodeId) {
    _latestTime = HybridTimestamp(wallClockTime, 0, nodeId);
    _nodeId = nodeId;
  }

  /// <b>(2) Отправка или локальное событие на узле</b>
  /// <br>
  /// Каждый раз, когда произошло локальное событие, гибридная метка времени сопоставляется с изменением.
  /// Нужно сравнить системное время узла и события, если узел отстает, тогда увеличить логическую часть
  /// компонента [ticks], чтобы отразить ход часов.
  HybridTimestamp now() {
    int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
    if (_latestTime.wallClockTime >= currentTimeMillis) {
      _latestTime = _latestTime.addTicks(1);
    } else {
      _latestTime = HybridTimestamp(currentTimeMillis, 0, _nodeId);
    }
    return _latestTime;
  }

  /// <b>(3) Получение сообщения из удаленного узла</b>
  /// <br>
  /// Данный метод возвращает временную метку с системным временем и логическим компонентом,
  /// yстановленным в -1, но он вернется в 0, после addTicks(1);
  /// [remoteTimestamp] метка из удаленного узла, относительно которой происходит сравнение
  HybridTimestamp tick(HybridTimestamp remoteTimestamp) {
    int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
    HybridTimestamp now = HybridTimestamp.fromSystemTime(currentTimeMillis, _nodeId);

    // Выбираем максимальную временную метку из 3ех:
    // [1] - Текущее системное время
    // [2] - Временная метка другого клиента
    // [3] - Временная метка данного клиента
    _latestTime = _max([now, remoteTimestamp, _latestTime]);
    _latestTime = _latestTime.addTicks(1);

    return _latestTime;
  }

  HybridTimestamp _max(List<HybridTimestamp> times) {
    return times.reduce((t1, t2) => t1.happenedBefore(t2) ? t2 : t1);
  }

  static HLC instance() {
    return _instance!;
  }

  static void init(String nodeId) {
    _instance = HLC(DateTime.now().millisecondsSinceEpoch, nodeId);
  }
}