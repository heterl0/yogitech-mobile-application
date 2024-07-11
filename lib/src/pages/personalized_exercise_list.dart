import 'package:YogiTech/src/pages/personalized_exercise_create.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:YogiTech/api/dioInstance.dart';
import 'package:YogiTech/src/models/pose.dart';
import 'package:YogiTech/utils/formatting.dart';
import 'package:YogiTech/src/custombar/appbar.dart';
import 'package:YogiTech/src/shared/styles.dart';
import 'package:YogiTech/src/shared/app_colors.dart';
import 'package:YogiTech/src/widgets/box_input_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

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

class PersonalizedExercisePage extends StatefulWidget {
  const PersonalizedExercisePage({super.key});

  @override
  _PersonalizedExercisePageState createState() =>
      _PersonalizedExercisePageState();
}

class _PersonalizedExercisePageState extends State<PersonalizedExercisePage> {
  // bool _isNotSearching = true;
  final TextEditingController _searchController = TextEditingController();
  List<Pose> _poses = [];
  List<Pose> _filteredPoses = [];

  @override
  void initState() {
    super.initState();
    _fetchPoses();
    _searchController.addListener(_filterPoses);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchPoses() async {
    final poses = await getPoses();
    setState(() {
      _poses = poses;
      _filteredPoses = poses;
    });
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
        _filteredPoses = [];
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
              // Danh sách đầu tiên
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _filteredPoses.length,
                    itemBuilder: (context, index) {
                      final pose = _filteredPoses[index];
                      return ListItem(
                        image: pose.image_url,
                        difficulty: pose.level.toString(),
                        poseName: pose.name,
                        calories: pose.calories.toString(),
                      );
                    },
                  ),
                ],
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
  final String? image;
  final String? difficulty;
  final String? poseName;
  final String? calories;

  const ListItem({
    super.key,
    this.image,
    this.difficulty,
    this.poseName,
    this.calories,
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
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: stroke,
              image: image != null
                  ? DecorationImage(
                      image: NetworkImage(image!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: image == null
                ? Icon(
                    Icons.image,
                    color: Colors.white,
                    size: 30,
                  )
                : null,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(difficulty ?? 'N/A',
                    style: min_cap.copyWith(color: primary)),
                SizedBox(width: 8),
                Text(poseName ?? 'N/A',
                    style: h3.copyWith(color: theme.colorScheme.onPrimary)),
                Text('Calories: ${calories ?? 'N/A'}',
                    style: min_cap.copyWith(color: text)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
