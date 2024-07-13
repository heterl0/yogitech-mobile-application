// import 'package:YogiTech/src/models/account.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:YogiTech/src/custombar/bottombar.dart';
// import 'package:YogiTech/src/pages/_mainscreen.dart';
// import 'package:YogiTech/src/shared/app_colors.dart';
// import 'package:YogiTech/src/shared/styles.dart';
// import 'package:YogiTech/src/widgets/box_input_field.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:YogiTech/src/widgets/dropdown_field.dart';
// import 'package:YogiTech/api/account/account_service.dart';

// class PrelaunchSurvey2 extends StatefulWidget {
//   final Profile profile;
//   const PrelaunchSurvey2({super.key, required this.profile});

//   @override
//   _PrelaunchSurvey2State createState() => _PrelaunchSurvey2State();
// }

// class _PrelaunchSurvey2State extends State<PrelaunchSurvey2> {
//   final TextEditingController level = TextEditingController();
//   final TextEditingController height = TextEditingController();
//   final TextEditingController weight = TextEditingController();
//   late Profile _profile;
//   bool _isSent = false;
//   List<bool> _isValid = [false, false, false];

//   @override
//   void initState() {
//     super.initState();
//     _profile = widget.profile;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final trans = AppLocalizations.of(context)!;
//     return Scaffold(
//       backgroundColor: theme.colorScheme.surface,
//       body: Center(
//         child: SingleChildScrollView(
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 20.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 SizedBox(height: 16.0),
//                 Text(trans.level,
//                     style: h3.copyWith(color: theme.colorScheme.onPrimary)),
//                 SizedBox(height: 12.0),
//                 CustomDropdownFormField(
//                   controller: level,
//                   items: [
//                     trans.beginner,
//                     trans.intermediate,
//                     trans.advanced,
//                   ],
//                   placeholder: level.text.isEmpty ? trans.choose : level.text,
//                   onTap: () {
//                     setState(() {});
//                   },
//                 ),
//                 if (_isSent == true && !_isValid[0])
//                   Padding(
//                     padding: const EdgeInsets.only(
//                         left: 16.0,
//                         top: 8), // adjust the padding value as needed
//                     child: Text('${trans.level} ${trans.mustInput}',
//                         style: bd_text.copyWith(color: Colors.redAccent)),
//                   ),
//                 SizedBox(height: 16.0),
//                 _buildWeightField(trans),
//                 if (_isSent == true && !_isValid[1])
//                   Padding(
//                     padding: const EdgeInsets.only(
//                         left: 16.0,
//                         top: 8), // adjust the padding value as needed
//                     child: Text('${trans.weightKg} ${trans.mustInput}',
//                         style: bd_text.copyWith(color: Colors.redAccent)),
//                   ),
//                 SizedBox(height: 16.0),
//                 _buildHeightField(trans),
//                 if (_isSent == true && !_isValid[2])
//                   Padding(
//                     padding: const EdgeInsets.only(
//                         left: 16.0,
//                         top: 8), // adjust the padding value as needed
//                     child: Text('${trans.heightCm} ${trans.mustInput}',
//                         style: bd_text.copyWith(color: Colors.redAccent)),
//                   ),
//                 SizedBox(height: 16.0),
//               ],
//             ),
//           ),
//         ),
//       ),
//       bottomNavigationBar: CustomBottomBar(
//         buttonTitle: trans.letsGo,
//         onPressed: _saveUserBMI,
//       ),
//     );
//   }

//   Widget _buildWeightField(AppLocalizations trans) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         Text(trans.weightKg, style: h3.copyWith(color: active)),
//         SizedBox(height: 12.0),
//         BoxInputField(
//           controller: weight,
//           placeholder: '60',
//           keyboardType: TextInputType.numberWithOptions(decimal: true),
//           inputFormatters: [
//             FilteringTextInputFormatter.allow(RegExp(
//                 r'^\d{0,3}(\.\d{0,2})?$')), // allow 2 to 3 digits before decimal point and up to 2 digits after
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildHeightField(AppLocalizations trans) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         Text(trans.heightCm, style: h3.copyWith(color: active)),
//         SizedBox(height: 12.0),
//         BoxInputField(
//           controller: height,
//           placeholder: '168',
//           keyboardType: TextInputType.number,
//           inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//         ),
//       ],
//     );
//   }

//   Future<void> _saveUserBMI() async {
//     setState(() {
//       _isSent = true;
//       _isValid = _checkValid();
//     });

//     if (_isValid[0] && _isValid[1] && _isValid[2]) {
//       double? userWeight = double.tryParse(weight.text);
//       double? userHeight = double.tryParse(height.text);

//       if (userWeight != null && userHeight != null) {
//         try {
//           final updatedProfile = await patchPreLaunch(PatchProfileRequest(
//             firstName: _profile.first_name,
//             lastName: _profile.last_name,
//             birthdate: DateTime.parse(_profile.birthdate.toString()),
//             weight: userWeight,
//             height: userHeight,
//             bmi: calculateBMI(userWeight, userHeight),
//           ));
//           if (updatedProfile != null) {
//             print('BMI updated successfully');
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => MainScreen(
//                   isDarkMode: false, // Set the appropriate value
//                   onThemeChanged: (bool value) {
//                     // Define the theme change logic
//                   },
//                   locale: Locale('en'), // Set the appropriate locale
//                   onLanguageChanged: (bool value) {
//                     // Define the language change logic
//                   },
//                   isVietnamese: false, // Set the appropriate value
//                 ),
//               ),
//             );
//           } else {
//             print('Failed to update BMI');
//           }
//         } catch (e) {
//           print('Error updating BMI: $e');
//         }
//       } else {
//         print('Invalid input for weight or height');
//       }
//     }
//   }

//   double calculateBMI(double weight, double height) {
//     double bmi = weight / ((height / 100) * (height / 100));
//     return double.parse(bmi.toStringAsFixed(2));
//   }

//   List<bool> _checkValid() {
//     return [
//       (level.text.trim() != ''),
//       (double.tryParse(weight.text) != null),
//       (double.tryParse(height.text) != null)
//     ];
//   }
// }
