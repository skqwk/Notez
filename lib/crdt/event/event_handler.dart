import '../state.dart';
import 'event.dart';

abstract class EventHandler {
  EventType get type;

  void handle(Event event, State state);
}