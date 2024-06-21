import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:yogi_application/api/auth/auth_service.dart';
import 'package:yogi_application/api/exercise/exercise_service.dart';
import 'package:yogi_application/src/custombar/appbar.dart';
import 'package:yogi_application/src/models/account.dart';
import 'package:yogi_application/src/models/exercise.dart';
import 'package:yogi_application/src/models/pose.dart';
import 'package:yogi_application/src/pages/exercise_detail.dart';
import 'package:yogi_application/src/pages/filter.dart';
import 'package:yogi_application/src/pages/homepage.dart';
import 'package:yogi_application/src/pages/subscription.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/widgets/box_input_field.dart';
import 'package:yogi_application/src/widgets/card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AllExercise extends StatefulWidget {
  final String? searchString;
  final Muscle? selectedMuscle;
  const AllExercise({super.key, this.searchString, this.selectedMuscle});

  @override
  BlogState createState() => BlogState();
}

class BlogState extends State<AllExercise> {
  List<dynamic> _exercises = [];
  bool _isNotSearching = true;
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  Account? account;

  @override
  void initState() {
    super.initState();
    _fetchExercise(widget.searchString, widget.selectedMuscle);
    _fetchAccount();
    _searchController.text = widget.searchString ?? '';
  }

  Future<void> _fetchAccount() async {
    final Account? _account = await retrieveAccount();
    setState(() {
      account = _account;
    });
  }

  Future<void> _fetchExercise([String? query = '', Muscle? mus]) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final List<dynamic> exercises = await getExercises(); // Assuming getExercises() returns a List<Exercise>
      List<dynamic> filteredExercises = exercises;
      if (query != null && query.isNotEmpty) {
        filteredExercises = exercises.where((exercise) => (exercise.title.toString().replaceAll(" ", "").toLowerCase()).contains(query.toLowerCase().replaceAll(" ", ""))).toList();
      }
      if (mus != null) {
        for (var i = 0; i < filteredExercises.length; i++) {
          List<PoseWithTime> poses = filteredExercises[i].poses;
          for (var p = 0; p < poses.length; p++) {
            if (!poses[p].pose.muscles.any((muscle) => muscle == mus)) {
              filteredExercises.removeAt(i);
            }
          }
        }
      }
      setState(() {
        _exercises = filteredExercises;
        _isLoading = false;
      });
    } catch (e) {
      // Handle errors, e.g., show a snackbar or error message
      print('Error loading exercises: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: _isNotSearching
          ? CustomAppBar(
              showBackButton: false,
              preActions: [
                GestureDetector(
                  onTap: () {
                    pushWithoutNavBar(context, MaterialPageRoute(builder: (context) => Subscription()));
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 40,
                        height: 50,
                        child: Image.asset('assets/images/Emerald.png'),
                      ),
                      Text(
                        account != null ? account!.profile.point.toString() : '0',
                        style: h3.copyWith(color: theme.colorScheme.onSurface),
                      ),
                    ],
                  ),
                ),
              ],
              titleWidget: StreakValue(account != null ? account!.profile.streak.toString() : '0'),
              postActions: [
                IconButton(
                  icon: Icon(Icons.search, color: theme.colorScheme.onSurface),
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
              preActions: [
                IconButton(
                  icon: Icon(Icons.tune_outlined, color: theme.colorScheme.onSurface),
                  onPressed: () {
                    pushWithoutNavBar(context, MaterialPageRoute(builder: (context) => FilterPage()));
                  },
                ),
              ],
              style: widthStyle.Medium,
              titleWidget: BoxInputField(
                controller: _searchController,
                placeholder: widget.searchString != null ? widget.searchString! : trans.search,
                trailing: Icon(Icons.search),
                keyboardType: TextInputType.text,
                inputFormatters: const [],
                onTap: () {
                  // Handle input field tap if needed
                },
                onSubmitted: (value) {
                  setState(() {
                    _fetchExercise(value.trim());
                    _isNotSearching = true;
                  });
                },
              ),
              postActions: [
                IconButton(
                  icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
                  onPressed: () {
                    setState(() {
                      _isNotSearching = true;
                      _fetchExercise('');
                      _searchController.clear();
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
      decoration: BoxDecoration(color: theme.colorScheme.surface),
      child: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show spinner when loading
          : SingleChildScrollView(
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
        itemCount: _exercises.length,
        itemBuilder: (context, index) {
          final blog = _exercises[index];
          return CustomCard(
            title: blog.title,
            caption: blog.description,
            imageUrl: blog.image_url,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExerciseDetail(id: blog.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
