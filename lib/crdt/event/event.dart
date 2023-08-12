class Event {
  final EventType type;
  final String happenAt;
  final Map<String, dynamic> payload;

  Event(this.type, this.happenAt, this.payload);

  Map<String, dynamic> toJson() {
    return {
      "type": type.name,
      "happenAt": happenAt,
      "payload": payload
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      EventType.fromString(json['type']),
      json['happenAt'],
      json['payload'],
    );
  }
}

enum EventType {
  CREATE_NOTE(value: 'Создать заметку'),
  UPDATE_NOTE(value: 'Обновить заметку'),
  REMOVE_NOTE(value: 'Удалить заметку'),
  CREATE_PARAGRAPH(value: 'Создать параграф'),
  UPDATE_PARAGRAPH(value: 'Обновить параграф'),
  REMOVE_PARAGRAPH(value: 'Удалить параграф'),
  CREATE_VAULT(value: 'Создать хранилище'),
  UPDATE_VAULT(value: 'Обновить хранилище'),
  REMOVE_VAULT(value: 'Удалить хранилище');

  final String value;

  const EventType({required this.value});

  factory EventType.fromString(String name) => EventType.values.byName(name);
}
