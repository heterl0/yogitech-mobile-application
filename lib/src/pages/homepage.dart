import 'package:YogiTech/src/pages/blog_detail.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:YogiTech/src/pages/subscription.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
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
  late int current = 0;
  late CarouselController carouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    _fetchExercises();
    _fetchExercisesSort();
    _fetchAccount();
  }

  Future<void> _fetchExercisesSort() async {
    List<dynamic> exercisesSort = await getExercises();
    exercisesSort =
        exercisesSort.where((element) => element.is_admin == true).toList();

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
                          child: (!(_account?.is_premium ?? false))
                              ? Image.asset('assets/images/Emerald.png')
                              : Image.asset('assets/images/Emerald2.png'),
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
                titleWidget: StreakValue(
                  _account != null ? _account!.profile.streak.toString() : '0',
                  account: _account,
                ),
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
                      pushScreenWithNavBar(
                        context,
                        FilterPage(
                          account: _account,
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
                            builder: (context) => AllExercise(
                                searchString: searchValue, account: _account),
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
                          builder: (context) => AllExercise(
                            searchString: searchValue,
                            account: _account,
                          ),
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
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(16), // Khoảng cách ngoài viền
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: (!(_account?.is_premium ?? false))
                          ? primary
                          : primary2, // Màu của viền
                      width: 2, // Độ dày của viền
                    ),
                    borderRadius: BorderRadius.circular(16), // Bo góc cho viền
                  ),
                  child: CarouselSlider(
                    items: [
                      _buildCarouselItem(
                        title: trans.tryThisExercise,
                        subtitle: trans.forBeginner,
                        poseName: 'Yoga Beginners',
                        imagePath: (!(_account?.is_premium ?? false))
                            ? 'assets/images/ads_exercise_for_beginner.png'
                            : 'assets/images/ads_exercise_for_beginner2.png',
                        onTap: () {
                          final exercise = jsonList.first;
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
                      _buildCarouselItem(
                        title: trans.yogaChangedMyLife,
                        subtitle: trans.minhAnhInspirationalStory,
                        poseName: trans.shareYourJourney,
                        imagePath: (!(_account?.is_premium ?? false))
                            ? 'assets/images/Fire.png'
                            : 'assets/images/Fire2.png',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlogDetail(
                                id: 9,
                              ),
                            ),
                          );
                        },
                      ),
                      _buildCarouselItem(
                        title: trans.specialOfferForNewMembers,
                        subtitle: trans.receiveTwoFreeSessions,
                        poseName: trans.subscribePremiumNow,
                        imagePath: (!(_account?.is_premium ?? false))
                            ? 'assets/images/Crown.png'
                            : 'assets/images/Crown2.png',
                        onTap: () {
                          pushWithoutNavBar(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SubscriptionPage(
                                account: _account,
                                fetchAccount: widget.fetchAccount,
                              ),
                            ),
                          );
                        },
                      ),
                      _buildCarouselItem(
                        title: trans.yogaTipsForBeginners,
                        subtitle: trans.fiveBasicPoses,
                        poseName: trans.exploreNow,
                        imagePath: (!(_account?.is_premium ?? false))
                            ? 'assets/images/Universe.png'
                            : 'assets/images/Universe2.png',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AllExercise(
                                account: _account,
                                fetchAccount: widget.fetchAccount,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                    options: CarouselOptions(
                      height: 200, // Adjust height as needed
                      viewportFraction: 1, // Make items take full width
                      autoPlay: true, // Enable auto-playing if desired
                      onPageChanged: (index, reason) {
                        setState(() {
                          current = index;
                        });
                      },
                    ),
                    carouselController: carouselController,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [0, 1, 2, 3].map((entry) {
                    return GestureDetector(
                      onTap: () => carouselController.animateToPage(
                          entry, // Move to the selected page
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut),
                      child: Container(
                        width: 12.0,
                        height: 12.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (current == entry)
                              ? primary
                              : Colors.grey.withOpacity(0.4),
                        ),
                      ),
                    );
                  }).toList(),
                ),
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
                      if (jsonList.isNotEmpty)
                        for (final exercise in jsonList
                            .where((element) =>
                                element.level == _account!.profile.level)
                            .take(5))
                          CustomCard(
                            premium: _account?.is_premium,
                            topRightIcon: exercise.is_premium
                                ? (!(_account?.is_premium ?? false))
                                    ? Image.asset('assets/images/Crown.png')
                                    : Image.asset('assets/images/Crown2.png')
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
                if (jsonListSort.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          trans.newest,
                          style:
                              h3.copyWith(color: theme.colorScheme.onPrimary),
                        ),
                        Spacer(),
                        InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              trans.seeall,
                              style: bd_text.copyWith(
                                  color: (!(_account?.is_premium ?? false))
                                      ? primary
                                      : primary2),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AllExercise(
                                        account: _account,
                                        fetchAccount: widget.fetchAccount,
                                      )), // Thay NewPage() bằng trang bạn muốn chuyển tới
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
                        for (final exercise in jsonListSort.take(5))
                          CustomCard(
                            premium: _account?.is_premium,
                            topRightIcon: exercise.is_premium
                                ? (!(_account?.is_premium ?? false))
                                    ? Image.asset('assets/images/Crown.png')
                                    : Image.asset('assets/images/Crown2.png')
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          trans.beginner,
                          style:
                              h3.copyWith(color: theme.colorScheme.onPrimary),
                        ),
                        Spacer(),
                        InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              trans.seeall,
                              style: bd_text.copyWith(
                                  color: (!(_account?.is_premium ?? false))
                                      ? primary
                                      : primary2),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AllExercise(
                                        account: _account,
                                        level: 1,
                                        fetchAccount: widget.fetchAccount,
                                      )), // Thay NewPage() bằng trang bạn muốn chuyển tới
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
                        for (final exercise in jsonListSort
                            .where((element) => element.level == 1)
                            .take(5))
                          CustomCard(
                            premium: _account?.is_premium,
                            topRightIcon: exercise.is_premium
                                ? (!(_account?.is_premium ?? false))
                                    ? Image.asset('assets/images/Crown.png')
                                    : Image.asset('assets/images/Crown2.png')
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          trans.intermediate,
                          style:
                              h3.copyWith(color: theme.colorScheme.onPrimary),
                        ),
                        Spacer(),
                        InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              trans.seeall,
                              style: bd_text.copyWith(
                                  color: (!(_account?.is_premium ?? false))
                                      ? primary
                                      : primary2),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AllExercise(
                                        account: _account,
                                        fetchAccount: widget.fetchAccount,
                                        level: 2,
                                      )), // Thay NewPage() bằng trang bạn muốn chuyển tới
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
                        for (final exercise in jsonListSort
                            .where((element) => element.level == 2)
                            .take(5))
                          CustomCard(
                            premium: _account?.is_premium,
                            topRightIcon: exercise.is_premium
                                ? (!(_account?.is_premium ?? false))
                                    ? Image.asset('assets/images/Crown.png')
                                    : Image.asset('assets/images/Crown2.png')
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          trans.advanced,
                          style:
                              h3.copyWith(color: theme.colorScheme.onPrimary),
                        ),
                        Spacer(),
                        InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              trans.seeall,
                              style: bd_text.copyWith(
                                  color: (!(_account?.is_premium ?? false))
                                      ? primary
                                      : primary2),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AllExercise(
                                        account: _account,
                                        level: 3,
                                        fetchAccount: widget.fetchAccount,
                                      )), // Thay NewPage() bằng trang bạn muốn chuyển tới
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
                        for (final exercise in jsonListSort
                            .where((element) => element.level == 3)
                            .take(5))
                          CustomCard(
                            premium: _account?.is_premium,
                            topRightIcon: exercise.is_premium
                                ? (!(_account?.is_premium ?? false))
                                    ? Image.asset('assets/images/Crown.png')
                                    : Image.asset('assets/images/Crown2.png')
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
                ]
              ],
            ),
          ),
        ));
  }

  Widget _buildCarouselItem({
    required String title,
    required String subtitle,
    required String poseName,
    required String imagePath,
    required VoidCallback onTap, // Thêm tham số onTap
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap, // Gọi hàm khi bấm vào item
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.zero,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          bd_text.copyWith(color: theme.colorScheme.onPrimary),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: h3.copyWith(color: theme.colorScheme.onPrimary),
                    ),
                    SizedBox(height: 16),
                    Text(
                      poseName,
                      style: bd_text.copyWith(
                          color: (!(_account?.is_premium ?? false))
                              ? primary
                              : primary2),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 16),
            SizedBox(
              width: 100,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

// Phải tạo Widget riêng chỉ nhằm mục đích áp dụng màu Gradient
class StreakValue extends StatelessWidget {
  final String streakValue;
  final Account? account;

  const StreakValue(this.streakValue, {super.key, this.account});

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
              builder: (context) => Streak(
                currentStreak: streakValue,
                account: account,
              ),
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
                  return (!(account?.is_premium ?? false))
                      ? gradient.createShader(bounds)
                      : gradient2.createShader(bounds);
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
