import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_client/web_socket_client.dart';

class ChatWebService {
  static final ChatWebService _instance = ChatWebService._internal();
  factory ChatWebService() => _instance;
  WebSocket? _socket;
  // load from env
  ChatWebService._internal();
  final String _url = dotenv.env['WEBSOCKET_URL']!;

  void connect() {
    _socket = WebSocket(Uri.parse("$_url/chat"));
    _socket!.messages.listen(
      (message) {
        final data = json.decode(message);
        print(data['type']);
      },
      onDone: () {
        print('Socket is closed');
      },
      onError: (error) {
        print('Error: $error');
      },
    );
  }

  void chat(String query) {
    _socket!.send(json.encode({'data': query}));
  }
}
