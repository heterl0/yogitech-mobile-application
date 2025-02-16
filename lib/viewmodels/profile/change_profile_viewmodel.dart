import 'package:flutter/material.dart';

class ChangeProfileViewModel extends ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  bool isLoading = false;
  String successMessage = '';

  void updateProfile() async {
    isLoading = true;
    successMessage = '';
    notifyListeners();

    await Future.delayed(Duration(seconds: 2)); // Giả lập API call

    isLoading = false;
    successMessage = 'Cập nhật thành công!';
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
