import 'package:YogiTech/src/pages/personalized_exercise_create_update.dart';
import 'package:flutter/material.dart';
import 'package:YogiTech/src/custombar/appbar.dart';
import 'package:YogiTech/src/shared/styles.dart';
import 'package:YogiTech/src/shared/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

// Mock data for poses
final List<Exercise> mockPoses = [
  Exercise(name: 'Exercise 1', level: 'Beginner', duration: '10 min'),
  Exercise(name: 'Exercise 2', level: 'Intermediate', duration: '20 min'),
  Exercise(name: 'Exercise 3', level: 'Advanced', duration: '30 min'),
];

class PersonalizedExercisePage extends StatefulWidget {
  const PersonalizedExercisePage({super.key});

  @override
  _PersonalizedExercisePageState createState() =>
      _PersonalizedExercisePageState();
}

class _PersonalizedExercisePageState extends State<PersonalizedExercisePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Exercise> _poses = mockPoses;
  List<Exercise> _filteredPoses = mockPoses;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterPoses);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterPoses() {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      setState(() {
        _filteredPoses = _poses
            .where(
                (pose) => pose.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        _filteredPoses = _poses;
      });
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
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _filteredPoses.length,
                itemBuilder: (context, index) {
                  final pose = _filteredPoses[index];
                  return ListItem(
                    level: pose.level,
                    title: pose.name,
                    duration: pose.duration,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
            // Chỗ này mới có tác dụng
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

class ListItem extends StatelessWidget {
  final String? level;
  final String? title;
  final String? duration;

  const ListItem({
    super.key,
    this.level,
    this.title,
    this.duration,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      constraints: BoxConstraints(
        minWidth: double.infinity,
        minHeight: 80,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: stroke),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(level ?? 'N/A', style: min_cap.copyWith(color: primary)),
                SizedBox(width: 8),
                Text(title ?? 'N/A',
                    style: h3.copyWith(color: theme.colorScheme.onPrimary)),
                Text('Duration: ${duration ?? 'N/A'}',
                    style: min_cap.copyWith(color: text)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Exercise {
  final String name;
  final String level;
  final String duration;

  Exercise({required this.name, required this.level, required this.duration});
}
