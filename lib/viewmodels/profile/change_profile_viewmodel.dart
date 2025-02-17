import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../models/account.dart';
import '../../services/account/account_service.dart';
import '../../utils/formatting.dart';
import '../../views/profile/view_avatar_screen.dart';

class ChangeProfileViewModel {
  final AppLocalizations trans;
  final TextEditingController lastName = TextEditingController();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController birthday = TextEditingController();
  final TextEditingController gender = TextEditingController();

  File? _image;
  Uint8List? imageBytes;
  bool isLoading = false;

  final Account? account;
  final RegExp phoneRegExp =
      RegExp(r'^(03|05|07|08|09|01[2|6|8|9])+([0-9]{8})$');
  final VoidCallback? onProfileUpdated;

  ChangeProfileViewModel({
    required this.trans,
    this.account,
    this.onProfileUpdated, // Nhận callback
  });

  void loadProfile() {
    if (account?.profile != null) {
      lastName.text = account?.profile.last_name ?? '';
      firstName.text = account?.profile.first_name ?? '';
      phone.text = account?.phone ?? '';
      birthday.text = account?.profile.birthdate != null
          ? formatDate(account!.profile.birthdate!)
          : '';
      gender.text = _getGenderText(account?.profile.gender);
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      imageBytes = await _image!.readAsBytes();
    }
  }

  void viewAvatar(BuildContext context) {
    if (imageBytes != null || account?.profile.avatar_url != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AvatarViewPage(
            avatarUrl: account?.profile.avatar_url ?? '',
            imageBytes: imageBytes,
          ),
        ),
      );
    }
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1920),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && !pickedDate.isAfter(DateTime.now())) {
      birthday.text = DateFormat('dd-MM-yyyy').format(pickedDate);
    }
  }

  Future<void> changeProfile(BuildContext context) async {
    if (lastName.text.isEmpty || firstName.text.isEmpty) {
      _showSnackBar(context, false, message: 'Họ và tên không được để trống');
      return;
    }

    if (!phoneRegExp.hasMatch(phone.text) || phone.text.length != 10) {
      _showSnackBar(context, false, message: 'Số điện thoại không hợp lệ');
      return;
    }

    int? genderValue = _getGenderValue(gender.text);
    DateTime? birthdate = birthday.text.isNotEmpty
        ? DateFormat('dd-MM-yyyy').parse(birthday.text)
        : null;

    PatchProfileRequest request = PatchProfileRequest(
      lastName: lastName.text,
      firstName: firstName.text,
      phone: phone.text,
      birthdate: birthdate,
      gender: genderValue,
    );

    final Profile? profile = await patchProfile(request, imageBytes);
    if (profile != null) {
      _showSnackBar(context, true, message: 'Cập nhật thành công');
      onProfileUpdated?.call();
    } else {
      _showSnackBar(context, false, message: 'Cập nhật thất bại');
    }
  }

  void _showSnackBar(BuildContext context, bool success, {String? message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: success ? Colors.green : Colors.red,
        content: Text(message ?? ''),
      ),
    );
  }

  String _getGenderText(int? gender) {
    switch (gender) {
      case 0:
        return trans.female;
      case 1:
        return trans.male;
      default:
        return trans.other;
    }
  }

  int _getGenderValue(String genderText) {
    switch (genderText) {
      case 'Nữ':
        return 0;
      case 'Nam':
        return 1;
      default:
        return 2;
    }
  }
}
