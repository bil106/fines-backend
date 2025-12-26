import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

void main() async {
  final router = Router();

  router.get('/', (Request request) {
    return Response.ok('Server is running');
  });

  router.post('/api/fines', (Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body);

      final carNumber = data['carNumber'];
      final docSeries = data['docSeries'];
      final docNumber = data['docNumber'];

      print('Request fines for $carNumber $docSeries$docNumber');

      /// 🔴 ВРЕМЕННО: заглушка
      /// Сначала проверяем, что маршрут вообще работает
      return Response.ok(
        jsonEncode({
          'fines': [],
          'debug': {
            'carNumber': carNumber,
            'docSeries': docSeries,
            'docNumber': docNumber,
          }
        }),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e, st) {
      print(e);
      print(st);
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  });

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router);

  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  await io.serve(handler, '0.0.0.0', port);

  print('Server listening on port $port');
}
