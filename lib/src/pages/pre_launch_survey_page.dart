import 'package:YogiTech/src/pages/_onbroading.dart';
import 'package:YogiTech/src/widgets/dropdown_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:YogiTech/src/custombar/bottombar.dart';
import 'package:YogiTech/src/shared/app_colors.dart';
import 'package:YogiTech/src/shared/styles.dart';
import 'package:YogiTech/src/widgets/box_input_field.dart';
import 'package:YogiTech/api/account/account_service.dart';
import 'package:YogiTech/src/models/account.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PrelaunchSurveyPage extends StatefulWidget {
  const PrelaunchSurveyPage({Key? key}) : super(key: key);

  @override
  _PrelaunchSurveyPageState createState() => _PrelaunchSurveyPageState();
}

class _PrelaunchSurveyPageState extends State<PrelaunchSurveyPage> {
  final PageController _pageController = PageController();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController birthday = TextEditingController();
  final TextEditingController gender = TextEditingController();
  final TextEditingController level = TextEditingController();
  final TextEditingController height = TextEditingController();
  final TextEditingController weight = TextEditingController();
  Profile? _profile;
  bool _isSent1 = false;
  bool _isSent2 = false;

  final Map<String, bool> _isValid = {
    'firstName': false,
    'lastName': false,
    'birthday': false,
    'gender': false,
    'level': false,
    'weight': false,
    'height': false,
  };

  static const String _dateFormat = 'dd/MM/yyyy'; // Định dạng ngày tháng
  final DateFormat _dateFormatter = DateFormat(_dateFormat);

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
          weight.text = profile.weight ?? '';
          height.text = profile.height ?? '';

