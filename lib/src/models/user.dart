class UserModel {
  final String email;
  final String accessToken;
  final String refreshToken;

  UserModel(
      {required this.email,
      required this.accessToken,
      required this.refreshToken});
}
