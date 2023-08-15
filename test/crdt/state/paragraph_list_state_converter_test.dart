import 'package:flutter_test/flutter_test.dart';
import 'package:notez/crdt/state/state_converter.dart';
import 'package:notez/domain/paragraph.dart';

void main() {
  ParagraphStateConverter paragraphStateConverter = ParagraphStateConverter();
  ParagraphListStateConverter converter =
      ParagraphListStateConverter(paragraphStateConverter);

  test('Должен добавлять в список только параграфы с content != null', () {
    // GIVEN
    Map<String, dynamic> state = {
      'head': '111',
      'paragraphs': {
        '111': {
          'content': null,
          'next': '222'
        },
        '222': {
          'content': null,
          'next': '333',
        },
        '333': {
          'content': 'Some text',
          'insertKey': '333'
        }
      }
    };

    // WHEN
    List<Paragraph> actual = converter.convert(state);

    // THEN
    expect(actual.length, 1);
    expect(actual.first.content, 'Some text');
    expect(actual.first.id, '333');
  });

  test('Должен добавлять в список параграфы в порядке связанного списка', () {
    // GIVEN
    Map<String, dynamic> state = {
      'head': '111',
      'paragraphs': {
        '222': {
          'content': 'Second',
          'next': '333',
          'insertKey': '222'
        },
        '111': {
          'content': 'First',
          'next': '222',
          'insertKey': '111'
        },
        '333': {
          'content': 'Third',
          'insertKey': '333',
          'next': null
        }
      }
    };

    // WHEN
    List<Paragraph> actual = converter.convert(state);

    // THEN
    expect(actual.length, 3);
    expect(actual[0].id, '111');
    expect(actual[1].id, '222');
    expect(actual[2].id, '333');
  });

  test('Должен возвращать пустой список, если head == null', () {
    // GIVEN
    Map<String, dynamic> state = {
      'head': null,
      'paragraphs': {
        '222': {
          'content': 'Second',
          'next': '333',
          'insertKey': '222'
        },
        '111': {
          'content': 'First',
          'next': '222',
          'insertKey': '111'
        },
        '333': {
          'content': 'Third',
          'insertKey': '333',
          'next': null
        }
      }
    };

    // WHEN
    List<Paragraph> actual = converter.convert(state);

    // THEN
    expect(actual.length, 0);
  });
}
