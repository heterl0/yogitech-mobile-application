import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/widgets/box_input_field.dart';

class PrelaunchSurveyPage extends StatefulWidget {
  @override
  _PrelaunchSurveyPageState createState() => _PrelaunchSurveyPageState();
}

class _PrelaunchSurveyPageState extends State<PrelaunchSurveyPage> {
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController birthday = TextEditingController();
  final TextEditingController height = TextEditingController();
  final TextEditingController weight = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome to ',
                      style: h1.copyWith(
                          color: theme.colorScheme.onPrimary, height: 1),
                    ),
                    Text('Yogi', style: h1.copyWith(color: primary, height: 1)),
                  ],
                ),
                SizedBox(height: 16.0),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Please fill in information here to optimize your experience',
                    style: min_cap.copyWith(color: text),
                  ),
                ),
                SizedBox(height: 16.0),
                // First Name
                Text('First Name', style: h3.copyWith(color: active)),
                SizedBox(height: 16.0),
                BoxInputField(
                  controller: firstName,
                  placeholder: 'First name',
                ),
                SizedBox(height: 16.0),
                // Last Name
                Text('Last Name', style: h3.copyWith(color: active)),
                SizedBox(height: 16.0),
                BoxInputField(
                  controller: lastName,
                  placeholder: 'Last name',
                ),
                SizedBox(height: 16.0),
                // Birthday
                Text('Birthday', style: h3.copyWith(color: active)),
                SizedBox(height: 16.0),
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
                // Height
                Text('Height(cm)', style: h3.copyWith(color: active)),
                SizedBox(height: 16.0),

                // TextField(
                //   controller: height,
                //   decoration: InputDecoration(
                //     filled: true,
                //     fillColor: Colors.white.withOpacity(0),
                //     hintText: 'e.g. 154.5',
                //     hintStyle: TextStyle(color: Color(0xFF8D8E99)),
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(44.0),
                //       borderSide: BorderSide(color: Color(0xFF8D8E99)),
                //     ),
                //   ),
                //   style: TextStyle(color: Colors.white),
                //   inputFormatters: [
                //     FilteringTextInputFormatter.allow(
                //         RegExp(r'^\d{0,3}\.?\d{0,1}$')),
                //     LengthLimitingTextInputFormatter(6),
                //   ],
                //   keyboardType: TextInputType.numberWithOptions(decimal: true),
                // ),

                BoxInputField(
                  controller: height,
                  placeholder: 'e.g. 154',
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),

                SizedBox(height: 16.0),
                // Weight
                Text('Weight(kg)', style: h3.copyWith(color: active)),
                SizedBox(height: 16.0),

                // TextField(
                //   controller: weight,
                //   decoration: InputDecoration(
                //     filled: true,
                //     fillColor: Colors.white.withOpacity(0),
                //     hintText: 'e.g. 70',
                //     hintStyle: TextStyle(color: Color(0xFF8D8E99)),
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(44.0),
                //       borderSide: BorderSide(color: Color(0xFF8D8E99)),
                //     ),
                //   ),
                //   style: TextStyle(color: Colors.white),
                //   inputFormatters: [
                //     FilteringTextInputFormatter.allow(RegExp(r'^\d{1,3}$')),
                //     LengthLimitingTextInputFormatter(3),
                //   ],
                //   keyboardType: TextInputType.number,
                // ),

                BoxInputField(
                  controller: height,
                  placeholder: 'e.g. 70',
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        defaultStyle: false,
        buttonTitle: "Let's go",
        onPressed: () {},
      ),
    );
  }
}
