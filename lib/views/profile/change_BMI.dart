import 'package:YogiTech/services/account/account_service.dart';
import 'package:flutter/material.dart';
import 'package:YogiTech/custombar/appbar.dart';
import 'package:YogiTech/models/account.dart';
import 'package:YogiTech/shared/styles.dart';
import 'package:YogiTech/shared/app_colors.dart';
import 'package:YogiTech/widgets/box_input_field.dart';
import 'package:YogiTech/widgets/box_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangeBMIPage extends StatefulWidget {
  final VoidCallback onBMIUpdated;
  final Profile profile;

  const ChangeBMIPage(
      {super.key, required this.onBMIUpdated, required this.profile});

  @override
  State<ChangeBMIPage> createState() => _ChangeBMIPageState();
}

class _ChangeBMIPageState extends State<ChangeBMIPage> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  String bmiResult = '';
  String bmiComment = '';

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    weightController.text = widget.profile.weight ?? '';
    heightController.text = widget.profile.height ?? '';
  }

  void _calculateBMI() {
    final trans = AppLocalizations.of(context)!;
    double? weight = weightController.text.isNotEmpty
        ? double.tryParse(weightController.text)
        : null;
    double? height = heightController.text.isNotEmpty
        ? double.tryParse(heightController.text)
        : null;

    if (weight != null && height != null) {
      height = height / 100; // Convert cm to meters
      double bmi = weight / (height * height);
      if (bmi > 100) {
        bmi = 100; // Reset BMI if it's too high
      }
      if (bmi < 0) {
        bmi = 0; // Reset BMI if it's negative
      }
      setState(() {
        bmiResult = bmi.toStringAsFixed(2); // Round BMI to 2 decimal places
        if (bmi < 18.5) {
          bmiComment = trans.underweight;
        } else if (bmi >= 18.5 && bmi < 24.9) {
          bmiComment = trans.normalWeight;
        } else if (bmi >= 24.9 && bmi < 29.9) {
          bmiComment = trans.overweight;
        } else {
          bmiComment = trans.obesity;
        }
      });
    } else {
      setState(() {
        bmiResult = '';
        bmiComment = '';
      });
    }
  }

  Future<void> _recalculateBMI() async {
    final trans = AppLocalizations.of(context)!;
    _calculateBMI();

    double? weight = weightController.text.isNotEmpty
        ? double.tryParse(weightController.text)
        : null;
    double? height = heightController.text.isNotEmpty
        ? double.tryParse(heightController.text)
        : null;

    if (weight != null && height != null) {
      height = height / 100; // Convert cm to meters
      double bmi = weight / (height * height);

      try {
        final Profile? updatedProfile = await patchBMI(PatchBMIRequest(
          weight: weight,
          height: height * 100,
          bmi: double.parse(bmi.toStringAsFixed(2)),
        ));
        if (updatedProfile != null) {
          widget.onBMIUpdated();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                trans.updateSuccess,
                style: bd_text.copyWith(color: active),
              ),
              backgroundColor: green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                trans.updateFail,
                style: bd_text.copyWith(color: active),
              ),
              backgroundColor: error,
            ),
          );
        }
      } catch (e) {
        print('Error updating BMI: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        title: trans.changeBMI,
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
                      border: Border.all(color: stroke, width: 2),
                    ),
                    child: ShaderMask(
                      shaderCallback: (bounds) {
                        return gradient.createShader(bounds);
                      },
                      child: Center(
                        child: Text(
                          bmiResult.isNotEmpty
                              ? bmiResult
                              : (widget.profile.bmi != null
                                  ? widget.profile.bmi.toString()
                                  : 'BMI'),
                          style: h1.copyWith(color: primary),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Center(
                  child: Text(bmiComment, style: h3.copyWith(color: text)),
                ),
                SizedBox(height: 16),
                Text(
                  trans.weightKg,
                  style: h3.copyWith(color: theme.colorScheme.onPrimary),
                ),
                SizedBox(height: 8.0),
                BoxInputField(
                  controller: weightController,
                  placeholder: trans.weightKg,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _calculateBMI(),
                ),
                SizedBox(height: 16.0),
                Text(
                  trans.heightCm,
                  style: h3.copyWith(color: theme.colorScheme.onPrimary),
                ),
                SizedBox(height: 8.0),
                BoxInputField(
                  controller: heightController,
                  placeholder: trans.heightCm,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _calculateBMI(),
                ),
                SizedBox(height: 16.0),
                CustomButton(
                    title: trans.updateBMI,
                    onPressed: _recalculateBMI,
                    style: ButtonStyleType.Primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
