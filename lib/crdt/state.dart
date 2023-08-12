class State {
  final Map<String, dynamic> state = {};
   T get<T>(String id) {
     if (state.containsKey(id)) {
      return state[id];
     } else {
       throw Exception("Не найден объект с id = {$id}");
     }
  }

  void put(String id, dynamic value) {
     state[id] = value;
  }
}