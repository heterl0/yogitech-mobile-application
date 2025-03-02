import 'package:flutter/material.dart';
import 'package:YogiTech/models/account.dart';
import 'package:YogiTech/services/account/account_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangeBMIViewModel extends ChangeNotifier {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  String bmiResult = '';
  String bmiComment = '';
  bool isLoading = false;

  void initialize(Profile profile) {
    weightController.text = profile.weight ?? '';
    heightController.text = profile.height ?? '';
  }

  void calculateBMI(BuildContext context) {
    final trans = AppLocalizations.of(context)!;
    double? weight = double.tryParse(weightController.text);
    double? height = double.tryParse(heightController.text);

    if (weight != null && height != null) {
      height /= 100; // Chuyển cm sang mét
      double bmi = weight / (height * height);
      bmi = bmi.clamp(0, 100); // Giới hạn giá trị BMI

      bmiResult = bmi.toStringAsFixed(2);
      bmiComment = _getBMICategory(bmi, trans);

      notifyListeners();
    } else {
      bmiResult = '';
      bmiComment = '';
      notifyListeners();
    }
  }

  Future<void> updateBMI(
      BuildContext context, Profile profile, VoidCallback onSuccess) async {
    final trans = AppLocalizations.of(context)!;
    double? weight = double.tryParse(weightController.text);
    double? height = double.tryParse(heightController.text);

    if (weight != null && height != null) {
      height /= 100; // Chuyển cm sang mét
      double bmi = weight / (height * height);

      isLoading = true;
      notifyListeners();

      try {
        final Profile? updatedProfile = await patchBMI(PatchBMIRequest(
          weight: weight,
          height: height * 100,
          bmi: double.parse(bmi.toStringAsFixed(2)),
        ));

        if (updatedProfile != null) {
          onSuccess();
          _showSnackbar(context, trans.updateSuccess, Colors.green);
        } else {
          _showSnackbar(context, trans.updateFail, Colors.red);
        }
      } catch (e) {
        debugPrint('Error updating BMI: $e');
        _showSnackbar(context, trans.updateFail, Colors.red);
      } finally {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  String _getBMICategory(double bmi, AppLocalizations trans) {
    if (bmi < 18.5) return trans.underweight;
    if (bmi < 24.9) return trans.normalWeight;
    if (bmi < 29.9) return trans.overweight;
    return trans.obesity;
  }

  void _showSnackbar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: color,
      ),
    );
  }
}
