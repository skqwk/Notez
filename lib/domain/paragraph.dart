import 'package:notez/common/generator_id.dart';

class Paragraph {
  final String id;
  final String content;

  Paragraph(this.id, this.content);

  factory Paragraph.create(String content) {
    return Paragraph(GeneratorId.id(), content);
  }
}