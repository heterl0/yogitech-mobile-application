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
      for (var pose in _poses) {
        _durationControllers[pose.id] =
            TextEditingController(text: pose.duration.toString());
      }
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
      barrierDismissible: false, // Ngăn người dùng tắt hộp thoại khi đang tải
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
              child: CircularProgressIndicator(), // Hiển thị vòng tròn loading
            ),
          ),
        );
      },
    );

    if (_poses.isEmpty) {
      await _fetchPoses(); // Đợi tải dữ liệu xong
    }

// Sắp xếp lại danh sách _poses
    _poses.sort((a, b) {
      if (_selectedPoses.contains(a) && !_selectedPoses.contains(b)) {
        return -1; // Đưa pose đã chọn lên trước
      } else if (!_selectedPoses.contains(a) && _selectedPoses.contains(b)) {
        return 1; // Đưa pose chưa chọn xuống sau
      } else {
        return 0; // Giữ nguyên thứ tự nếu cả hai đều đã chọn hoặc chưa chọn
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
                    final durationController = _durationControllers[pose.id]!;
                    final poseNumber =
                        _selectedPoses.indexOf(pose) + 1; // Tính số thứ tự

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _onPoseSelected(pose);
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            bottom: 8), // Khoảng cách giữa các hàng
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

                              width: 80, // Đặt chiều rộng cố định cho hình ảnh
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
                            if (isSelected) // Chỉ hiển thị cho các tư thế đã chọn
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: primary, // Màu nền nổi bật
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
