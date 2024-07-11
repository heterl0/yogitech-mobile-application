import 'package:flutter/material.dart';
import 'package:YogiTech/src/custombar/appbar.dart';
import 'package:YogiTech/src/shared/styles.dart';
import 'package:YogiTech/src/shared/app_colors.dart';
import 'package:YogiTech/src/widgets/box_input_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class PersonalizedExerciseCreatePage extends StatefulWidget {
  const PersonalizedExerciseCreatePage({super.key});

  @override
  _PersonalizedExerciseCreatePageState createState() =>
      _PersonalizedExerciseCreatePageState();
}

class _PersonalizedExerciseCreatePageState
    extends State<PersonalizedExerciseCreatePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _difficultyController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _difficultyController.dispose();
    _caloriesController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        title: trans.yourExercise,
        style: widthStyle.Large,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Text(
                trans.exercise,
                style: h3.copyWith(color: theme.colorScheme.onPrimary),
              ),
              BoxInputField(
                controller: _nameController,
              ),
              const SizedBox(height: 8),
              BoxInputField(
                controller: _difficultyController,
              ),
              BoxInputField(
                controller: _caloriesController,
              ),
              BoxInputField(
                controller: _imageController,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Handle the save action
                },
                child: Text(trans.save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
