import 'package:YogiTech/api/blog/blog_service.dart';
import 'package:YogiTech/src/models/exercise.dart';
import 'package:YogiTech/src/pages/_onbroading.dart';
import 'package:YogiTech/src/pages/subscription.dart';
import 'package:YogiTech/src/widgets/box_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:YogiTech/api/auth/auth_service.dart';
import 'package:YogiTech/api/exercise/exercise_service.dart';
import 'package:YogiTech/src/custombar/appbar.dart';
import 'package:YogiTech/src/models/account.dart';
import 'package:YogiTech/src/pages/all_exercise.dart';
import 'package:YogiTech/src/pages/exercise_detail.dart';
import 'package:YogiTech/src/pages/filter.dart';
import 'package:YogiTech/src/pages/streak.dart';
import 'package:YogiTech/src/shared/styles.dart';
import 'package:YogiTech/src/shared/app_colors.dart';
import 'package:YogiTech/src/widgets/box_input_field.dart';
import 'package:YogiTech/src/widgets/card.dart';

class HomePage extends StatefulWidget {
  final Account? account;
  final VoidCallback? fetchAccount;
  const HomePage({super.key, this.account, this.fetchAccount});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> jsonList = [];
  List<dynamic> jsonListSort = [];
  bool _isnotSearching = true;
  final TextEditingController _searchController = TextEditingController();
  Account? _account;

  @override
  void initState() {
    super.initState();
    _fetchExercises();
    _fetchExercisesSort();
    _fetchAccount();
  }

  Future<void> _fetchExercisesSort() async {
    final List<dynamic> exercisesSort = await getExercises();

    exercisesSort.sort((a, b) {
      var dateA = DateTime.parse(a.created_at);
      var dateB = DateTime.parse(b.created_at);
      return dateB.compareTo(dateA); // Sort descending (newest to oldest)
    });
    setState(() {
      jsonListSort = exercisesSort;
    });
  }

  Future<void> _fetchExercises() async {
    final List<dynamic> exercises = await getExercises();
    setState(() {
      jsonList = exercises;
    });
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((oldWidget.account != widget.account) ||
        (oldWidget.account?.profile != widget.account?.profile)) {
      _fetchAccount();
    }
  }

  Future<void> _fetchAccount() async {
    if (widget.account != null) {
      setState(() {
        _account = widget.account;
      });
    } else {
      print('I got null');
    }
  }

