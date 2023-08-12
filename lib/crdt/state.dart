/// Состояние - обертка над хэш-мапой, в которую помещаются
/// объекты, полученные в результате обработке событий
class State {
  static const DELIMITER = '/';

  final Map<String, dynamic> state = {};

  T get<T>(String path) {
    dynamic result = state;
    for (String part in path.split(DELIMITER)) {
      result = result[part];
    }
    return result;
  }

  void put(String path, dynamic value) {
    Map<dynamic, dynamic> container = state;
    List<String> parts = path.split(DELIMITER);
    for (int i = 0; i < parts.length - 1; ++i) {
      container = container[parts[i]];
    }
    container[parts.last] = value;
  }
}
