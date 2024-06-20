import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  final RegExp phoneRegExp =
      RegExp(r'^(03|05|07|08|09|01[2|6|8|9])+([0-9]{8})$');

  Profile? _profile;
  Account? _account;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    Profile? profile = await getUserProfile();
    Account? account = await retrieveAccount();
    setState(() {
      _profile = profile;
      _account = account;
    });
  }

  void refreshProfile() {
    _fetchUserProfile();
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
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 78,
                      backgroundImage: AssetImage('assets/images/avatar.png'),
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
                Text(trans.username,
                    style: h3.copyWith(color: theme.colorScheme.onPrimary)),
                SizedBox(height: 8.0),
                BoxInputField(
                  controller: userName,
                  placeholder: trans.username,
                ),
                SizedBox(height: 16.0),
                Text('Email',
                    style: h3.copyWith(color: theme.colorScheme.onPrimary)),
                SizedBox(height: 8.0),
                BoxInputField(
                  controller: email,
                  placeholder: 'Email',
                ),
                SizedBox(height: 16.0),
                Text('Phone',
                    style: h3.copyWith(color: theme.colorScheme.onPrimary)),
                SizedBox(height: 8.0),
                BoxInputField(
                  controller: phone,
                  placeholder: trans.phoneNumber,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  regExp: phoneRegExp,
                  errorText: "Invalid phone number",
                ),
                SizedBox(height: 16.0),
                Text(trans.birthday,
                    style: h3.copyWith(color: theme.colorScheme.onPrimary)),
                SizedBox(height: 8.0),
                BoxInputField(
                  controller: birthday,
                  placeholder: 'Select your birthday',
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
                        birthday.text = "${pickedDate.toLocal()}".split(' ')[0];
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
                  placeholder: 'Select gender',
                  onTap: () {},
                ),
                SizedBox(height: 40.0),
                BoxButton(
                  title: trans.save,
                  style: ButtonStyleType.Primary,
                  onPressed: () {},
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
                  state: ButtonState.Enabled,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Mock implementation for CustomDropdownFormField if not defined
class CustomDropdownFormField extends StatelessWidget {
  final TextEditingController controller;
  final List<String> items;
  final String placeholder;
  final VoidCallback onTap;

  const CustomDropdownFormField({
    Key? key,
    required this.controller,
    required this.items,
    required this.placeholder,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: controller.text.isEmpty ? null : controller.text,
      decoration: InputDecoration(
        hintText: placeholder,
      ),
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        controller.text = newValue!;
      },
      onTap: onTap,
    );
  }
}
