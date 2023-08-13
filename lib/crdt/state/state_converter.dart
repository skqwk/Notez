import 'package:notez/domain/note.dart';
import 'package:notez/domain/paragraph.dart';
import 'package:notez/domain/vault.dart';

/// Класс для конвертации состояния в конкретные доменные объекты
abstract class StateConverter<T> {
  T? convert(Map<String, dynamic> state);
}

class VaultStateConverter extends StateConverter<Vault> {
  final StateConverter<Note> noteConverter;

  VaultStateConverter(this.noteConverter);

  @override
  Vault? convert(Map<String, dynamic> state) {
    if (state['deleted']) {
      return null;
    }

    String id = state['id'];
    String name = state['name'];
    Vault vault = Vault(id, name);

    Map<String, Map<String, dynamic>> notes = state['notes'];
    List<Note> convertedNotes =
        notes.values.map(noteConverter.convert).nonNulls.toList();

    vault.notes.addAll(convertedNotes);
    return vault;
  }
}

class NoteStateConverter extends StateConverter<Note> {
  final StateConverter<List<Paragraph>> paragraphListConverter;

  NoteStateConverter(this.paragraphListConverter);

  @override
  Note? convert(Map<String, dynamic> state) {
    if (state['deleted']) {
      return null;
    }
    String id = state['id'];
    String color = state['color'];
    String title = state['title'];
    DateTime created = DateTime.parse(state['createdAt']);

    bool headExist = state['head'] != null;

    List<Paragraph> paragraphs =
        headExist ? paragraphListConverter.convert(state)! : [];

    Note note = Note(
      id: id,
      createdAt: created,
      title: title,
      paragraphs: paragraphs,
      color: color,
    );

    return note;
  }
}

class ParagraphListStateConverter extends StateConverter<List<Paragraph>> {
  final StateConverter<Paragraph> paragraphStateConverter;

  ParagraphListStateConverter(this.paragraphStateConverter);

  @override
  List<Paragraph> convert(Map<String, dynamic> state) {
    String? head = state['head'];
    if (head == null ) {
      return [];
    }

    Map<String, Map<String, dynamic>> paragraphs = state['paragraphs'];

    Map<String, dynamic>? nowParagraph = paragraphs[head];

    List<Paragraph> convertedParagraphs = [];
    while(nowParagraph != null) {
      if (nowParagraph['content'] != null) {
        Paragraph converted = paragraphStateConverter.convert(nowParagraph)!;
        convertedParagraphs.add(converted);
      }
      nowParagraph = paragraphs[nowParagraph['next']];
    }
    return convertedParagraphs;
  }
}

class ParagraphStateConverter extends StateConverter<Paragraph> {
  @override
  Paragraph? convert(Map<String, dynamic> state) {
    String id = state['insertKey'];
    String content = state['content'];
    return Paragraph(id, content);
  }
}