  @override
  Widget build(BuildContext context) {
    final trans = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: _isnotSearching
            ? CustomAppBar(
                showBackButton: false,
                preActions: [
                  GestureDetector(
                    onTap: () {
                      pushWithoutNavBar(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SubscriptionPage(
                                  account: _account,
                                  fetchAccount: widget.fetchAccount)));
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 28,
                          height: 28,
                          child: Image.asset('assets/images/Emerald.png'),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          _account != null
                              ? _account!.profile.point.toString()
                              : '0',
                          style:
                              h3.copyWith(color: theme.colorScheme.onSurface),
                        ),
                      ],
                    ),
                  ),
                ],
                titleWidget: StreakValue(_account != null
                    ? _account!.profile.streak.toString()
                    : '0'),
                postActions: [
                  IconButton(
                    icon:
                        Icon(Icons.search, color: theme.colorScheme.onSurface),
                    onPressed: () {
                      setState(() {
                        _isnotSearching = false;
                      });
                    },
                  ),
                ],
              )
            : CustomAppBar(
                showBackButton: false,
                preActions: [
                  IconButton(
                    icon: Icon(Icons.tune_outlined),
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
                  trailing: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        String searchValue = _searchController.text.trim();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AllExercise(searchString: searchValue),
                          ),
                        );
                      });
                    },
                  ),
                  keyboardType: TextInputType.text,
                  inputFormatters: const [],
                  onSubmitted: (value) {
                    setState(() {
                      String searchValue = value.trim();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AllExercise(searchString: searchValue),
                        ),
                      );
                    });
                  },
                ),
                postActions: [
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _searchController.clear(); // Clear the search text
                        _isnotSearching = true;
                      });
                    },
                  ),
                ],
              ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CustomButton(
                //     title: 'title',
                //     style: ButtonStyleType.Primary,
                //     onPressed: () => {
                //           pushWithoutNavBar(
                //             context,
                //             MaterialPageRoute(
                //               builder: (context) => OnboardingScreen(),
                //             ),
                //           ),
                //         }),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Container(
                    height: 160, // Chiều cao của khung viền
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: primary, width: 2),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 16, top: 16, bottom: 16),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    trans.tryThisExercise,
                                    textAlign: TextAlign.left,
                                    style: bd_text.copyWith(
                                        color: theme.colorScheme.onPrimary),
                                  ),
                                  Text(
                                    trans.forBeginner,
                                    textAlign: TextAlign.left,
                                    style: h3.copyWith(
                                        color: theme.colorScheme.onPrimary),
                                  ),
                                  const Spacer(),
                                  Text(
                                    'Warrior 2 pose!',
                                    textAlign: TextAlign.left,
                                    style: h3.copyWith(color: primary),
                                  ),
                                ],
                              ),
                            )),
                        const Expanded(
                          flex: 2,
                          child: Image(
                              image: AssetImage(
                                  'assets/images/ads_exercise_for_beginner.png')),
                        ),
                      ],
                    ),
                  ),
                ),
                // Placeholder for ad content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    trans.forYou,
                    style: h3.copyWith(color: theme.colorScheme.onPrimary),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      if (jsonList != null)
                        for (final exercise in jsonList)
                          CustomCard(
                            topRightIcon: exercise.is_premium
                                ? Image.asset('assets/images/Crown.png')
                                : null,
                            title: exercise.title,
                            imageUrl: exercise.image_url,
                            onTap: () {
                              pushWithoutNavBar(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ExerciseDetail(
                                    exercise: exercise,
                                    account: _account,
                                    fetchAccount: widget.fetchAccount,
                                  ),
                                ),
                              );
                            },
                          ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        trans.newest,
                        style: h3.copyWith(color: theme.colorScheme.onPrimary),
                      ),
                      Spacer(),
                      InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            trans.seeall,
                            style: bd_text.copyWith(color: primary),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AllExercise()), // Thay NewPage() bằng trang bạn muốn chuyển tới
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      if (jsonListSort != null)
                        for (final exercise in jsonListSort)
                          CustomCard(
                            topRightIcon: exercise.is_premium
                                ? Image.asset('assets/images/Crown.png')
                                : null,
                            title: exercise.title,
                            // subtitle: exercise.durations ?? '0',
                            imageUrl:
                                exercise.image_url, // URL hình ảnh của bài tập
                            onTap: () {
                              // Chuyển sang trang chi tiết của bài tập khi thẻ được nhấn
                              pushWithoutNavBar(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ExerciseDetail(
                                    exercise: exercise,
                                    account: _account,
                                    fetchAccount: widget.fetchAccount,
                                  ),
                                ),
                              );
                            },
                          ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

// Phải tạo Widget riêng chỉ nhằm mục đích áp dụng màu Gradient
class StreakValue extends StatelessWidget {
  final String streakValue;

  const StreakValue(this.streakValue, {super.key});

  @override
  Widget build(BuildContext context) {
    final trans = AppLocalizations.of(context)!;
    return Center(
      child: GestureDetector(
        onTap: () {
          // Chuyển sang trang mới khi nhấn vào
          pushWithoutNavBar(
            context,
            MaterialPageRoute(
              builder: (context) => Streak(),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              trans.streak,
              style: min_cap.copyWith(
                color: text,
              ),
            ),
            SizedBox(
              height: 32,
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return gradient.createShader(bounds);
                },
                child: Text(
                  streakValue,
                  style: h2.copyWith(color: active, height: 1),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
