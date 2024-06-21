import 'package:flutter/material.dart';
import 'package:yogi_application/api/exercise/exercise_service.dart';
import 'package:yogi_application/src/custombar/appbar.dart';
import 'package:yogi_application/src/pages/exercise_detail.dart';
import 'package:yogi_application/src/widgets/box_input_field.dart';
import 'package:yogi_application/src/widgets/card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AllExercise extends StatefulWidget {
  const AllExercise({Key? key}) : super(key: key);

  @override
  BlogState createState() => BlogState();
}

class BlogState extends State<AllExercise> {
  List<dynamic> jsonList = [];
  bool _isNotSearching = true;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchExercise(); // Gọi hàm fetchBlogs khi trạng thái của widget được khởi tạo
  }

  Future<void> _fetchExercise([String query = '']) async {
    final List<dynamic> exercises = await getExercises();
    setState(() {
      if (query.isNotEmpty) {
        jsonList = exercises
            .where((exercise) => exercise.containsQuery(query))
            .toList();
      } else {
        jsonList = exercises;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: _isNotSearching
          ? CustomAppBar(
              showBackButton: true,
              title: trans.exercise,
              postActions: [
                IconButton(
                  icon:
                      Icon(Icons.search, color: theme.colorScheme.onBackground),
                  onPressed: () {
                    setState(() {
                      _isNotSearching = false;
                    });
                  },
                ),
              ],
            )
          : CustomAppBar(
              showBackButton: false,
              onBackPressed: () {
                setState(() {
                  _isNotSearching = true;
                });
              },
              style: widthStyle.Large,
              titleWidget: BoxInputField(
                controller: _searchController,
                placeholder: trans.search,
                trailing:
                    Icon(Icons.search, color: theme.colorScheme.onBackground),
                keyboardType: TextInputType.text,
                inputFormatters: [],
                onChanged: (value) {
                  _fetchExercise(value);
                },
                onTap: () {},
              ),
              postActions: [
                IconButton(
                  icon:
                      Icon(Icons.close, color: theme.colorScheme.onBackground),
                  onPressed: () {
                    _searchController.clear();
                    _fetchExercise(); // Fetch all blogs again
                    setState(() {
                      _isNotSearching = true;
                    });
                  },
                ),
              ],
            ),
      body: _buildBody(context),
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
            _buildBlogMainContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildBlogMainContent() {
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
          final blog = jsonList[index];
          if (jsonList != null)
            for (final exercise in jsonList)
              return CustomCard(
                title: blog.title,
                caption: blog.description,
                imageUrl: blog.image_url,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExerciseDetail(id: exercise.id),
                    ),
                  );
                },
              );
        },
      ),
    );
  }
}
