import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:yogi_application/api/auth/auth_service.dart';
import 'package:yogi_application/api/exercise/exercise_service.dart';
import 'package:yogi_application/src/custombar/appbar.dart';
import 'package:yogi_application/src/models/account.dart';
import 'package:yogi_application/src/models/exercise.dart';
import 'package:yogi_application/src/pages/exercise_detail.dart';
import 'package:yogi_application/src/pages/filter.dart';
import 'package:yogi_application/src/widgets/box_input_field.dart';
import 'package:yogi_application/src/widgets/card.dart';

class AllExercise extends StatefulWidget {
  const AllExercise({Key? key}) : super(key: key);
  @override
  State<AllExercise> createState() => _AllExercies();
}

var jsonList;

class _AllExercies extends State<AllExercise> {
  List<dynamic> jsonList = [];

  @override
  void initState() {
    super.initState();
    _fetchExercises();
  }

  Future<void> _fetchExercises([String query = '']) async {
    final List<dynamic> exercises = await getExercises();
    setState(() {
      if (query.isNotEmpty) {
        jsonList = exercises
            .where((exercise) => exercise.containsQuery(query))
            .toList();
        print(exercises);
      } else {
        jsonList = exercises;
      }
    });
  }

  TextEditingController _searchController = TextEditingController();
  Account? account;
  bool isSearching = true;
  @override
  Widget build(BuildContext context) {
    final trans = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        showBackButton: false,
        preActions: [
          IconButton(
            icon: Icon(Icons.tune_outlined,
                color: theme.colorScheme.onBackground),
            onPressed: () {
              pushWithoutNavBar(
                context,
                MaterialPageRoute(
                  builder: (context) => FilterPage(),
                ),
              );
            },
          ),
        ],
        style: widthStyle.Large,
        titleWidget: BoxInputField(
          controller: _searchController,
          placeholder: trans.search,
          trailing: Icon(Icons.search),
          keyboardType: TextInputType.text,
          inputFormatters: [],
          onTap: () {
            // Xử lý khi input field được nhấn
          },
        ),
        postActions: [
          IconButton(
            icon: Icon(Icons.close, color: theme.colorScheme.onBackground),
            onPressed: () {
              setState(() {
                isSearching = false;
                FocusScope.of(context).unfocus();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(color: theme.colorScheme.background),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildExMainContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildExMainContent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 24.0, left: 24.0, right: 24.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 4 / 5,
        ),
        itemCount: jsonList.length,
        itemBuilder: (context, index) {
          final exercise = jsonList[index];
          return CustomCard(
            title: exercise.title,
            caption: exercise.description,
            imageUrl: exercise.image_url,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExerciseDetail(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
