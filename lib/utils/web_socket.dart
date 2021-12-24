import 'dart:convert';
import 'package:app/utils/storage.dart';
import 'package:web_socket_channel/io.dart';

class WebSocket {
  static final WebSocket _singleton = WebSocket._internal();

  void Function(dynamic)? handlerChats;

  late IOWebSocketChannel _channel;

  String _url = "wss://app.workquest.co/api";

  int _counter = 0;

  bool shouldReconnectFlag = true;

  int closeCode = 4001;

  factory WebSocket() {
    return _singleton;
  }

  void connect() async {
    shouldReconnectFlag = true;
    _counter = 0;
    String? token = await Storage.readAccessToken();
    print("[WebSocket]  connecting ...");
    this._channel = IOWebSocketChannel.connect(_url);

    this._channel.sink.add("""{
          "type": "hello",
          "id": 1,
          "version": "2",
          "auth": {
            "headers": {"authorization": "Bearer $token"}
          },
          "subs": ["/notifications/chat",
          "/notifications/quest"]
        }""");

    this._channel.stream.listen(
          this._onData,
          onError: this._onError,
          onDone: this._onDone,
        );
  }

  void _onData(message) {
    print("WebSocket message: $message");
    final json = jsonDecode(message.toString());
    switch (json["type"]) {
      case "pub":
        _handleSubscription(json);
        break;
      case "ping":
        _ping();
        break;
      case "request":
        getMessage(json);
        break;
    }
  }

  void _handleSubscription(dynamic json) async {
    if (json["path"] == "/notifications/chat") {
      getMessage(json);
    }
  }

  void getMessage(dynamic json) async {
    try {
      var message = json;
      if (handlerChats != null) handlerChats!(message);
      print("chatMessage: ${message.toString()}");
    } catch (e, trace) {
      print("WebSocket message ERROR: $e");
      print("WebSocket message ERROR: $trace");
    }
  }

  Future<void> sendMessage({
    required String chatId,
    required String text,
    required List<String> medias,
  }) async {
    Object payload = {
      "type": "request",
      "id": "$_counter",
      "method": "POST",
      "path": "/api/v1/chat/$chatId/send-message",
      "payload": {
        "text": "$text",
        "medias": medias,
      }
    };
    String textPayload = json.encode(payload).toString();
    _channel.sink.add(textPayload);
    print("Send Message: $textPayload");
    // ConversationRepository().sendMsg(message)
    _counter++;
  }

  void _ping() {
    Object payload = {
      "type": "ping",
      "id": "$_counter",
    };
    String textPayload = json.encode(payload).toString();
    _channel.sink.add(textPayload);
    _counter++;
  }

  void _onError(error) {
    print("WebSocket error: $error");
  }

  void _onDone() {
    if (shouldReconnectFlag) connect();
    print("WebSocket onDone ${_channel.closeReason}");
  }

  WebSocket._internal();
}
