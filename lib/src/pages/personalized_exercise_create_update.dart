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

  final Map<int, int> poseDurations = {}; // Khởi tạo map rỗng

  Future<void> _createExercise() async {
    final title = _titleController.text;
    final level = levelMap.entries
        .firstWhere((entry) => entry.value == _difficultyController.text)
        .key;

    final exerciseData = {
      "title": title,
      "image": "", // You might want to handle image uploads separately
      "level": level,
      "pose": _selectedPoses.map((p) => p.id).toList(),
      "time": _selectedPoses
          .map((p) => poseDurations[p.id] ?? 0)
          .toList(), // Lấy duration từ map
      "benefit": _benefitsController.text,
      "description":
          "", // You might want to handle description input separately
      "calories": _caloriesController.text,
      "number_poses": _selectedPoses.length,
      "point": 0,
      "is_premium": false, // Adjust as needed
      "active_status": 1, // Adjust as needed
      "video": "", // You might want to handle video uploads separately
      "durations": _selectedPoses.fold<int>(
          0, (sum, p) => sum + (poseDurations[p.id] ?? 0)),
      "duration": null, // or you can remove this line
    };

    try {
      final response =
          await DioInstance.post('/api/v1/exercises/', data: exerciseData);
      if (response.statusCode == 201) {
        // 201 Created for successful creation
        // Exercise created successfully
        // You might want to navigate to a different screen or show a success message
      } else {
        // Handle errors
      }
    } catch (e) {
      // Handle network or API errors
    }
  }

  List<Pose> _poses = [];
  List<Pose> _selectedPoses = [];
  final Map<int, String> levelMap = {
    1: 'Beginner',
    2: 'Intermediate',
    3: 'Advanced',
  };

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

    super.dispose();
  }

  Future<void> _fetchPoses() async {
    final poses = await getPoses();
    setState(() {
      _poses = poses;
    });
  }

  void _onPoseSelected(Pose pose) {
    setState(() {
      final existingPoseIndex =
          _selectedPoses.indexWhere((p) => p.id == pose.id);
      if (existingPoseIndex != -1) {
        _selectedPoses.removeAt(existingPoseIndex);
        poseDurations.remove(pose.id); // Xóa duration khỏi map khi bỏ chọn
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
                    final durationController = TextEditingController(
                      text: pose.duration.toString() ??
                          '0', // Lấy duration từ map nếu có, không thì là 0
                    );
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
                                : null,
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
                                  onChanged: (value) => {
                                    setState(() {
                                      poseDurations[pose.id] =
                                          int.tryParse(value) ??
                                              0; // Cập nhật duration trong map
                                    }),
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
    final List<String> levelItems = levelMap.values.toList();

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
                items: levelItems,
                placeholder: _difficultyController.text.isEmpty
                    ? trans.selectLevel
                    : _difficultyController.text,
                onTap: () {
                  // Optional: handle dropdown tap
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
                          padding: EdgeInsets.all(4),
                          side: BorderSide(width: 0),
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
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        buttonTitle: trans.create,
        onPressed: _createExercise, // Gắn hàm _createExercise
      ),
    );
  }
}
