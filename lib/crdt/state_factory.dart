import 'package:notez/common/log.dart';
import 'package:notez/crdt/state.dart';

import 'event/event.dart';
import 'event/event_handler.dart';

/// Фабрика создания состояния
class StateFactory {
    final Map<EventType, EventHandler> handlers = {};

    StateFactory(List<EventHandler> handlers) {
      for (EventHandler handler in handlers) {
        this.handlers[handler.type] = handler;
      }
      log.info('Найдено ${handlers.length} обработчиков событий');
    }

    State createState(List<Event> events) {
      State state = State();
      for (Event e in events) {
        _handle(e, state);
      }
      return state;
    }

    void _handle(Event event, State state) {
      if (handlers.containsKey(event.type)) {
        handlers[event.type]!.handle(event, state);
      } else {
        throw Exception("Не найден обработчик для типа события - ${event.type}");
      }
    }
}