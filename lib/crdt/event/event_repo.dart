import 'package:notez/crdt/event/event.dart';
import 'package:notez/crdt/hlc/hybrid_timestamp.dart';

abstract class EventRepo {
  void saveEvents(List<Event> event);

  List<Event> getEventsHappenAfter(HybridTimestamp timestamp);
}