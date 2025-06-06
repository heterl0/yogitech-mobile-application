import 'package:ZenAiYoga/models/account.dart';
import 'package:ZenAiYoga/models/exercise.dart';
import 'package:ZenAiYoga/services/account/account_service.dart';
import 'package:ZenAiYoga/services/auth/auth_service.dart';
import 'package:ZenAiYoga/services/exercise/exercise_service.dart';
import 'package:ZenAiYoga/views/exercise/result_exercise_practice_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MethodChannelHandler {
  static const MethodChannel _channel = MethodChannel('com.yogitech.yogitech');
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
