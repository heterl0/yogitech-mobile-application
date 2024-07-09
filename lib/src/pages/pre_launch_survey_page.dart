import 'package:YogiTech/src/pages/_mainscreen.dart';
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
  final TextEditingController level = TextEditingController();
  final TextEditingController height = TextEditingController();
  final TextEditingController weight = TextEditingController();
  late Profile _profile;
  bool _isSent = false;
  List<bool> _isValid = [false, false, false];
  static const String _dateFormat = 'dd/MM/yyyy'; // Định dạng ngày tháng
  final DateFormat _dateFormatter = DateFormat(_dateFormat);

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
      onWillPop: () async {
        _saveUserProfile();
        return true;
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildFirstPage(trans, theme);
                } else {
                  return _buildSecondPage(trans, theme);
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
                      activeDotColor:
                          theme.colorScheme.onPrimary, // Màu chấm active trắng
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
              _saveUserProfile();
              _pageController.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            } else {
              _saveUserBMI();
            }
          },
        ),
      ),
    );
  }

  Widget _buildFirstPage(AppLocalizations trans, ThemeData theme) {
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
              Text(trans.firstName, style: h3.copyWith(color: active)),
              SizedBox(height: 16.0),
              BoxInputField(
                controller: firstName,
                placeholder: trans.firstName,
              ),
              if (_isSent && !_isValid[0])
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8),
                  child: Text('${trans.firstName} ${trans.mustInput}',
                      style: bd_text.copyWith(color: Colors.redAccent)),
                ),
              SizedBox(height: 16.0),
              Text(trans.lastName, style: h3.copyWith(color: active)),
              SizedBox(height: 16.0),
              BoxInputField(
                controller: lastName,
                placeholder: trans.lastName,
              ),
              if (_isSent && !_isValid[1])
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8),
                  child: Text('${trans.lastName} ${trans.mustInput}',
                      style: bd_text.copyWith(color: Colors.redAccent)),
                ),
              SizedBox(height: 16.0),
              Text(trans.birthday, style: h3.copyWith(color: active)),
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
                      birthday.text = _dateFormatter
                          .format(pickedDate); // Sử dụng formatter
                    });
                  }
                },
              ),
              if (_isSent && !_isValid[2])
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8),
                  child: Text('${trans.birthday} ${trans.mustInput}',
                      style: bd_text.copyWith(color: Colors.redAccent)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecondPage(AppLocalizations trans, ThemeData theme) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              if (_isSent && !_isValid[0])
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8),
                  child: Text('${trans.level} ${trans.mustInput}',
                      style: bd_text.copyWith(color: Colors.redAccent)),
                ),
              SizedBox(height: 16.0),
              _buildWeightField(trans),
              if (_isSent && !_isValid[1])
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8),
                  child: Text('${trans.weightKg} ${trans.mustInput}',
                      style: bd_text.copyWith(color: Colors.redAccent)),
                ),
              SizedBox(height: 16.0),
              _buildHeightField(trans),
              if (_isSent && !_isValid[2])
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8),
                  child: Text('${trans.heightCm} ${trans.mustInput}',
                      style: bd_text.copyWith(color: Colors.redAccent)),
                ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeightField(AppLocalizations trans) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(trans.weightKg, style: h3.copyWith(color: active)),
        SizedBox(height: 12.0),
        BoxInputField(
          controller: weight,
          placeholder: '60',
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d{0,3}(\.\d{0,2})?$')),
          ],
        ),
      ],
    );
  }

  Widget _buildHeightField(AppLocalizations trans) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(trans.heightCm, style: h3.copyWith(color: active)),
        SizedBox(height: 12.0),
        BoxInputField(
          controller: height,
          placeholder: '168',
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
      ],
    );
  }

  void _saveUserProfile() {
    setState(() {
      _isSent = true;
      _isValid = _checkValid();
    });

    if (_isValid[0] && _isValid[1] && _isValid[2]) {
      _profile.first_name = firstName.text.trim();
      _profile.last_name = lastName.text.trim();

      // Phân tích ngày tháng đã được định dạng trở lại thành DateTime
      try {
        DateTime parsedBirthday = _dateFormatter.parse(birthday.text);
        _profile.birthdate = parsedBirthday.toIso8601String();
      } catch (e) {
        // Xử lý trường hợp định dạng có thể không chính xác
        print('Lỗi khi phân tích ngày sinh: $e');
        // Bạn có thể muốn hiển thị thông báo lỗi cho người dùng ở đây
      }
    }
  }

  List<bool> _checkValid() {
    return [
      (firstName.text.trim() != ''),
      (lastName.text.trim() != ''),
      (birthday.text.trim() != ''),
    ];
  }

  Future<void> _saveUserBMI() async {
    setState(() {
      _isSent = true;
      _isValid = _checkValid();
    });

    if (_isValid[0] && _isValid[1] && _isValid[2]) {
      double? userWeight = double.tryParse(weight.text);
      double? userHeight = double.tryParse(height.text);

      if (userWeight != null && userHeight != null) {
        try {
          final updatedProfile = await patchPreLaunch(PatchProfileRequest(
            firstName: _profile.first_name,
            lastName: _profile.last_name,
            birthdate: DateTime.parse(_profile.birthdate.toString()),
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
