import 'package:YogiTech/src/pages/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MethodChannelHandler {
  static const MethodChannel _channel = MethodChannel('com.example.yogitech');
  late BuildContext context;
  MethodChannelHandler() {
    _channel.setMethodCallHandler(_methodCallHandler);
  }

  Future<void> _methodCallHandler(MethodCall call) async {
    print("something is happening");
    switch (call.method) {
      case 'receiveObject':
        final text = call.arguments;
        print('Received: $text');
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => Result()),
        );
        break;
      default:
        throw MissingPluginException();
    }
  }
}
