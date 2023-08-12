import 'package:notez/domain/paragraph.dart';

class Note {
  final String id;
  final DateTime created;
  final List<Paragraph> paragraphs;
  bool deleted;
  String color;

  Note({
    required this.id,
    required this.created,
    this.paragraphs = const [],
    this.deleted = false,
    this.color = "",
  });
}
