import 'dart:async';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/Peticion.dart';

class BackendConnector {
  final clients = <WebSocketChannel>[];
  final List<Peticion> peticiones = [];

  final _peticionesController = StreamController<List<Peticion>>.broadcast();
  Stream<List<Peticion>> get peticionesStream => _peticionesController.stream;

  Future<void> start(int port) async {
    final wsHandler = webSocketHandler((WebSocketChannel socket, String? protocol) {
      clients.add(socket);
      socket.stream.listen(
        (_) {},
        onDone: () => clients.remove(socket),
        onError: (_) => clients.remove(socket),
      );
    });

    Future<Response> alexaHandler(Request request) async {
      try {
        final body = await request.readAsString();
        final data = jsonDecode(body);

        print("Request crudo de Alexa:");
        print(data);

        // Solo procesamos IntentRequest
        final requestType = data['request']?['type'];
        if (requestType != 'IntentRequest') {
          return Response.ok(
            jsonEncode({
              "version": "1.0",
              "response": {
                "shouldEndSession": false,
                "outputSpeech": {
                  "type": "PlainText",
                  "text": "Bienvenido a Petición Médica. ¿Qué necesitas?"
                }
              }
            }),
            headers: {"Content-Type": "application/json"},
          );
        }

        final intent = data['request']['intent'];
        final slots = intent['slots'] ?? {};
        final nombre = slots['nombre']?['value'] ?? "";
        final prioridad = slots['prioridad']?['value'] ?? "";
        final habitacion = slots['habitacion']?['value'] ?? "";
        final necesidad = slots['necesidad']?['value'] ?? "";

        // Imprimir slots
        slots.forEach((key, value) {
          print("Slot: $key, valor: ${value['value']}");
        });

        // Verificar slots faltantes y preguntar
        String speakText;
        bool endSession = false;

        if (necesidad.isEmpty) {
          speakText = "¿Cuál es la necesidad del paciente?";
        } else if (nombre.isEmpty) {
          speakText = "¿Cuál es el nombre del paciente?";
        } else if (habitacion.isEmpty) {
          speakText = "¿En qué habitación está el paciente?";
        } else if (prioridad.isEmpty) {
          speakText = "¿Cuál es la prioridad de la petición?";
        } else {
          // Todos los slots están completos, registrar petición
          final nuevaPeticion = Peticion(
            name: nombre,
            habitacion: habitacion,
            prioridad: int.tryParse(prioridad) ?? 2,
            peticion: necesidad,
          );

          print('Nueva petición registrada: $nuevaPeticion');
          peticiones.add(nuevaPeticion);
          _peticionesController.add(List.from(peticiones));

          // Notificar WS
          for (var client in clients) {
            client.sink.add(jsonEncode({
              'type': 'new_peticion',
              'data': {
                'name': nuevaPeticion.name,
                'habitacion': nuevaPeticion.habitacion,
                'prioridad': nuevaPeticion.prioridad,
                'peticion': nuevaPeticion.peticion,
              }
            }));
          }

          speakText =
              "Entendido, he registrado la petición $necesidad para $nombre en la habitación $habitacion con prioridad $prioridad.";
          endSession = true;
        }

        final response = {
          "version": "1.0",
          "response": {
            "shouldEndSession": endSession,
            "outputSpeech": {"type": "PlainText", "text": speakText}
          }
        };

        return Response.ok(
          jsonEncode(response),
          headers: {"Content-Type": "application/json"},
        );
      } catch (e) {
        return Response.internalServerError(
          body: jsonEncode({"error": e.toString()}),
        );
      }
    }

    final handler = Cascade()
        .add((req) {
          if (req.url.path == "alexa-webhook") return alexaHandler(req);
          return Response.notFound('Not found');
        })
        .add((req) {
          if (req.url.path == "ws") return wsHandler(req);
          return Response.notFound('Not found');
        })
        .handler;

    final server = await io.serve(handler, '0.0.0.0', port);
    print('Servidor escuchando en http://${server.address.host}:${server.port}');
  }
}
