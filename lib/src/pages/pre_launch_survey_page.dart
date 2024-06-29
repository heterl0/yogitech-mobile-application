import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:YogiTech/src/custombar/bottombar.dart';
import 'package:YogiTech/src/shared/app_colors.dart';
import 'package:YogiTech/src/shared/styles.dart';
import 'package:YogiTech/src/widgets/box_input_field.dart';
import 'package:YogiTech/src/pages/pre_launch_survey_2.dart';
import 'package:YogiTech/api/account/account_service.dart';
import 'package:YogiTech/src/models/account.dart';

class PrelaunchSurveyPage extends StatefulWidget {
  const PrelaunchSurveyPage({Key? key}) : super(key: key);

  @override
  _PrelaunchSurveyPageState createState() => _PrelaunchSurveyPageState();
}

class _PrelaunchSurveyPageState extends State<PrelaunchSurveyPage> {
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController birthday = TextEditingController();
  late Profile _profile;
  bool _isSent = false;
  List<bool> _isValid =[false,false,false];

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      Profile? profile = await getUserProfile();
      if (profile != null) {
        setState(() {
          firstName.text = profile.first_name ?? '';
          lastName.text = profile.last_name ?? '';
          if (profile.birthdate != null) {
            DateTime parsedDate = DateTime.parse(profile.birthdate!);
            birthday.text = _formatDate(parsedDate);
          }
          _profile = profile;
        });
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    return WillPopScope(
      // Intercept back navigation to save data
      onWillPop: () async {
        _saveUserProfile();
        return true; // Allow back navigation
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
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
                        trans.welcomeToYogi.replaceFirst(" Yogi", ""),
                        style: h2.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                      Text(
                        'Yogi',
                        style: h2.copyWith(
                          color: primary,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.0),
                  Center(
                    child: Wrap(
                      direction: Axis.horizontal,
                      alignment:
                          WrapAlignment.center, // Center text within each line
                      children: [
                        Text(
                          trans.fillInformation,
                          style: min_cap.copyWith(color: text),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.0),
                  // First Name
                  Text(trans.firstName, style: h3.copyWith(color: active)),
                  SizedBox(height: 16.0),
                  BoxInputField(
                    controller: firstName,
                    placeholder: trans.firstName,
                  ),
                  if (_isSent==true && !_isValid[0])
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0,top:8), // adjust the padding value as needed
                    child: Text('${trans.firstName} ${trans.mustInput}',
                        style: bd_text.copyWith(color: Colors.redAccent)),
                  ),
                  SizedBox(height: 16.0),
                  // Last Name
                  Text(trans.lastName, style: h3.copyWith(color: active)),
                  SizedBox(height: 16.0),
                  BoxInputField(
                    controller: lastName,
                    placeholder: trans.lastName,
                  ),
                  if (_isSent==true && !_isValid[1])
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0,top:8), // adjust the padding value as needed
                    child: Text('${trans.lastName} ${trans.mustInput}',
                        style: bd_text.copyWith(color: Colors.redAccent)),
                  ),
                  SizedBox(height: 16.0),
                  // Birthday
                  Text(trans.birthday, style: h3.copyWith(color: active)),
                  SizedBox(height: 16.0),
                  BoxInputField(
                    controller: birthday,
                    placeholder: trans.birthday == "Birthday"
                        ? "Select your birthday"
                        : "Chọn ngày sinh của bạn",
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
                          birthday.text =
                              "${pickedDate.toLocal()}".split(' ')[0];
                        });
                      }
                    },
                  ),
                  if (_isSent==true && (!_isValid[2]))
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0,top:8), // adjust the padding value as needed
                    child: Text('${trans.birthday} ${trans.mustInput}',
                        style: bd_text.copyWith(color: Colors.redAccent)),
                  )
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomBar(
          buttonTitle: trans.next,
          onPressed: () {
            _saveUserProfile(); // Save profile before navigation
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => PrelaunchSurvey2(),
            //   ),
            // );
          },
        ),
      ),
    );
  }

  List<bool> _checkValid(){
    return [(firstName.text.trim()!=''),(lastName.text.trim()!=''),(birthday.text.trim()!='')];
  }

  void _saveUserProfile() {
    setState(() {
    _isSent = true;
    _isValid = _checkValid();
    if(_isValid[0] && _isValid[1] && _isValid[2]){
      _profile.first_name = firstName.text.toString().trim();
      _profile.last_name = lastName.text.toString().trim();
      _profile.birthdate = DateTime.parse(birthday.text).toString().trim();
      print(_profile);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PrelaunchSurvey2(profile: _profile),),
      );
    }
    });
    
    
    // Save user profile information
    // try {
    //   // Create PatchProfileRequest object with updated values
    //   PatchProfileRequest request = PatchProfileRequest(
    //     firstName: firstName.text,
    //     lastName: lastName.text,
    //     birthdate: DateTime.parse(
    //         birthday.text), // Assuming birthday.text is in ISO8601 format
    //   );

    //   // Call patchProfile with the PatchProfileRequest object
    //   patchProfile(request, null).then((profile) {
    //     if (profile != null) {
    //       // Handle successful profile update
    //       print('User profile updated successfully');
    //       // Optionally, you can navigate to the next screen or update UI here
    //     } else {
    //       // Handle case where profile update failed
    //       print('Failed to update user profile');
    //     }
    //   }).catchError((e) {
    //     // Handle error case
    //     print('Error saving user profile: $e');
    //   });
    // } catch (e) {
    //   print('Error saving user profile: $e');
    // }
  }
}
