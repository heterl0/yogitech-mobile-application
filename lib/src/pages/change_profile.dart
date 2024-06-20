import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:yogi_application/api/account/account_service.dart';
import 'package:yogi_application/api/auth/auth_service.dart';
import 'package:yogi_application/src/custombar/appbar.dart';
import 'package:yogi_application/src/models/account.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/widgets/box_input_field.dart';
import 'package:yogi_application/src/widgets/dropdown_field.dart';
import 'package:yogi_application/src/widgets/box_button.dart';
import 'package:yogi_application/src/pages/change_BMI.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangeProfilePage extends StatefulWidget {
  const ChangeProfilePage({super.key});

  @override
  State<ChangeProfilePage> createState() => _ChangeProfilePageState();
}

class _ChangeProfilePageState extends State<ChangeProfilePage> {
  final TextEditingController userName = TextEditingController();
  final TextEditingController email = TextEditingController();

  final TextEditingController phone = TextEditingController();
  final TextEditingController birthday = TextEditingController();
  final TextEditingController gender = TextEditingController();

  Profile? _profile;
  Account? _account;

  // Regular expression for Vietnamese phone numbers
  final RegExp phoneRegExp =
      RegExp(r'^(03|05|07|08|09|01[2|6|8|9])+([0-9]{8})$');

  final Map<int, String> genderMap = {
    0: 'Female',
    1: 'Male',
    2: 'Other',
  };
  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    Profile? profile = await getUserProfile();
    Account? account = await retrieveAccount();

