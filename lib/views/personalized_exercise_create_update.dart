import 'package:YogiTech/custombar/bottombar.dart';
import 'package:YogiTech/models/exercise.dart';
import 'package:YogiTech/models/pose.dart';
import 'package:YogiTech/services/dioInstance.dart';
import 'package:YogiTech/services/exercise/exercise_service.dart';
import 'package:YogiTech/widgets/dropdown_field.dart';
import 'package:YogiTech/utils/formatting.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:YogiTech/custombar/appbar.dart';
import 'package:YogiTech/shared/styles.dart';
import 'package:YogiTech/shared/app_colors.dart';
import 'package:YogiTech/widgets/box_input_field.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

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
      for (var poseWithTime in _selectedPoses) {
        print('${poseWithTime.name}: ${poseWithTime.duration}');
      }
    }
    // _fetchPoses();
    _loadPoses();
  }

  Future<void> _loadPoses() async {
    final poses = await getPoses();
    _updatePoses(poses);
  }

  void _updatePoses(List<Pose> poses) {
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
    }); // In sau khi các tư thế đã được tải
  }

  Future<List<Pose>> _fetchPoses() {
    if (_poses.isNotEmpty) {
      return Future.value(_poses); // Trả về ngay lập tức nếu đã có dữ liệu
    } else {
      return getPoses(); // Lấy dữ liệu từ API nếu chưa có
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _difficultyController.dispose();
    _durationControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  // Future<List<Pose>> _fetchPoses() async {
  //   final poses = await getPoses();
  //   setState(() {
  //     final poseDurationMap = <int, int>{};
  //     for (var poseWithTime in widget.exercise?.poses ?? []) {
  //       poseDurationMap[poseWithTime.pose.id] = poseWithTime.duration;
  //     }
  //     _poses = poses.map((pose) {
  //       final duration = poseDurationMap[pose.id] ?? pose.duration;
  //       _durationControllers[pose.id] =
  //           TextEditingController(text: duration.toString());
  //       return pose;
  //     }).toList();
  //   });

  //   return poses; // Thêm câu lệnh return ở đây
  // }

  Future<void> _saveExercise() async {
    final trans = AppLocalizations.of(context)!;
    // Get information from input fields
    final title = _titleController.text;

    // Check if required fields are filled
    if (title.isEmpty || _selectedPoses.isEmpty || _selectedLevel == 999) {
      // Show error message or handle according to requirements
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: error,
            content: Text(trans.missingInfor,
                style: bd_text.copyWith(color: active))),
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

    if (widget.exercise != null) {
      final updatedExercise =
          await patchUpdatePersonalExercise(widget.exercise!.id, request);
      if (updatedExercise != null) {
        // Update successful
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: green,
            content: Text(trans.updateSuccess,
                style: bd_text.copyWith(color: active))));
        Navigator.pop(
            context, true); // Return to previous screen with updated exercise
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: error,
            content: Text(trans.updateFail,
                style: bd_text.copyWith(color: active))));
      }
    } else {
      // Create new exercise
      final exercise = await postPersonalExercise(request);
      if (exercise != null) {
        // Handle successful creation (e.g., navigate, show message)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: green,
            content: Text(trans.createSuccess,
                style: bd_text.copyWith(color: active))));
        Navigator.pop(context, true); // Or navigate to another page
      } else {
        // Handle creation failure
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: error,
            content: Text(trans.createFail,
                style: bd_text.copyWith(color: active))));
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
      body: FutureBuilder<List<Pose>>(
        future: _fetchPoses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: primary2,
            ));
          } else if (snapshot.hasError) {
            return Center(
                child: Text('${trans.error}: ${snapshot.error}',
                    style: bd_text.copyWith(color: text)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child:
                    Text(trans.noPose, style: bd_text.copyWith(color: text)));
          } else {
            _poses = snapshot.data!;
            return SingleChildScrollView(
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
                      items: [
                        trans.beginner,
                        trans.intermediate,
                        trans.advanced
                      ],
                      placeholder: trans.selectLevel,
                      onChanged: (value) {
                        setState(() {
                          print('Selected value: $value');
                          if (value != null &&
                              levelMapping.containsKey(value)) {
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
                    MultiSelectDialogField<Pose>(
                      checkColor: active,
                      searchTextStyle: TextStyle(
                        fontFamily: 'ReadexPro',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.onSurface,
                      ),
                      searchHint: trans.search,
                      searchHintStyle: TextStyle(
                        fontFamily: 'ReadexPro',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      cancelText: Text(
                        trans.cancel,
                        style: bd_text.copyWith(color: primary2),
                      ),
                      confirmText: Text(
                        trans.choose,
                        style: bd_text.copyWith(color: primary2),
                      ),
                      title: Text(trans.selectPoses,
                          style: h3.copyWith(
                            color: theme.colorScheme.onPrimary,
                          )),
                      buttonText: Text(
                        trans.selectPoses,
                        style: bd_text.copyWith(
                            color:
                                theme.colorScheme.onSurface.withOpacity(0.6)),
                      ),
                      chipDisplay: MultiSelectChipDisplay.none(),
                      separateSelectedItems: true,
                      searchable: true,
                      selectedColor: primary2,
                      selectedItemsTextStyle: TextStyle(
                        color: active,
                        fontFamily: 'ReadexPro',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      unselectedColor: stroke,
                      itemsTextStyle: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontFamily: 'ReadexPro',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      backgroundColor: theme.colorScheme.surface,
                      items: _poses.map((e) => PoseMultiSelectItem(e)).toList(),
                      listType: MultiSelectListType.CHIP,
                      initialValue: _selectedPoses,
                      onConfirm: (List<Pose> values) {
                        setState(() {
                          _selectedPoses = values;
                        });
                      },
                    ),
                    Column(
                      children: [
                        for (int i = 0; i < _selectedPoses.length; i++)
                          buildPoseWidget(_selectedPoses[i])
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: CustomBottomBar(
        buttonTitle:
            widget.exercise == null ? trans.create : trans.updateExercise,
        onPressed: () {
          _saveExercise();
        },
      ),
    );
  }

  buildPoseWidget(Pose pose) {
    final trans = AppLocalizations.of(context)!;
    final durationController = _durationControllers[pose.id]!;
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Image.network(
            pose.image_url,
            fit: BoxFit.cover,
            width: 80,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pose.name,
                    style: bd_text.copyWith(color: primary2, height: 1.2),
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
                    style: min_cap.copyWith(color: primary2),
                  ),
                  SizedBox(height: 4),
                  BoxInputField(
                    isSmall: true,
                    controller: durationController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final newDuration = int.tryParse(value) ?? 0;
                      pose.duration = newDuration;
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PoseMultiSelectItem extends MultiSelectItem<Pose> {
  PoseMultiSelectItem(Pose pose) : super(pose, pose.name);

  Widget build(BuildContext context, bool isSelected, VoidCallback onTap) {
    final trans = AppLocalizations.of(context)!;
    return ListTile(
      // Sử dụng ListTile để hiển thị thông tin
      leading: Image.network(value.image_url,
          width: 40, height: 40, fit: BoxFit.cover),
      title: Text(value.name),
      subtitle:
          Text('${trans.calorie}: ${value.calories}'), // Hiển thị calories
      trailing: isSelected ? Icon(Icons.check) : null,
      onTap: onTap,
    );
  }
}
