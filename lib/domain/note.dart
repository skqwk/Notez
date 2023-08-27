import 'package:notez/domain/paragraph.dart';

class Note {
  final String id;
  final DateTime createdAt;
  final List<Paragraph> paragraphs = [];
  final String title;
  String color;

  Note({
    required this.id,
    required this.createdAt,
    required this.title,
    this.color = "",
  });
}
