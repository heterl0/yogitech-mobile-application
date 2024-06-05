import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/widgets/box_input_field.dart';

class ChangeProfilePage extends StatefulWidget {
  const ChangeProfilePage({super.key});

  @override
  State<ChangeProfilePage> createState() => _ChangeProfilePageState();
}

class _ChangeProfilePageState extends State<ChangeProfilePage> {
  final TextEditingController userName = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController birthday = TextEditingController();
  final TextEditingController gender = TextEditingController();

  // Regular expression for Vietnamese phone numbers
  final RegExp phoneRegExp =
      RegExp(r'^(03|05|07|08|09|01[2|6|8|9])+([0-9]{8})$');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.white.withOpacity(0),
      hintStyle: TextStyle(
        color: Color(0xFF8D8E99),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(44.0),
        borderSide: BorderSide(color: Color(0xFF8D8E99)),
      ),
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24.0),
            bottomRight: Radius.circular(24.0),
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: theme.colorScheme.onSecondary,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 12.0,
                  right: 20.0,
                  left: 20.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Spacer(),
                    Text('Profile', style: h2.copyWith(color: active)),
                    Spacer(
                      flex: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
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
                      border: Border.all(
                        color: Colors.blueGrey,
                        width: 1.5,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 78,
                      backgroundImage: AssetImage('assets/images/avatar.png'),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Handle change avatar action here
                    },
                    child: Text(
                      'Change avatar',
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text('Username', style: h3.copyWith(color: active)),
                SizedBox(height: 16.0),
                BoxInputField(
                  controller: userName,
                  placeholder: 'User name',
                ),
                SizedBox(height: 16.0),
                Text('Phone', style: h3.copyWith(color: active)),
                SizedBox(height: 16.0),
                TextField(
                  controller: phone,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: inputDecoration.copyWith(
                    hintText: 'Phone number',
                    errorText: phone.text.isNotEmpty &&
                            !phoneRegExp.hasMatch(phone.text)
                        ? 'Invalid phone number'
                        : null,
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 16.0),
                Text('Birthday', style: h3.copyWith(color: active)),
                SizedBox(height: 16.0),
                TextField(
                  controller: birthday,
                  readOnly: true,
                  decoration: inputDecoration.copyWith(
                    hintText: 'Select your birthday',
                    suffixIcon:
                        Icon(Icons.calendar_today, color: Color(0xFF8D8E99)),
                  ),
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
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 16.0),
                Text('Gender', style: h3.copyWith(color: active)),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  decoration: inputDecoration,
                  hint: Text('Select gender',
                      style: TextStyle(color: Color(0xFF8D8E99))),
                  items: ['Male', 'Female', 'Other']
                      .map((label) => DropdownMenuItem(
                            child: Text(label,
                                style: TextStyle(color: Color(0xFF8D8E99))),
                            value: label,
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      gender.text = value!;
                    });
                  },
                ),
                SizedBox(height: 16.0),
                Center(
                  child: TextButton(
                    onPressed: () {
                      _showChangePasswordDrawer(context);
                    },
                    child: Text(
                      'Change password',
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 0.0),
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Handle change BMI action here
                    },
                    child: Text(
                      'Change BMI',
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(),
    );
  }

  void _showChangePasswordDrawer(BuildContext context) {
    final theme = Theme.of(context);
    final TextEditingController currentPassword = TextEditingController();
    final TextEditingController newPassword = TextEditingController();
    final TextEditingController confirmNewPassword = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
            top: 24.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Old password', style: h3.copyWith(color: active)),
              SizedBox(height: 16.0),
              BoxInputField(
                controller: currentPassword,
                password: true,
              ),
              SizedBox(height: 16.0),
              Text('New password', style: h3.copyWith(color: active)),
              SizedBox(height: 16.0),
              BoxInputField(
                controller: newPassword,
                password: true,
              ),
              SizedBox(height: 16.0),
              Text('Confirm password', style: h3.copyWith(color: active)),
              SizedBox(height: 16.0),
              BoxInputField(
                controller: confirmNewPassword,
                password: true,
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  // Handle save password action here
                },
                child: Text('Save'),
                style: ElevatedButton.styleFrom(
                  // primary: theme.primaryColor,
                  padding:
                      EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
