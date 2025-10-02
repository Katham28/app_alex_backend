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

  // 🔹 Notificador de cambios
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

        final slots = data['request']?['intent']?['slots'] ?? {};
          final nombre = slots['nombre']?['value'] ?? "";
          final prioridad = slots['prioridad']?['value'] ?? "2";
          final habitacion = slots['habitacion']?['value'] ?? "";
          final necesidad = slots['necesidad']?['value'] ?? "";




        final nuevaPeticion = Peticion(
          name: nombre,
          habitacion: habitacion,
          prioridad: int.tryParse(prioridad) ?? 2,
          peticion: necesidad,
        );

      print (data);


        slots.forEach((key, value) {
          print("Slot: $key, valor: ${value['value']}");
        });
  


      print('Nueva petición recibida: $nuevaPeticion');
        peticiones.add(nuevaPeticion);

        // 🔹 Notificamos a los que escuchan
        _peticionesController.add(List.from(peticiones));

        // reenviar a las apps conectadas por WS
          for (var client in clients) {
            client.sink.add(jsonEncode({
              'type': 'new_peticion',       // indica que es una nueva petición
              'data': {
                'name': nuevaPeticion.name,
                'habitacion': nuevaPeticion.habitacion,
                'prioridad': nuevaPeticion.prioridad,
                'peticion': nuevaPeticion.peticion,
              }
            }));
          }

final speakText =
        "Entendido, he registrado la petición $necesidad para $nombre en la habitación $habitacion con prioridad $prioridad.";

    final response = {
      "version": "1.0",
      "response": {
        "shouldEndSession": true,
        "outputSpeech": {
          "type": "PlainText",
          "text": speakText
        }
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
