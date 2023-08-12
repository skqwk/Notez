import 'package:logging/logging.dart';

// ignore: camel_case_types
class log {

  static Logger? logger;

  static Logger _getOrCreate() {
    if (logger != null) {
      return logger!;
    }
    logger = Logger("dartz");
    Logger.root.level = Level.ALL; // defaults to Level.INFO
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
    return logger!;
  }

  static info(String message) {
    _getOrCreate().info(message);
  }
}

late Logger? logger;