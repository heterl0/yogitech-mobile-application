import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:YogiTech/src/custombar/bottombar.dart';
import 'package:YogiTech/src/pages/_mainscreen.dart';
import 'package:YogiTech/src/shared/app_colors.dart';
import 'package:YogiTech/src/shared/styles.dart';
import 'package:YogiTech/src/widgets/box_input_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:YogiTech/src/widgets/dropdown_field.dart';

class PrelaunchSurvey2 extends StatefulWidget {
  @override
  _PrelaunchSurvey2State createState() => _PrelaunchSurvey2State();
}

class _PrelaunchSurvey2State extends State<PrelaunchSurvey2> {
  final TextEditingController interested = TextEditingController();
  final TextEditingController height = TextEditingController();
  final TextEditingController weight = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
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
                SizedBox(height: 16.0),
                Text(trans.interested,
                    style: h3.copyWith(color: theme.colorScheme.onPrimary)),
                SizedBox(height: 12.0),
                CustomDropdownFormField(
                  controller: interested,
                  items: [
                    trans.fitness,
                    trans.nature,
                    trans.health,
                    trans.happy,
                    trans.sports,
                    trans.breath,
                    trans.mood,
                    trans.motivation
                  ],
                  placeholder:
                      interested.text.isEmpty ? trans.choose : interested.text,
                  onTap: () {
                    // Tùy chỉnh hành động khi dropdown được nhấn, nếu cần thiết
                  },
                ),

                SizedBox(height: 16.0),
                // Last Name
                Text(trans.weightKg, style: h3.copyWith(color: active)),
                SizedBox(height: 12.0),
                BoxInputField(
                  controller: weight,
                  placeholder: '60',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),

                SizedBox(height: 16.0),
                // Height
                Text(trans.heightCm, style: h3.copyWith(color: active)),
                SizedBox(height: 12.0),
                BoxInputField(
                  controller: height,
                  placeholder: '168',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),

                SizedBox(height: 16.0),
                // Weight
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        buttonTitle: trans.letsGo,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(
                isDarkMode: false, // Set the appropriate value
                onThemeChanged: (bool value) {
                  // Define the theme change logic
                },
                locale: Locale('en'), // Set the appropriate locale
                onLanguageChanged: (bool value) {
                  // Define the language change logic
                },
                isVietnamese: false, // Set the appropriate value
              ),
            ),
          );
        },
      ),
    );
  }
}
