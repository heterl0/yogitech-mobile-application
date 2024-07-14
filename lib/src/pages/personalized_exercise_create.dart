import 'package:YogiTech/api/dioInstance.dart';
import 'package:YogiTech/src/custombar/bottombar.dart';
import 'package:YogiTech/src/models/pose.dart';
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
      if (_selectedPoses.contains(pose)) {
        _selectedPoses.remove(pose);
      } else {
        _selectedPoses.add(pose);
      }
    });
  }

  void _showPoseSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.selectPoses),
          content: SizedBox(
            width: double.maxFinite,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return GridView.builder(
                  shrinkWrap: true,
                  // physics: NeverScrollableScrollPhysics(),
                  itemCount: _poses.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 6,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    final pose = _poses[index];
                    final isSelected = _selectedPoses.contains(pose);
                    final TextEditingController _durationController =
                        TextEditingController();

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
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: GridTile(
                          header: GridTileBar(
                            title: Text(pose.name),
                            subtitle: Text(pose.level.toString()),
                            trailing: isSelected
                                ? Icon(Icons.check, color: primary)
                                : null, // Added checkmark icon
                          ),
                          footer: GridTileBar(
                            title: Text('${pose.calories} calories'),
                            backgroundColor: primary,
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                child: Image.network(
                                  pose.image_url,
                                  fit: BoxFit.cover,
                                  height: 100,
                                ),
                              ),
                              TextField(
                                controller: _durationController,
                                decoration: InputDecoration(
                                  labelText:
                                      AppLocalizations.of(context)!.duration,
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  pose.duration = int.tryParse(value) ?? 0;
                                },
                              ),
                            ],
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
            TextButton(
              child: Text(AppLocalizations.of(context)!.choose),
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
                items: ['Dễ', 'Thường', 'Khó'],
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
              ElevatedButton(
                onPressed: _showPoseSelectionDialog,
                child: Text(trans.selectPoses),
              ),
              const SizedBox(height: 12),
              Text(
                trans.benefits,
                style: h3.copyWith(color: theme.colorScheme.onPrimary),
              ),
              const SizedBox(height: 12),
              BoxInputField(
                controller: _benefitsController,
              ),
              const SizedBox(height: 12),
              Text(
                trans.point,
                style: h3.copyWith(color: theme.colorScheme.onPrimary),
              ),
              const SizedBox(height: 12),
              BoxInputField(
                controller: _pointController,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        buttonTitle: trans.create,
        onPressed: () {},
      ),
    );
  }
}
