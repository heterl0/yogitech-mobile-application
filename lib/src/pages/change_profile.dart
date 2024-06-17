import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yogi_application/src/custombar/appbar.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/widgets/box_input_field.dart';
import 'package:yogi_application/src/widgets/dropdown_field.dart';
import 'package:yogi_application/src/widgets/box_button.dart';
import 'package:yogi_application/src/pages/change_BMI.dart';

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

  
  // Regular expression for Vietnamese phone numbers
  final RegExp phoneRegExp =
      RegExp(r'^(03|05|07|08|09|01[2|6|8|9])+([0-9]{8})$');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: CustomAppBar(
        title: 'Edit Profile',
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
                  title: 'Change avatar', // Set the button text
                  style: ButtonStyleType
                      .Tertiary, // Set the button style (optional)
                  onPressed: () {
                    // Handle change avatar action here
                  },
                ),
                SizedBox(height: 16),
                Text('Username',
                    style: h3.copyWith(color: theme.colorScheme.onPrimary)),
                SizedBox(height: 8.0),
                BoxInputField(
                  controller: userName,
                  placeholder: 'User name',
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
                  placeholder: 'Phone number',
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  regExp: phoneRegExp, // Đảm bảo phoneRegExp được định nghĩa
                  errorText: "Invalid phone number",
                ),
                SizedBox(height: 16.0),
                Text('Birthday',
                    style: h3.copyWith(color: theme.colorScheme.onPrimary)),
                SizedBox(height: 8.0),
                BoxInputField(
                  controller: birthday,
                  placeholder: 'Select your birthday',
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
                      });
                    }
                  },
                ),
                SizedBox(height: 16.0),
                Text('Gender',
                    style: h3.copyWith(color: theme.colorScheme.onPrimary)),
                SizedBox(height: 8.0),
                // DropdownButtonFormField<String>(
                //   decoration: inputDecoration,
                //   hint: Text('Select gender',
                //       style: TextStyle(color: Color(0xFF8D8E99))),
                //   items: ['Male', 'Female', 'Other']
                //       .map((label) => DropdownMenuItem(
                //             child: Text(label,
                //                 style: TextStyle(color: Color(0xFF8D8E99))),
                //             value: label,
                //           ))
                //       .toList(),
                //   onChanged: (value) {
                //     setState(() {
                //       gender.text = value!;
                //     });
                //   },
                // ),
                CustomDropdownFormField(
                  controller: gender,
                  items: ['Male', 'Female', 'Other'],
                  placeholder: 'Select gender',
                  onTap: () {
                    // Tùy chỉnh hành động khi dropdown được nhấn, nếu cần thiết
                  },
                ),

                SizedBox(height: 16.0),
                BoxButton(
                  title: 'Change password', // Set the button text
                  style: ButtonStyleType
                      .Tertiary, // Set the button style (optional)
                  onPressed: () {
                    // _showChangePasswordDrawer(context);
                    _changePasswordBottomSheet(context);
                  },
                ),
                SizedBox(height: 0.0),
                BoxButton(
                  title: 'Change BMI', // Set the button text
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
      bottomNavigationBar: CustomBottomBar(),
    );
  }

  Future<void> _changePasswordBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    final TextEditingController currentPassword = TextEditingController();
    final TextEditingController newPassword = TextEditingController();
    final TextEditingController confirmNewPassword = TextEditingController();
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: theme.colorScheme.onSecondary,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Old password',
                  style: h3.copyWith(color: theme.colorScheme.onBackground)),
              SizedBox(height: 16.0),
              BoxInputField(
                controller: currentPassword,
                password: true,
              ),
              SizedBox(height: 16.0),
              Text('New password',
                  style: h3.copyWith(color: theme.colorScheme.onBackground)),
              SizedBox(height: 16.0),
              BoxInputField(
                controller: newPassword,
                password: true,
              ),
              SizedBox(height: 16.0),
              Text('Confirm password',
                  style: h3.copyWith(color: theme.colorScheme.onBackground)),
              SizedBox(height: 16.0),
              BoxInputField(
                controller: confirmNewPassword,
                password: true,
              ),
              SizedBox(height: 32.0),
              BoxButton(
                title: 'Save',
                style: ButtonStyleType.Primary,
                state: ButtonState
                    .Enabled, // hoặc ButtonState.Disabled để test trạng thái disabled
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
