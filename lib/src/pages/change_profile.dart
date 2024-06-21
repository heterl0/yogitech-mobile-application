import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:YogiTech/api/account/account_service.dart';
import 'package:YogiTech/api/auth/auth_service.dart';
import 'package:YogiTech/src/custombar/appbar.dart';
import 'package:YogiTech/src/models/account.dart';
import 'package:YogiTech/src/shared/styles.dart';
import 'package:YogiTech/src/widgets/box_input_field.dart';
import 'package:YogiTech/src/widgets/dropdown_field.dart';
import 'package:YogiTech/src/widgets/box_button.dart';
import 'package:YogiTech/src/pages/change_BMI.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangeProfilePage extends StatefulWidget {
  const ChangeProfilePage({super.key});

  @override
  State<ChangeProfilePage> createState() => _ChangeProfilePageState();
}

class _ChangeProfilePageState extends State<ChangeProfilePage> {
  final TextEditingController lastName = TextEditingController();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController birthday = TextEditingController();
  final TextEditingController gender = TextEditingController();

  Profile? _profile;
  Account? _account;

  void refreshProfile() {
    // Gọi API để lấy lại dữ liệu hồ sơ sau khi cập nhật BMI
    _fetchUserProfile();
  }

  // Regular expression for Vietnamese phone numbers
  final RegExp phoneRegExp =
      RegExp(r'^(03|05|07|08|09|01[2|6|8|9])+([0-9]{8})$');

  final Map<int, String> genderMap = {
    0: 'Female',
    1: 'Male',
    2: 'Other',
  };

  final Map<String, String> transMap = {
    'Female': 'Nam',
    'Male': 'Nữ',
    'Other': 'Khác',
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
      if (_profile != null) {
        lastName.text = _profile!.last_name ?? '';
        firstName.text = _profile!.first_name ?? '';
        gender.text = genderMap[_profile!.gender] ?? '';
        if (_profile!.birthdate != null) {
          birthday.text = _formatDate(_profile!.birthdate ?? '');
        }
      }
      if (_account != null) {
        phone.text = _account!.phone ?? '';
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
      backgroundColor: theme.colorScheme.surface,
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
                  title: trans.changeAvatar,
                  style: ButtonStyleType.Tertiary,
                  onPressed: () {
                    // Handle change avatar action here
                  },
                ),
                SizedBox(height: 16),
                Text(trans.lastName,
                    style: h3.copyWith(color: theme.colorScheme.onPrimary)),
                SizedBox(height: 8.0),
                BoxInputField(
                  controller: lastName,
                  placeholder: trans.lastName,
                ),
                SizedBox(height: 16.0),
                Text(trans.firstName,
                    style: h3.copyWith(color: theme.colorScheme.onPrimary)),
                SizedBox(height: 8.0),
                BoxInputField(
                  controller: firstName,
                  placeholder: trans.lastName,
                ),
                SizedBox(height: 16.0),
                Text(trans.phoneNumber,
                    style: h3.copyWith(color: theme.colorScheme.onPrimary)),
                SizedBox(height: 8.0),
                BoxInputField(
                  controller: phone,
                  placeholder: _account?.phone ?? '',
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  regExp: phoneRegExp,
                  errorText: "Invalid phone number",
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            trans.birthday,
                            style:
                                h3.copyWith(color: theme.colorScheme.onPrimary),
                          ),
                          SizedBox(height: 8.0),
                          BoxInputField(
                            controller: birthday,
                            placeholder: (_profile?.birthdate != null)
                                ? _formatDate(_profile!.birthdate ?? '')
                                : trans.birthday,
                            trailing: Icon(Icons.calendar_today),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  birthday.text = DateFormat('dd-MM-yyyy')
                                      .format(pickedDate);
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.0), // Khoảng cách giữa hai Expanded
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            trans.gender,
                            style:
                                h3.copyWith(color: theme.colorScheme.onPrimary),
                          ),
                          SizedBox(height: 8.0),
                          CustomDropdownFormField(
                            controller: gender,
                            items: ['Male', 'Female', 'Other'],
                            placeholder: gender.text.isEmpty
                                ? trans.sellectGender
                                : gender.text,
                            onTap: () {
                              // Tùy chỉnh hành động khi dropdown được nhấn, nếu cần thiết
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40.0),
                BoxButton(
                  title: trans.save, // Set the button text
                  style: ButtonStyleType
                      .Primary, // Set the button style (optional)
                  onPressed: () async {
                    _changgeProfile(context);
                  },
                ),
                SizedBox(height: 16.0),
                BoxButton(
                  title: trans.changePassword,
                  style: ButtonStyleType.Tertiary,
                  onPressed: () {
                    _changePasswordBottomSheet(context);
                  },
                ),
                BoxButton(
                  title: trans.changeBMI,
                  style: ButtonStyleType.Tertiary,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChangeBMIPage(onBMIUpdated: refreshProfile),
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

  Future<void> _changgeProfile(BuildContext context) async {
    DateTime? birthdate = birthday.text.isNotEmpty
        ? DateFormat('dd-MM-yyyy').parse(birthday.text)
        : null;
    int? genderValue = gender.text.isNotEmpty
        ? genderMap.entries
            .firstWhere((entry) => entry.value == gender.text)
            .key
        : null;
    PatchProfileRequest request = PatchProfileRequest(
        lastName: lastName.text,
        firstName: firstName.text,
        phone: phone.text,
        birthdate: birthdate,
        gender: genderValue);

    final Profile? profile = await patchProfile(request);
    if (profile != null) {
      final account = await retrieveAccount();
      setState(() {
        _account = account;
      });
    }
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
                    style: h3.copyWith(color: theme.colorScheme.onSurface)),
                SizedBox(height: 16.0),
                BoxInputField(
                  controller: currentPassword,
                  password: true,
                ),
                SizedBox(height: 16.0),
                Text(trans.newPassword,
                    style: h3.copyWith(color: theme.colorScheme.onSurface)),
                SizedBox(height: 16.0),
                BoxInputField(
                  controller: newPassword,
                  password: true,
                ),
                SizedBox(height: 16.0),
                Text(trans.confirmNewPassword,
                    style: h3.copyWith(color: theme.colorScheme.onSurface)),
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
