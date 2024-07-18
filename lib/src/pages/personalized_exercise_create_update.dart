import 'package:YogiTech/api/dioInstance.dart';
import 'package:YogiTech/src/custombar/bottombar.dart';
import 'package:YogiTech/src/models/pose.dart';
import 'package:YogiTech/src/widgets/box_button.dart';
import 'package:YogiTech/src/widgets/dropdown_field.dart';
import 'package:YogiTech/utils/formatting.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:YogiTech/src/custombar/appbar.dart';
import 'package:YogiTech/src/shared/styles.dart';
import 'package:YogiTech/src/shared/app_colors.dart';
import 'package:YogiTech/src/widgets/box_input_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<List<Pose>> getPoses() async {
  try {
    final url = formatApiUrl('/api/v1/poses/');
    final Response response = await DioInstance.get(url);
    if (response.statusCode == 200) {
      List<Pose> data =
          (response.data as List).map((e) => Pose.fromMap(e)).toList();
      return data;
    } else {
      print('Get poses failed with status code: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Get poses error: $e');
    return [];
  }
}

class PersonalizedExerciseCreatePage extends StatefulWidget {
  const PersonalizedExerciseCreatePage({super.key});

  @override
  _PersonalizedExerciseCreatePageState createState() =>
      _PersonalizedExerciseCreatePageState();
}

class _PersonalizedExerciseCreatePageState
    extends State<PersonalizedExerciseCreatePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _difficultyController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _benefitsController = TextEditingController();
  final TextEditingController _pointController = TextEditingController();

  List<Pose> _poses = [];
  List<Pose> _selectedPoses = [];
  Map<int, TextEditingController> _durationControllers = {};
  int _selectedLevel = 999; // Default to beginner

  @override
  void initState() {
    super.initState();
    _fetchPoses();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _difficultyController.dispose();
    _caloriesController.dispose();
    _benefitsController.dispose();
    _pointController.dispose();
    _durationControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _fetchPoses() async {
    final poses = await getPoses();
    setState(() {
      _poses = poses;
      // Initialize TextEditingController for each pose
      _poses.forEach((pose) {
        _durationControllers[pose.id] =
            TextEditingController(text: pose.duration.toString());
      });
    });
  }

  void _onPoseSelected(Pose pose) {
    setState(() {
      if (_selectedPoses.contains(pose)) {
        _selectedPoses.remove(pose);
      } else {
        _selectedPoses.add(pose);
      }
    });
  }

  void _showPoseSelectionDialog() {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            trans.selectPoses,
            style: h3.copyWith(color: theme.colorScheme.onPrimary),
          ),
          elevation: appElevation,
          backgroundColor: theme.colorScheme.onSecondary,
          content: SizedBox(
            width: double.maxFinite,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return GridView.builder(
                  shrinkWrap: true,
                  itemCount: _poses.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 5,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    final pose = _poses[index];
                    final isSelected = _selectedPoses.contains(pose);
                    final durationController = _durationControllers[pose.id]!;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _onPoseSelected(pose);
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected ? primary : Colors.transparent,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: GridTile(
                          header: GridTileBar(
                            title: Text(
                              '${pose.level}',
                              style: min_cap.copyWith(color: primary),
                            ),
                            trailing: isSelected
                                ? Icon(Icons.check, color: primary)
                                : null, // Added checkmark icon
                          ),
                          footer: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 8, left: 8, right: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${trans.duration} (${trans.seconds})',
                                  style: min_cap.copyWith(color: primary),
                                ),
                                SizedBox(height: 8),
                                BoxInputField(
                                  isSmall: true,
                                  controller: durationController,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      pose.duration = int.tryParse(value) ?? 0;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  child: Image.network(
                                    pose.image_url,
                                    fit: BoxFit.cover,
                                    height: 80,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  pose.name,
                                  style: bd_text.copyWith(
                                      color: primary, height: 1.2),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  '${pose.calories} ${trans.calorie}',
                                  style: min_cap.copyWith(color: text),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            CustomButton(
              title: trans.choose,
              style: ButtonStyleType.Primary,
              onPressed: () {
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    final Map<String, int> levelMapping = {
      trans.beginner: 1,
      trans.intermediate: 2,
      trans.advanced: 3,
    };
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        title: trans.createExercise,
        style: widthStyle.Large,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                trans.title,
                style: h3.copyWith(color: theme.colorScheme.onPrimary),
              ),
              const SizedBox(height: 12),
              BoxInputField(
                controller: _titleController,
              ),
              const SizedBox(height: 12),
              Text(
                trans.level,
                style: h3.copyWith(color: theme.colorScheme.onPrimary),
              ),
              const SizedBox(height: 12),
              CustomDropdownFormField(
                controller: _difficultyController,
                items: [trans.beginner, trans.intermediate, trans.advanced],
                placeholder: trans.selectLevel,
                onChanged: (value) {
                  setState(() {
                    print('Giá trị là ${value}');
                    if (value != null && levelMapping.containsKey(value)) {
                      _selectedLevel = levelMapping[value]!;
                    }
                  });
                },
              ),
              const SizedBox(height: 12),
              Text(
                trans.poses,
                style: h3.copyWith(color: theme.colorScheme.onPrimary),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 4.0,
                runSpacing: 2.0,
                children: _selectedPoses
                    .map((pose) => Chip(
                          backgroundColor: primary,
                          deleteIconColor: active,
                          padding: EdgeInsets.all(4),
                          side: BorderSide(width: 0, color: primary),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24))),
                          label: Text(
                            '${pose.name} (${pose.duration} ${trans.seconds})',
                            style: bd_text.copyWith(color: active),
                          ),
                          onDeleted: () {
                            setState(() {
                              _selectedPoses.remove(pose);
                            });
                          },
                        ))
                    .toList(),
              ),
              const SizedBox(height: 12),
              CustomButton(
                title: trans.selectPoses,
                style: ButtonStyleType.Tertiary,
                onPressed: _showPoseSelectionDialog,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        buttonTitle: trans.create,
        onPressed: () {
          print('Selected Level: $_selectedLevel');
          // Handle create exercise logic here
        },
      ),
    );
  }
}
