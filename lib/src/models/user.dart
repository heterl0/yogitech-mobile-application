import 'package:yogi_application/src/models/account.dart';

class UserModel {
  final Account account;
  final String accessToken;
  final String refreshToken;

  UserModel(
      {required this.account,
      required this.accessToken,
      required this.refreshToken});
}
