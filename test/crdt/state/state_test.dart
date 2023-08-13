import 'package:flutter_test/flutter_test.dart';
import 'package:notez/crdt/state/state.dart';

void main() {
  final testState = {
    "a": {
      "b": {
        "c": 5,
      },
    },
  };

  final testValues = {
    'a/b/c': 5,
    'a/b': {'c': 5},
    'a': {
      'b': {'c': 5}
    }
  };

  testValues.forEach(
      (path, expected) => test('Получение значения по пути к нему', () {
            // GIVEN
            dynamic result = testState;

            // WHEN
            for (var part in path.split('/')) {
              result = result[part];
            }

            // THEN
            expect(expected, result);
          }));

  test('Заполнение значения по пути к нему', () {
    // GIVEN
    Map<String, dynamic> state = {
      "a": {"b": 3}
    };

    String path = 'a/b';

    // WHEN
    Map<String, dynamic> temp = state;
    List<String> parts = path.split('/');
    for (int i = 0; i < parts.length - 1; ++i) {
      temp = temp[parts[i]];
    }

    // THEN
    temp[parts.last] = 5;
    expect(5, state['a']['b']);
  });

  test('В состояние можно положить объект по пути', () {
    // GIVEN
    Map<String, dynamic> object = {
      "notes": {
        "123": {"paragraphs": {}}
      }
    };

    State state = State();
    state.put("1234", object);

    // WHEN
    state.put('1234/notes/123/paragraphs/3', {"id": 1234});

    // THEN
    Map<String, dynamic> expected = {
      "notes": {
        "123": {
          "paragraphs": {
            "3": {
              "id": 1234,
            },
          }
        }
      }
    };
    expect(state.get('1234'), expected);
  });

  test('Из состояния можно достать объект по пути', () {
    // GIVEN
    Map<String, dynamic> object = {
      "notes": {
        "123": {
          "paragraphs": {
            "3": {
              "id": 1234,
            },
          }
        }
      }
    };

    State state = State();
    state.put("1234", object);

    // WHEN | THEN
    expect(state.get('1234/notes/123/paragraphs/3/id'), 1234);
  });
}
