import 'package:YogiTech/api/auth/auth_service.dart';
import 'package:YogiTech/api/exercise/exercise_service.dart';
import 'package:YogiTech/src/models/account.dart';
import 'package:YogiTech/src/models/exercise.dart';
import 'package:YogiTech/src/pages/exercise_detail.dart';
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
  late Future<List<Exercise>> _exerciseFuture;
  late Account account;

  @override
  void initState() {
    super.initState();
    _exerciseFuture = _fetchExercises();
    getAccount();
  }

  Future<List<Exercise>> _fetchExercises() async {
    try {
      final exercises = await getPersonalExercise();
      return exercises;
    } catch (e) {
      print('Error fetching exercises: $e');
      return [];
    }
  }

  Future<void> getAccount() async {
    final Account? _account = await retrieveAccount();
    setState(() {
      account = _account!;
    });
  }

  Future<void> _refreshExercises() async {
    setState(() {
      _exerciseFuture = _fetchExercises();
    });
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
      body: FutureBuilder<List<Exercise>>(
        future: _exerciseFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: primary2,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text(trans.errorLoadingExercises));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(trans.noExercisesFound));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(24.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final exercise = snapshot.data![index];
                return _buildExerciseItem(exercise);
              },
            );
          }
        },
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildExerciseItem(Exercise exercise) {
    final trans = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Card(
      elevation: appElevation,
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        onTap: () {
          pushWithoutNavBar(
            context,
            MaterialPageRoute(
              builder: (context) => ExerciseDetail(
                exercise: exercise,
                account: account,
              ),
            ),
          );
        },
        child: ListTile(
          contentPadding: EdgeInsets.only(right: 0, left: 16),
          title: Text(
            exercise.title,
            style: h3.copyWith(color: theme.colorScheme.onPrimary, height: 1.2),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Row(
                children: [
                  Text('${trans.level}: ',
                      style: bd_text.copyWith(color: text)),
                  Text(
                    exercise.level == 1
                        ? trans.beginner
                        : (exercise.level == 2
                            ? trans.intermediate
                            : trans.advanced),
                    style: bd_text.copyWith(color: primary2),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('${trans.duration}: ',
                      style: bd_text.copyWith(color: text)),
                  Text('${exercise.durations} ${trans.seconds}',
                      style: bd_text.copyWith(color: primary2)),
                ],
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit_outlined, color: text),
                onPressed: () async {
                  final result = await pushWithoutNavBar(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PersonalizedExerciseCreatePage(
                        exercise: exercise,
                      ),
                    ),
                  );
                  if (result == true) {
                    _refreshExercises();
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, color: text),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      elevation: appElevation,
                      backgroundColor: theme.colorScheme.onSecondary,
                      title: Text(
                        trans.deleteExercise,
                        style: h3.copyWith(color: theme.colorScheme.onPrimary),
                      ),
                      content: Text(
                        trans.areYouSureDeleteExercise,
                        style: bd_text.copyWith(
                            color: theme.colorScheme.onPrimary),
                      ),
                      actions: [
                        TextButton(
                          child: Text(trans.cancel, style: bd_text),
                          onPressed: () => Navigator.pop(context),
                        ),
                        TextButton(
                          child: Text(trans.delete, style: bd_text),
                          onPressed: () async {
                            Navigator.pop(context);
                            final result =
                                await patchDisablePersonalExercise(exercise.id);
                            if (result != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    backgroundColor: green,
                                    content: Text(trans.deleteSuccessfully,
                                        style:
                                            bd_text.copyWith(color: active))),
                              );
                              _refreshExercises();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    backgroundColor: error,
                                    content: Text(trans.deleteFailed,
                                        style:
                                            bd_text.copyWith(color: active))),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Ink(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: gradient2,
        ),
        width: 60,
        height: 60,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () async {
            final result = await pushWithoutNavBar(
              context,
              MaterialPageRoute(
                builder: (context) => PersonalizedExerciseCreatePage(),
              ),
            );
            if (result == true) {
              _refreshExercises();
            }
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
