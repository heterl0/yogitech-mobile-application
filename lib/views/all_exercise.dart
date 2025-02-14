import 'package:YogiTech/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:YogiTech/api/exercise/exercise_service.dart';
import 'package:YogiTech/custombar/appbar.dart';
import 'package:YogiTech/models/account.dart';
import 'package:YogiTech/models/pose.dart';
import 'package:YogiTech/views/exercise_detail.dart';
import 'package:YogiTech/views/filter.dart';
import 'package:YogiTech/shared/styles.dart';
import 'package:YogiTech/widgets/box_input_field.dart';
import 'package:YogiTech/widgets/card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AllExercise extends StatefulWidget {
  final String? searchString;
  final Muscle? selectedMuscle;
  final String? category;
  final Account? account;
  final VoidCallback? fetchAccount;
  final int? level;

  const AllExercise(
      {super.key,
      this.searchString,
      this.selectedMuscle,
      this.account,
      this.fetchAccount,
      this.category,
      this.level});

  @override
  AllExerciseState createState() => AllExerciseState();
}

class AllExerciseState extends State<AllExercise> {
  List<dynamic> _exercises = [];
  bool _isLoading = false;

  final TextEditingController _searchController = TextEditingController();
  Account? _account;

  @override
  void initState() {
    super.initState();
    _fetchExercise(widget.searchString, widget.selectedMuscle);
    _account = widget.account;
    _searchController.text = widget.searchString ?? '';
  }

  // Future<void> _fetchAccount() async {
  //   final Account? _account = await retrieveAccount();
  //   setState(() {
  //     account = _account;
  //   });
  // }

  Future<void> _fetchExercise([String? query = '', Muscle? mus]) async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<dynamic> exercises =
          await getExercises(); // Assuming getExercises() returns a List<Exercise>
      exercises =
          exercises.where((element) => element.is_admin == true).toList();
      if (widget.level != null) {
        exercises = exercises
            .where((element) => element.level == widget.level)
            .toList();
      }
      List<dynamic> filteredExercises = exercises;
      if (query != null && query.isNotEmpty) {
        filteredExercises = exercises
            .where((exercise) =>
                (exercise.title.toString().replaceAll(" ", "").toLowerCase())
                    .contains(query.toLowerCase().replaceAll(" ", "")))
            .toList();
      }
      if (mus != null) {
        filteredExercises = filteredExercises.where((exercise) {
          for (var poseWithTime in exercise.poses) {
            if (poseWithTime.pose.muscles
                .any((muscle) => muscle.id == mus.id)) {
              return true; // Keep this exercise
            }
          }
          return false; // Filter out this exercise
        }).toList();
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
      appBar: CustomAppBar(
        showBackButton: false,
        preActions: [
          IconButton(
            icon: Icon(Icons.tune_outlined, color: theme.colorScheme.onSurface),
            onPressed: () {
              pushScreenWithNavBar(
                  context,
                  FilterPage(
                    account: _account,
                  ));
            },
          ),
        ],
        style: widthStyle.Large,
        titleWidget: BoxInputField(
          controller: _searchController,
          placeholder: trans.search,
          trailing: IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Thực hiện hành động tìm kiếm khi biểu tượng được nhấn
              setState(() {
                _fetchExercise(_searchController.text.trim());
              });
            },
          ),
          keyboardType: TextInputType.text,
          inputFormatters: const [],
          onTap: () {
            // Handle input field tap if needed
          },
          onSubmitted: (value) {
            setState(() {
              _fetchExercise(value.trim());
            });
          },
        ),
        postActions: [
          IconButton(
            icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
            onPressed: () {
              setState(() {
                _fetchExercise('');
                _searchController.clear();
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) =>
                //           HomePage()), // Thay NewPage() bằng trang bạn muốn chuyển tới
                // );
                Navigator.pop(context);
              });
            },
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    Map<String, String> muscleMap = {
      'Quadriceps': 'Cơ tứ đầu',
      'Pelvis': 'Khung chậu',
      'Neck': 'Cổ',
      'Knees': 'Đầu gối',
      'Interior Hips': 'Hông trong',
      'Chest': 'Ngực',
      'Feet Ankles': 'Bàn chân và mắt cá chân',
      'Abs': 'Cơ bụng',
      'Biceps': 'Cơ nhị đầu',
      'Shoulder': 'Vai',
      'Exterior Hips': 'Hông ngoài',
      'Hamstrings': 'Cơ gân kheo',
      'Gluteus': 'Cơ mông',
      'Hip': 'Hông',
      'Middle Back': 'Lưng giữa',
      'Triceps': 'Cơ tam đầu',
      'Upper Back': 'Lưng trên',
      'Lower Back': 'Lưng dưới'
    };
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    final String categoryName = widget.category != null
        ? (trans.locale == "en"
            ? widget.category!
            : muscleMap[widget.category!]!)
        : ''; // Lấy tên danh mục dựa trên locale
    return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: theme.colorScheme.surface),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                color: (!(_account?.is_premium ?? false)) ? primary : primary2,
              )) // Show spinner when loading
            : SingleChildScrollView(
                child: Column(
                  children: [
                    if (categoryName
                        .isNotEmpty) // Chỉ hiển thị Chip nếu có danh mục
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 12), // Thêm padding xung quanh Chip
                        child: Row(
                          children: [
                            SizedBox(
                              width: 36,
                            ),
                            Text(
                              '${trans.category}:',
                              style: bd_text.copyWith(
                                  color: theme.colorScheme.onSurface),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                color: (!(_account?.is_premium ?? false))
                                    ? primary
                                    : primary2, // Màu nền
                                borderRadius:
                                    BorderRadius.circular(20.0), // Bo góc
                              ),
                              child: Text(
                                categoryName,
                                style: min_cap.copyWith(color: active),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      SizedBox(
                        height: 24,
                      ),
                    _buildBlogMainContent(),
                  ],
                ),
              ));
  }

  Widget _buildBlogMainContent() {
    final trans = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: .0, left: 24.0, right: 24.0),
      child: _exercises.isNotEmpty
          ? GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 4 / 5,
              ),
              itemCount: _exercises.length,
              itemBuilder: (context, index) {
                final ex = _exercises[index];
                return CustomCard(
                  premium: _account?.is_premium,
                  topRightIcon: ex.is_premium
                      ? (!(_account?.is_premium ?? false))
                          ? Image.asset('assets/images/Crown.png')
                          : Image.asset('assets/images/Crown2.png')
                      : null,
                  title: ex.title,
                  caption: ex.description.replaceAll(RegExp(r'<[^>]*>'), ''),
                  imageUrl: ex.image_url ??
                      ((!(_account?.is_premium ?? false))
                          ? 'assets/images/Null_Exercise.png'
                          : 'assets/images/Null_Exercise2.png'),
                  onTap: () {
                    pushWithoutNavBar(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExerciseDetail(
                            exercise: ex,
                            account: _account,
                            fetchAccount: widget.fetchAccount),
                      ),
                    );
                  },
                );
              },
            )
          : Center(
              child: Text(
                trans.noResult,
                style: bd_text.copyWith(color: text),
              ),
            ),
    );
  }
}
