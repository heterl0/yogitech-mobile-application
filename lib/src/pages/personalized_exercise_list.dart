import 'package:YogiTech/api/exercise/exercise_service.dart';
import 'package:YogiTech/src/models/exercise.dart';
import 'package:YogiTech/src/pages/personalized_exercise_create_update.dart';
import 'package:flutter/material.dart';
import 'package:YogiTech/src/custombar/appbar.dart';
import 'package:YogiTech/src/shared/styles.dart';
import 'package:YogiTech/src/shared/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class PersonalizedExercisePage extends StatefulWidget {
  const PersonalizedExercisePage({super.key});

  @override
  _PersonalizedExercisePageState createState() =>
      _PersonalizedExercisePageState();
}

class _PersonalizedExercisePageState extends State<PersonalizedExercisePage> {
  late Future<dynamic> _exercises;

  @override
  void initState() {
    super.initState();
    _exercises = getPersonalExercise();
    _printExercises(); // Gọi hàm để in exercises
  }

  // Hàm async để in giá trị exercises
  Future<void> _printExercises() async {
    try {
      List<Exercise> exercises = await _exercises; // Đợi kết quả từ Future
      print('Exercises: $exercises'); // In ra danh sách exercises
    } catch (e) {
      print('Error: $e');
    }
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
          padding: EdgeInsets.only(bottom: 52),
          child: FutureBuilder<dynamic>(
            future: _exercises,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child: Text(
                  trans.errorLoadingExercises,
                  style: bd_text.copyWith(color: text),
                ));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                    child: Text(trans.noExercisesFound,
                        style: bd_text.copyWith(color: text)));
              } else {
                final exercises = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = exercises[index];
                    return _buildExerciseItem(exercise);
                  },
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildExerciseItem(Exercise exercise) {
    final trans = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Card(
      elevation: appElevation,
      child: ListTile(
        contentPadding: EdgeInsets.only(right: 0, left: 16),
        title: Text(
          exercise.title,
          style: h3.copyWith(color: theme.colorScheme.onPrimary, height: 1.2),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Text(
                  '${trans.level}: ',
                  style: bd_text.copyWith(color: text),
                ),
                Text(
                  exercise.level == 1
                      ? trans.beginner
                      : (exercise.level == 2
                          ? trans.intermediate
                          : trans.advanced),
                  style: bd_text.copyWith(color: primary),
                ),
              ],
            ),
            Row(
              children: [
                Text('${trans.duration}: ',
                    style: bd_text.copyWith(color: text)),
                Text('${exercise.durations} ${trans.seconds}',
                    style: bd_text.copyWith(color: primary)),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.edit,
            color: text,
          ),
          onPressed: () {
            pushWithoutNavBar(
              context,
              MaterialPageRoute(
                builder: (context) => PersonalizedExerciseCreatePage(
                  exercise: exercise,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Ink(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: gradient,
        ),
        width: 60,
        height: 60,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () {
            pushWithoutNavBar(
              context,
              MaterialPageRoute(
                builder: (context) => PersonalizedExerciseCreatePage(),
              ),
            );
          },
          child: const Icon(
            Icons.add,
            color: active,
            size: 24,
          ),
        ),
      ),
      onPressed: () {},
    );
  }
}
