import 'package:notez/common/generator_id.dart';
import 'package:notez/domain/note.dart';
import 'package:notez/domain/paragraph.dart';

abstract class NoteRepo {
  void addNote(String title, List<String> paragraphs);

  List<Note> getAllNotes();

  void removeNote(String id);
}

class NoteRepoImpl implements NoteRepo {
  final Map<String, Note> notes = {};

  @override
  void addNote(String title, List<String> content) {
    List<Paragraph> paragraphs = content.map(Paragraph.create).toList();
    String noteId = GeneratorId.id();
    Note note = Note(
      id: noteId,
      createdAt: DateTime.now(),
      paragraphs: paragraphs,
      title: title,
    );
    notes[noteId] = note;
  }

  @override
  List<Note> getAllNotes() {
    // TODO: implement getAllNotes
    throw UnimplementedError();
  }

  @override
  void removeNote(String id) {
    if (notes.remove(id) == null) {
      throw Exception();
    }
  }
}
