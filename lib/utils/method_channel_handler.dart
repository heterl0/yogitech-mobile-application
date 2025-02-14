import 'package:YogiTech/models/account.dart';
import 'package:YogiTech/models/exercise.dart';
import 'package:YogiTech/services/account/account_service.dart';
import 'package:YogiTech/services/auth/auth_service.dart';
import 'package:YogiTech/services/exercise/exercise_service.dart';
import 'package:YogiTech/views/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MethodChannelHandler {
  static const MethodChannel _channel = MethodChannel('com.example.yogitech');
  late BuildContext context;
  final Account? account;
  final VoidCallback? fetchAccount;
  final VoidCallback? fetchEvent;
  MethodChannelHandler({this.account, this.fetchAccount, this.fetchEvent}) {
    _channel.setMethodCallHandler(_methodCallHandler);
  }

  Future<void> _methodCallHandler(MethodCall call) async {
    print("something is happening");
    switch (call.method) {
      case 'receiveObject':
        final text = call.arguments;
        final data = await postExerciseLog(text);
        await checkEvent();
        final account = await getUser();
        storeAccount(account!);
        final exercise = ExerciseResult.fromJson(data);
        print('Exercise: ${exercise.toJson()}');
        fetchAccount?.call();
        if (fetchEvent != null) {
          fetchEvent!.call();
        }
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
