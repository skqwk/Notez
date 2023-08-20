import 'package:notez/crdt/event/event.dart';
import 'package:notez/crdt/hlc/hybrid_timestamp.dart';

abstract class EventRepo {
  void saveEvents(List<Event> events);

  List<Event> getEventsHappenAfter(HybridTimestamp timestamp);
}

class InMemoryEventRepo implements EventRepo {
  final List<Event> events = [];

  @override
  List<Event> getEventsHappenAfter(HybridTimestamp timestamp) {
    return events
        .where((event) => HybridTimestamp.parse(event.happenAt).happenedAfter(timestamp))
        .toList();
  }

  @override
  void saveEvents(List<Event> events) {
    this.events.addAll(events);
  }
}