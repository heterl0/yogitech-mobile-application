import 'dart:convert';

import 'package:YogiTech/api/exercise/exercise_service.dart';
import 'package:YogiTech/src/models/account.dart';
import 'package:YogiTech/src/models/exercise.dart';
import 'package:YogiTech/src/pages/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MethodChannelHandler {
  static const MethodChannel _channel = MethodChannel('com.example.yogitech');
  late BuildContext context;
  final Account? account;
  final VoidCallback? fetchAccount;
  MethodChannelHandler({this.account, this.fetchAccount}) {
    _channel.setMethodCallHandler(_methodCallHandler);
  }

  Future<void> _methodCallHandler(MethodCall call) async {
    print("something is happening");
    switch (call.method) {
      case 'receiveObject':
        final text = call.arguments;
        final data = await postExerciseLog(text);
        final exercise = ExerciseResult.fromJson(data);
        print('Exercise: ${exercise.toJson()}');
        fetchAccount?.call();
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => Result(
                    exerciseResult: exercise,
                  )),
        );
        break;
      default:
        throw MissingPluginException();
    }
  }
}
