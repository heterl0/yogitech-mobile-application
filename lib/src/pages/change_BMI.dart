import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/widgets/box_input_field.dart';
import 'package:yogi_application/src/widgets/box_button.dart';

class ChangeBMIPage extends StatefulWidget {
  const ChangeBMIPage({Key? key}) : super(key: key);

  @override
  State<ChangeBMIPage> createState() => _ChangeBMIPageState();
}

class _ChangeBMIPageState extends State<ChangeBMIPage> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  String bmiResult = '';
  String bmiComment = '';

  void calculateBMI() {
    if (weightController.text.isNotEmpty && heightController.text.isNotEmpty) {
      double weight = double.parse(weightController.text);
      double height =
          double.parse(heightController.text) / 100; // Convert cm to meters
      double bmi = weight / (height * height);
      setState(() {
        bmiResult = bmi.toStringAsFixed(2); // Round BMI to 2 decimal places
        if (bmi < 18.5) {
          bmiComment = 'Underweight';
        } else if (bmi >= 18.5 && bmi < 24.9) {
          bmiComment = 'Normal weight';
        } else if (bmi >= 24.9 && bmi < 29.9) {
          bmiComment = 'Overweight';
        } else {
          bmiComment = 'Obesity';
        }
      });
    } else {
      setState(() {
        bmiResult = '';
        bmiComment = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                      icon: Icon(
                        Icons.arrow_back,
                        color: theme.colorScheme.onBackground,
                      ), // Sử dụng icon "back" có sẵn
                      onPressed: () {
                        Navigator.pop(context); // Thêm sự kiện quay lại
                      },
                    ),
                    Text('Change BMI',
                        style:
                            h2.copyWith(color: theme.colorScheme.onBackground)),
                    Opacity(
                      opacity: 0.0,
                      child: IgnorePointer(
                        child: IconButton(
                          icon: Image.asset('assets/icons/settings.png'),
                          onPressed: () {},
                        ),
                      ),
                    ) // Ẩn icon đi
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
                        border: Border.all(color: stroke, width: 2),
                      ),
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return gradient.createShader(bounds);
                        },
                        child: Center(
                          child: Text(
                            bmiResult.isNotEmpty ? bmiResult : 'BMI',
                            style: h1.copyWith(color: primary),
                          ),
                        ),
                      )),
                ),
                SizedBox(height: 8),
                Center(
                  child: Text(bmiComment, style: h3.copyWith(color: text)),
                ),
                SizedBox(height: 16),
                Text(
                  'Weight (kg)',
                  style: h3.copyWith(color: theme.colorScheme.onPrimary),
                ),
                SizedBox(height: 8.0),
                BoxInputField(
                  controller: weightController,
                  placeholder: 'Weight',
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16.0),
                Text(
                  'Height (cm)',
                  style: h3.copyWith(color: theme.colorScheme.onPrimary),
                ),
                SizedBox(height: 8.0),
                BoxInputField(
                  controller: heightController,
                  placeholder: 'Height',
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 48.0),
                BoxButton(
                    title: 'Recaculate',
                    onPressed: calculateBMI,
                    style: ButtonStyleType.Primary),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(),
    );
  }
}
