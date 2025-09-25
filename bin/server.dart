import 'dart:io';
import '../lib/services/BackendConnector.dart';

Future<void> main() async {
  final backend = BackendConnector();

  // Railway da el puerto en la variable PORT
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  await backend.start(port);
}
