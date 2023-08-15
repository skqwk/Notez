import 'package:flutter_test/flutter_test.dart';
import 'package:notez/crdt/state/state_converter.dart';
import 'package:notez/domain/vault.dart';

void main() {
  ParagraphStateConverter paragraphStateConverter = ParagraphStateConverter();
  ParagraphListStateConverter paragraphListStateConverter =
      ParagraphListStateConverter(paragraphStateConverter);
  NoteStateConverter noteStateConverter =
      NoteStateConverter(paragraphListStateConverter);
  VaultStateConverter converter = VaultStateConverter(noteStateConverter);

  test('Должен конвертировать хранилище из Map<String, dynamic>', () {
    // GIVEN
    Map<String, dynamic> state = {
      'id': '111',
      'name': 'New vault',
      'deleted': false,
      'notes': {}
    };

    // WHEN
    Vault actual = converter.convert(state)!;

    // THEN
    expect(actual.id, '111');
    expect(actual.name, 'New vault');
    expect(actual.notes.length, 0);
  });

  test('Должен возвращать null, если deleted == true', () {
    // GIVEN
    Map<String, dynamic> state = {
      'id': '111',
      'name': 'New vault',
      'deleted': true,
      'notes': {}
    };

    // WHEN | THEN
    expect(converter.convert(state), null);
  });

  test('Должен делегировать заполнение notes', () {
    // GIVEN
    Map<String, dynamic> state = {
      'id': '111',
      'name': 'New vault',
      'deleted': false,
      'notes': {
        '444': {
          'id': '444',
          'head': null,
          'color': 'white',
          'title': 'Some note',
          'createdAt': '2023-08-13 15:15:19.123',
          'deleted': false
        },
        '555': {
          'id': '555',
          'head': null,
          'color': 'white',
          'title': 'Another note',
          'createdAt': '2023-08-13 15:15:19.123',
          'deleted': false
        }
      }
    };

    // WHEN
    Vault actual = converter.convert(state)!;

    // THEN
    expect(actual.id, '111');
    expect(actual.name, 'New vault');
    expect(actual.notes.length, 2);
  });

  test('В notes должны попадать только те, у которых deleted == false', () {
    // GIVEN
    Map<String, dynamic> state = {
      'id': '111',
      'name': 'New vault',
      'deleted': false,
      'notes': {
        '444': {
          'id': '444',
          'head': null,
          'color': 'white',
          'title': 'Some note',
          'createdAt': '2023-08-13 15:15:19.123',
          'deleted': true
        },
        '555': {
          'id': '555',
          'head': null,
          'color': 'white',
          'title': 'Another note',
          'createdAt': '2023-08-13 15:15:19.123',
          'deleted': false
        }
      }
    };

    // WHEN
    Vault actual = converter.convert(state)!;

    // THEN
    expect(actual.id, '111');
    expect(actual.name, 'New vault');
    expect(actual.notes.length, 1);
    expect(actual.notes.first.id, '555');
  });
}
