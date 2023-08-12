/// Класс для конвертации состояния в конкретные доменные объекты
abstract class StateConverter<T> {
  T convert(Map<String, dynamic> state);
}