          _profile = profile;
        });
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  String _formatDate(DateTime date) {
    return _dateFormatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;

    return WillPopScope(
      onWillPop: () async {
        _savePage1();
        return true;
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: Stack(
          children: [
            PageView.builder(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              itemCount: 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildPage1(trans, theme);
                } else {
                  return _buildPage2(trans, theme);
                }
              },
            ),
            Positioned(
              bottom: 20.0,
              left: 20.0,
              right: 20.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: 2,
                    effect: WormEffect(
                      dotHeight: 12,
                      dotWidth: 12,
                      spacing: 16,
                      dotColor: stroke,
                      activeDotColor: theme.colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomBar(
          buttonTitle: trans.next,
          onPressed: () {
            if (_pageController.page == 0) {
              if (_validatePage1()) {
                _savePage1();
                _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            } else {
              if (_validatePage2()) {
                _savePage2();
              }
            }
          },
        ),
      ),
    );
  }

  Widget _buildPage1(AppLocalizations trans, ThemeData theme) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    trans.welcomeToYogi.replaceFirst(" Yogi", ""),
                    style: h1.copyWith(
                        color: theme.colorScheme.onPrimary, height: 1.2),
                  ),
                  Text(
                    'Yogi',
                    style: h1.copyWith(color: primary, height: 1.2),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Center(
                child: Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.center,
                  children: [
                    Text(
                      trans.fillInformation,
                      style: bd_text.copyWith(color: text),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Text(trans.lastName,
                  style: h3.copyWith(color: theme.colorScheme.onPrimary)),
              SizedBox(height: 16.0),
              BoxInputField(
                controller: lastName,
                placeholder: trans.lastName,
              ),
              if (_isSent1 && !_isValid['lastName']!)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8),
                  child: Text('${trans.lastName} ${trans.mustInput}',
                      style: bd_text.copyWith(color: error)),
                ),
              SizedBox(height: 16.0),
              Text(trans.firstName,
                  style: h3.copyWith(color: theme.colorScheme.onPrimary)),
              SizedBox(height: 16.0),
              BoxInputField(
                controller: firstName,
                placeholder: trans.firstName,
              ),
              if (_isSent1 && !_isValid['firstName']!)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8),
                  child: Text('${trans.firstName} ${trans.mustInput}',
                      style: bd_text.copyWith(color: error)),
                ),
              SizedBox(height: 16.0),
              Text(trans.birthday,
                  style: h3.copyWith(color: theme.colorScheme.onPrimary)),
              SizedBox(height: 16.0),
              BoxInputField(
                controller: birthday,
                placeholder: trans.birthday == "Birthday"
                    ? "Select your birthday"
                    : "Chọn ngày sinh của bạn",
                trailing: Icon(Icons.calendar_today),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      birthday.text = _formatDate(pickedDate);
                    });
                  }
                },
              ),
              if (_isSent1 && !_isValid['birthday']!)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8),
                  child: Text('${trans.birthday} ${trans.mustInput}',
                      style: bd_text.copyWith(color: error)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage2(AppLocalizations trans, ThemeData theme) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                trans.gender,
                style: h3.copyWith(color: theme.colorScheme.onPrimary),
              ),
              SizedBox(height: 8.0),
              CustomDropdownFormField(
                controller: gender,
                items: [
                  'Female',
                  'Male',
                  'Other',
                ],
                placeholder:
                    gender.text.isEmpty ? trans.sellectGender : gender.text,
                onTap: () {
                  // Optional: handle dropdown tap
                },
              ),
              if (_isSent2 && !_isValid['gender']!)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8),
                  child: Text('${trans.gender} ${trans.mustInput}',
                      style: bd_text.copyWith(color: error)),
                ),
              SizedBox(height: 16.0),
              Text(trans.level,
                  style: h3.copyWith(color: theme.colorScheme.onPrimary)),
              SizedBox(height: 12.0),
              CustomDropdownFormField(
                controller: level,
                items: [
                  trans.beginner,
                  trans.intermediate,
                  trans.advanced,
                ],
                placeholder: level.text.isEmpty ? trans.choose : level.text,
                onTap: () {
                  setState(() {});
                },
              ),
              if (_isSent2 && !_isValid['level']!)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8),
                  child: Text('${trans.level} ${trans.mustInput}',
                      style: bd_text.copyWith(color: error)),
                ),
              SizedBox(height: 16.0),
              _buildWeightField(trans),
              if (_isSent2 && !_isValid['weight']!)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8),
                  child: Text('${trans.weightKg} ${trans.mustInput}',
                      style: bd_text.copyWith(color: error)),
                ),
              SizedBox(height: 16.0),
              _buildHeightField(trans),
              if (_isSent2 && !_isValid['height']!)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8),
                  child: Text('${trans.heightCm} ${trans.mustInput}',
                      style: bd_text.copyWith(color: error)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeightField(AppLocalizations trans) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(trans.weightKg,
            style: h3.copyWith(color: theme.colorScheme.onPrimary)),
        SizedBox(height: 12.0),
        BoxInputField(
          controller: weight,
          placeholder: trans.weightKg,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d{0,3}(\.\d{0,2})?$')),
          ],
        ),
      ],
    );
  }

  Widget _buildHeightField(AppLocalizations trans) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(trans.heightCm,
            style: h3.copyWith(color: theme.colorScheme.onPrimary)),
        SizedBox(height: 12.0),
        BoxInputField(
          controller: height,
          placeholder: trans.heightCm,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
      ],
    );
  }

  bool _validatePage1() {
    setState(() {
      _isSent1 = true;
      _isValid['firstName'] = firstName.text.trim().isNotEmpty;
      _isValid['lastName'] = lastName.text.trim().isNotEmpty;
      _isValid['birthday'] = birthday.text.trim().isNotEmpty;
    });

    return _isValid['firstName']! &&
        _isValid['lastName']! &&
        _isValid['birthday']!;
  }

  void _savePage1() {
    if (_validatePage1() && _profile != null) {
      _profile!.first_name = firstName.text.trim();
      _profile!.last_name = lastName.text.trim();

      try {
        DateTime parsedBirthday = _dateFormatter.parse(birthday.text);
        _profile!.birthdate = parsedBirthday.toIso8601String();
      } catch (e) {
        print('Error parsing birthday: $e');
      }
    }
  }

  bool _validatePage2() {
    setState(() {
      _isSent2 = true;
      _isValid['gender'] = gender.text.trim().isNotEmpty;
      _isValid['level'] = level.text.trim().isNotEmpty;
      _isValid['weight'] = weight.text.trim().isNotEmpty;
      _isValid['height'] = height.text.trim().isNotEmpty;
    });

    return _isValid['gender']! &&
        _isValid['level']! &&
        _isValid['weight']! &&
        _isValid['height']!;
  }

  Future<void> _savePage2() async {
    if (_validatePage2() && _profile != null) {
      double? userWeight = double.tryParse(weight.text);
      double? userHeight = double.tryParse(height.text);
      int? userGender = genderMap.entries
          .firstWhere((entry) => entry.value == gender.text,
              orElse: () => MapEntry(2, 'Other'))
          .key;
      print("Giới tánh: ${gender.text}, int là? ${userGender}");

      if (userWeight != null && userHeight != null) {
        try {
          final updatedProfile = await patchPreLaunch(PatchProfileRequest(
            firstName: _profile!.first_name,
            lastName: _profile!.last_name,
            birthdate: DateTime.parse(_profile!.birthdate.toString()),
            gender: userGender,
            weight: userWeight,
            height: userHeight,
            bmi: calculateBMI(userWeight, userHeight),
          ));
          if (updatedProfile != null) {
            print('BMI updated successfully');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => OnboardingScreen()),
            );
          } else {
            print('Failed to update BMI');
          }
        } catch (e) {
          print('Error updating BMI: $e');
        }
      } else {
        print('Invalid input for weight or height');
      }
    }
  }

  double calculateBMI(double weight, double height) {
    double bmi = weight / ((height / 100) * (height / 100));
    return double.parse(bmi.toStringAsFixed(2));
  }
}
