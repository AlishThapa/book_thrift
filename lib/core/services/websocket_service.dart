import 'dart:async';
import 'dart:convert';
import 'package:book_thrift/constants/api_url.dart';
import 'package:book_thrift/core/storage/storage_service.dart';
import 'package:logger/logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:book_thrift/core/di/injection.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  final StreamController<Map<String, dynamic>> _messageController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  void connect() {
    if (_isConnected) return;

    final token = getIt<StorageService>().getAccessToken();
    if (token == null) {
      Logger().e('Cannot connect to WebSocket: No access token found');
      return;
    }

    // Following the guide: ws://127.0.0.1:8000/ws/chat?token=YOUR_JWT_TOKEN
    final wsUri = Uri.parse('${ApiUrl.wsUrl}?token=$token');
    
    try {
      _channel = WebSocketChannel.connect(wsUri);
      _isConnected = true;
      Logger().i('WebSocket Connected to $wsUri');

      _channel!.stream.listen(
        (message) {
          try {
            final decoded = jsonDecode(message as String);
            _messageController.add(decoded);
          } catch (e) {
            Logger().e('Error decoding WebSocket message: $e');
          }
        },
        onDone: () {
          _isConnected = false;
          Logger().w('WebSocket Connection Closed');
          _reconnect();
        },
        onError: (error) {
          _isConnected = false;
          Logger().e('WebSocket Error: $error');
          _reconnect();
        },
      );
    } catch (e) {
      _isConnected = false;
      Logger().e('WebSocket Connection Exception: $e');
      _reconnect();
    }
  }

  void _reconnect() {
    if (!_isConnected) {
       Future.delayed(const Duration(seconds: 5), () {
        Logger().i('Attempting to reconnect WebSocket...');
        connect();
      });
    }
  }

  void sendMessage(Map<String, dynamic> message) {
    if (_channel != null && _isConnected) {
      _channel!.sink.add(jsonEncode(message));
    } else {
      Logger().e('Cannot send message: WebSocket not connected');
      // Optionally try to reconnect
      connect();
    }
  }

  void disconnect() {
    _channel?.sink.close();
    _isConnected = false;
  }
}