    // Cập nhật trạng thái với danh sách bài tập mới nhận được từ API
    setState(() {
      _profile = profile;
      _account = account;
      if (_profile?.gender != null) {
        gender.text = genderMap[_profile!.gender] ?? '';
      }

      if (_profile?.birthdate != null) {
        birthday.text = _formatDate(_profile?.birthdate ?? '');
      }
    });
  }

  String _formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd-MM-yyyy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: CustomAppBar(
        title: trans.editProfile,
        style: widthStyle.Large,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 144,
                    height: 144,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: _profile != null &&
                            (_profile!.avatar_url != null &&
                                _profile!.avatar_url!.isNotEmpty)
                        ? CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                NetworkImage(_profile!.avatar_url!),
                            backgroundColor: Colors.transparent,
                          )
                        : Center(
                            child: _profile != null &&
                                    (_profile!.avatar_url != null &&
                                        _profile!.avatar_url!.isNotEmpty)
                                ? CircleAvatar(
                                    radius: 50,
                                    backgroundImage:
                                        NetworkImage(_profile!.avatar_url!),
                                    backgroundColor: Colors.transparent,
                                  )
                                : Center(
                                    child: Container(
                                      width: 144,
                                      height: 144,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.transparent,
                                        border: Border.all(
                                          color: Colors.blue, // Màu của border
                                          width: 3.0, // Độ rộng của border
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          (_account?.username ?? '').isNotEmpty
                                              ? (_account!.username[0]
                                                  .toUpperCase())
                                              : '',
                                          style: TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white, // Màu chữ
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                  ),
                ),
                SizedBox(height: 8),
                BoxButton(
                  title: trans.changeAvatar, // Set the button text
                  style: ButtonStyleType
                      .Tertiary, // Set the button style (optional)
                  onPressed: () {
                    // Handle change avatar action here
                  },
                ),
                SizedBox(height: 16),
                Text(trans.username,
                    style: h3.copyWith(color: theme.colorScheme.onPrimary)),
                SizedBox(height: 8.0),
                BoxInputField(
                  controller: userName,
                  placeholder: _account?.username ?? '',
                ),
                SizedBox(height: 16.0),
                Text('Email',
                    style: h3.copyWith(color: theme.colorScheme.onPrimary)),
                SizedBox(height: 8.0),
                BoxInputField(
                  controller: email,
                  placeholder: _account?.email ?? '',
                ),
                SizedBox(height: 16.0),
                Text('Phone',
                    style: h3.copyWith(color: theme.colorScheme.onPrimary)),
                SizedBox(height: 8.0),
                BoxInputField(
                  controller: phone,
                  placeholder: _account?.phone ?? '',
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  regExp: phoneRegExp, // Đảm bảo phoneRegExp được định nghĩa
                  errorText: "Invalid phone number",
                ),
                SizedBox(height: 16.0),
                Text(trans.birthday,
                    style: h3.copyWith(color: theme.colorScheme.onPrimary)),
                SizedBox(height: 8.0),
                BoxInputField(
                  controller: birthday,
                  placeholder: (_profile?.birthdate != null)
                      ? _formatDate(_profile!.birthdate ?? '')
                      : 'Select your birthday',
                  trailing: Icon(
                    Icons.calendar_today,
                  ), // Thay đổi icon
                  readOnly: true, // Đặt readOnly thành true
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        birthday.text = "${pickedDate.toLocal()}".split(' ')[0];
                        birthday.text =
                            DateFormat('dd-MM-yyyy').format(pickedDate);
                      });
                    }
                  },
                ),
                SizedBox(height: 16.0),
                Text(trans.gender,
                    style: h3.copyWith(color: theme.colorScheme.onPrimary)),
                SizedBox(height: 8.0),
                CustomDropdownFormField(
                  controller: gender,
                  items: ['Male', 'Female', 'Other'],
                  placeholder:
                      gender.text.isEmpty ? 'Select gender' : gender.text,
                  onTap: () {
                    // Tùy chỉnh hành động khi dropdown được nhấn, nếu cần thiết
                  },
                ),
                SizedBox(height: 40.0),
                BoxButton(
                  title: trans.save, // Set the button text
                  style: ButtonStyleType
                      .Primary, // Set the button style (optional)
                  onPressed: () {},
                ),
                SizedBox(height: 16.0),
                BoxButton(
                  title: trans.changePassword, // Set the button text
                  style: ButtonStyleType
                      .Tertiary, // Set the button style (optional)
                  onPressed: () {
                    // _showChangePasswordDrawer(context);
                    _changePasswordBottomSheet(context);
                  },
                ),
                BoxButton(
                  title: trans.changeBMI, // Set the button text
                  style: ButtonStyleType
                      .Tertiary, // Set the button style (optional)
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeBMIPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _changePasswordBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    final TextEditingController currentPassword = TextEditingController();
    final TextEditingController newPassword = TextEditingController();
    final TextEditingController confirmNewPassword = TextEditingController();
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.onSecondary,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 36),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(trans.oldPassword,
                    style: h3.copyWith(color: theme.colorScheme.onBackground)),
                SizedBox(height: 16.0),
                BoxInputField(
                  controller: currentPassword,
                  password: true,
                ),
                SizedBox(height: 16.0),
                Text(trans.newPassword,
                    style: h3.copyWith(color: theme.colorScheme.onBackground)),
                SizedBox(height: 16.0),
                BoxInputField(
                  controller: newPassword,
                  password: true,
                ),
                SizedBox(height: 16.0),
                Text(trans.confirmNewPassword,
                    style: h3.copyWith(color: theme.colorScheme.onBackground)),
                SizedBox(height: 16.0),
                BoxInputField(
                  controller: confirmNewPassword,
                  password: true,
                ),
                SizedBox(height: 32.0),
                BoxButton(
                  title: trans.save,
                  style: ButtonStyleType.Primary,
                  state: ButtonState
                      .Enabled, // hoặc ButtonState.Disabled để test trạng thái disabled
                  onPressed: () async {
                    if (newPassword.text != confirmNewPassword.text) {
                      // Hiển thị thông báo lỗi nếu mật khẩu mới và xác nhận mật khẩu không khớp
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(trans.passwordsDoNotMatch),
                        ),
                      );
                      return;
                    }

                    PasswordChangeRequest request = PasswordChangeRequest(
                      currentPassword: currentPassword.text,
                      newPassword: newPassword.text,
                      reNewPassword: confirmNewPassword.text,
                    );

                    bool result = await changePassword(request);
                    if (result) {
                      // Hiển thị thông báo thành công và đóng bottom sheet
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(trans.passwordChangedSuccessfully),
                        ),
                      );
                      Navigator.pop(context);
                    } else {
                      // Hiển thị thông báo lỗi nếu việc thay đổi mật khẩu thất bại
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(trans.passwordChangeFailed),
                        ),
                      );
                    }
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
