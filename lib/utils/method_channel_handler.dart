import 'package:flutter/services.dart';

class MethodChannelHandler {
  static const MethodChannel _channel = MethodChannel('com.example.yogitech');

  MethodChannelHandler() {
    _channel.setMethodCallHandler(_methodCallHandler);
  }

  Future<void> _methodCallHandler(MethodCall call) async {
    switch (call.method) {
      case 'receiveObject':
        var myObject = call.arguments;

        // Handle the received object here
        break;
      default:
        throw MissingPluginException();
    }
  }
}
