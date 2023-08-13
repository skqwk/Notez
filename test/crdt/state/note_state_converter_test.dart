import 'package:flutter_test/flutter_test.dart';
import 'package:notez/crdt/state/state_converter.dart';
import 'package:notez/domain/note.dart';

void main() {
  ParagraphStateConverter paragraphStateConverter = ParagraphStateConverter();
  ParagraphListStateConverter paragraphListStateConverter =
      ParagraphListStateConverter(paragraphStateConverter);
  NoteStateConverter converter =
      NoteStateConverter(paragraphListStateConverter);

  test('Должен конвертировать заметку из Map<String, dynamic>', () {
    // GIVEN
    Map<String, dynamic> state = {
      'id': '444',
      'head': null,
      'color': 'white',
      'title': 'New note',
      'createdAt': '2023-08-13 15:15:19.123',
      'deleted': false
    };

    // WHEN
    Note actual = converter.convert(state)!;

    // THEN
    expect(actual.id, '444');
    expect(actual.color, 'white');
    expect(actual.title, 'New note');
    expect(actual.paragraphs, []);
    expect(actual.createdAt, DateTime.parse('2023-08-13 15:15:19.123'));
  });


  test('Должен вернуть null, если deleted == true', () {
    // GIVEN
    Map<String, dynamic> state = {
      'id': '444',
      'head': null,
      'color': 'white',
      'title': 'New note',
      'createdAt': '2023-08-13 15:15:19.123',
      'deleted': true
    };

    // WHEN | THEN
    expect(converter.convert(state), null);
  });
}
