import 'package:notez/domain/note.dart';

class Vault {
  final String id;
  final String name;
  final List<Note> notes = [];

  Vault(this.id, this.name);
}