import 'package:notez/domain/note.dart';
import 'package:notez/domain/paragraph.dart';
import 'package:notez/domain/vault.dart';

/// Не придумал, как назвать лучше
/// По сути все доменные объекты - [Vault], [Note], [Paragraph]
/// являются частями друг друга и образуют связанную структуру
/// При чтении мы получаем по сути всю структуру сразу
/// А запись можем делать гранулярно
abstract class DomainRepo {
  Future<List<Vault>> getAllVaults(String username);
}

class InMemoryDomainRepo implements DomainRepo {
  final List<Vault> vaults = getVaults();

  @override
  Future<List<Vault>> getAllVaults(String username) async {
    return Future.value(username == 'empty' ? [] : vaults);
  }
}

List<Vault> getVaults() {
  Note note1 = Note(id: "1", createdAt: DateTime.now(), title: "Заметка №1");
  note1.paragraphs.addAll([Paragraph("123", "Текст"), Paragraph("123", "Текст №2")]);

  Note note2 = Note(id: "2", createdAt: DateTime.now(), title: "Заметка №2");
  note2.paragraphs.addAll([Paragraph("123", "Текст"), Paragraph("123", "Текст №2")]);

  Note note3 = Note(id: "3", createdAt: DateTime.now(), title: "Заметка №3");
  note3.paragraphs.addAll([Paragraph("123", "Текст"), Paragraph("123", "Текст №2")]);

  Vault vault = Vault("123", "name");
  vault.notes.addAll([note1, note2, note3]);

  return [vault];
}
