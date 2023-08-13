import 'package:flutter_test/flutter_test.dart';
import 'package:notez/crdt/state/state_converter.dart';
import 'package:notez/domain/paragraph.dart';

void main() {
  ParagraphStateConverter converter = ParagraphStateConverter();
  test('Должен конвертировать из Map<String, dynamic> в параграф', () {
    // GIVEN
    Map<String, dynamic> state = {
      'content': 'Some text',
      'insertKey': '777',
      'deleteKey': '777',
      'next': null
    };

    // WHEN
    Paragraph paragraph = converter.convert(state)!;

    // THEN
    expect('777', paragraph.id);
    expect('Some text', paragraph.content);
  });
}