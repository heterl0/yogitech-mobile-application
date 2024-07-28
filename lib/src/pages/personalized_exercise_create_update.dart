import 'package:YogiTech/api/dioInstance.dart';
import 'package:YogiTech/api/exercise/exercise_service.dart';
import 'package:YogiTech/src/custombar/bottombar.dart';
import 'package:YogiTech/src/models/exercise.dart';
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
  final Exercise? exercise;
  const PersonalizedExerciseCreatePage({super.key, this.exercise});

  @override
  _PersonalizedExerciseCreatePageState createState() =>
      _PersonalizedExerciseCreatePageState();
}

class _PersonalizedExerciseCreatePageState
    extends State<PersonalizedExerciseCreatePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _difficultyController = TextEditingController();

  List<Pose> _poses = [];
  List<Pose> _selectedPoses = [];
  final Map<int, TextEditingController> _durationControllers = {};
  int _selectedLevel = 999; // Default to beginner
  late Future<void> _posesFuture;

  @override
  void initState() {
    super.initState();
    if (widget.exercise != null) {
      _titleController.text = widget.exercise!.title;
      _selectedLevel = widget.exercise!.level;

      _selectedPoses = widget.exercise!.poses
          .map((poseWithTime) => poseWithTime.pose)
          .toList();

      print('Durations for selected poses:');
      for (var poseWithTime in widget.exercise!.poses) {
        print('${poseWithTime.pose.name}: ${poseWithTime.duration}');
      }
    }
    _posesFuture = _fetchPoses();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _difficultyController.dispose();
    _durationControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _fetchPoses() async {
    final poses = await getPoses();
    setState(() {
      final poseDurationMap = <int, int>{};
      for (var poseWithTime in widget.exercise?.poses ?? []) {
        poseDurationMap[poseWithTime.pose.id] = poseWithTime.duration;
      }
      _poses = poses.map((pose) {
        final duration = poseDurationMap[pose.id] ?? pose.duration;
        _durationControllers[pose.id] =
            TextEditingController(text: duration.toString());
        return pose;
      }).toList();
    });
  }

  void _onPoseSelected(Pose pose) {
    setState(() {
      print('_onPoseSelected được gọi');
      if (_selectedPoses.contains(pose)) {
        _selectedPoses.remove(pose);
        _durationControllers.remove(pose.id);
      } else {
        _selectedPoses.add(pose);
        if (!_durationControllers.containsKey(pose.id)) {
          _durationControllers[pose.id] =
              TextEditingController(text: pose.duration.toString());
        }
      }
    });
  }

  Future<void> _showPoseSelectionDialog() async {
    final trans = AppLocalizations.of(context)!;
    final Map<int, String> levelMapping = {
      1: trans.beginner,
      2: trans.intermediate,
      3: trans.advanced,
    };
    final theme = Theme.of(context);
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent users from dismissing the dialog
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
            child: Center(
              child: CircularProgressIndicator(), // Loading indicator
            ),
          ),
        );
      },
    );

    if (_poses.isEmpty) {
      await _fetchPoses(); // Wait for data to load
    }

    // Sort poses so that selected poses appear first
    _poses.sort((a, b) {
      if (_selectedPoses.contains(a) && !_selectedPoses.contains(b)) {
        return -1; // Selected poses come first
      } else if (!_selectedPoses.contains(a) && _selectedPoses.contains(b)) {
        return 1; // Unselected poses come after
      } else {
        return 0; // Maintain order if both are selected or unselected
      }
    });

    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(16),
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
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: _poses.length,
                  itemBuilder: (context, index) {
                    final pose = _poses[index];
                    final isSelected = _selectedPoses.contains(pose);
                    print(
                        'Các pose còn nằm trong _selectedPoses: ${_selectedPoses}');
                    final durationController = _durationControllers[pose.id]!;
                    final poseNumber =
                        _selectedPoses.indexOf(pose) + 1; // Get pose number

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _onPoseSelected(pose);
                        });
                      },
                      child: Container(
                        margin:
                            EdgeInsets.only(bottom: 8), // Margin between rows
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected ? primary : Colors.transparent,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Row(
                          children: [
                            Image.network(
                              pose.image_url,
                              fit: BoxFit.cover,
                              width: 80, // Fixed width for image
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      pose.name,
                                      style: bd_text.copyWith(
                                          color: primary, height: 1.2),
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '${pose.calories} ${trans.calorie}',
                                      style: min_cap.copyWith(color: text),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '${trans.duration} (${trans.seconds})',
                                      style: min_cap.copyWith(color: primary),
                                    ),
                                    SizedBox(height: 4),
                                    BoxInputField(
                                      isSmall: true,
                                      controller: durationController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        setState(() {
                                          pose.duration =
                                              int.tryParse(value) ?? 0;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (isSelected) // Show only for selected poses
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: primary, // Highlight background color
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '$poseNumber',
                                  style: min_cap.copyWith(color: active),
                                ),
                              ),
                          ],
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

  Future<void> _saveExercise() async {
    final trans = AppLocalizations.of(context)!;
    // Get information from input fields
    final title = _titleController.text;

    // Check if required fields are filled
    if (title.isEmpty || _selectedPoses.isEmpty || _selectedLevel == 999) {
      // Show error message or handle according to requirements
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('trans.missingInformation')),
      );
      return; // Exit function if information is missing
    }

    // Get durations from controllers
    final durations = _selectedPoses
        .map((pose) => int.tryParse(_durationControllers[pose.id]!.text) ?? 0)
        .toList();

    print('Durations: ${durations}');

    // Create PostPersonalExerciseRequest object
    final request = PostPersonalExerciseRequest(
      title: title,
      level: _selectedLevel,
      poses: _selectedPoses,
      duration: durations,
    );

    // In ra các duration của pose
    print('Durations being sent in the request:');
    for (var i = 0; i < request.poses.length; i++) {
      print(
          '${request.poses[i].name}: ${request.duration[i]}'); // Lấy duration từ request
    }

    if (widget.exercise != null) {
      final updatedExercise =
          await patchUpdatePersonalExercise(widget.exercise!.id, request);
      if (updatedExercise != null) {
        // Update successful
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(trans.updateSuccess)));
        Navigator.pop(
            context, true); // Return to previous screen with updated exercise
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(trans.updateFail)));
      }
    } else {
      // Create new exercise
      final exercise = await postPersonalExercise(request);
      if (exercise != null) {
        // Handle successful creation (e.g., navigate, show message)
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('trans.createExerciseSuccessfully')));
        Navigator.pop(context, true); // Or navigate to another page
      } else {
        // Handle creation failure
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('trans.createExerciseFailed')));
      }
    }
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
    final Map<int, String> reverseLevelMapping = {
      1: trans.beginner,
      2: trans.intermediate,
      3: trans.advanced,
    };

    _difficultyController.text = reverseLevelMapping[_selectedLevel] ?? '';
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        title: widget.exercise == null
            ? trans.createExercise
            : trans.updateExercise,
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
                    print('Selected value: $value');
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
              FutureBuilder<void>(
                future: _posesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error loading poses');
                  } else {
                    return Wrap(
                      spacing: 12.0,
                      runSpacing: 0,
                      children: _selectedPoses.asMap().entries.map((entry) {
                        final pose = entry.value;
                        final durationController =
                            _durationControllers[pose.id]!;

                        return Chip(
                          backgroundColor: primary,
                          deleteIconColor: active,
                          padding: EdgeInsets.all(4),
                          side: BorderSide(width: 0, color: primary),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24))),
                          label: Text(
                            '${pose.name} (${durationController.text} ${trans.seconds})',
                            style: bd_text.copyWith(color: active),
                          ),
                          onDeleted: () {
                            setState(() {
                              _selectedPoses.remove(pose);
                            });
                          },
                        );
                      }).toList(),
                    );
                  }
                },
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
        buttonTitle:
            widget.exercise == null ? trans.create : trans.updateExercise,
        onPressed: () {
          print('Selected poses on update: ${_selectedPoses}');
          _saveExercise();
        },
      ),
    );
  }
}
