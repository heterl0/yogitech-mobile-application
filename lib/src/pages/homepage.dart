import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:yogi_application/api/auth/auth_service.dart';
import 'package:yogi_application/api/exercise/exercise_service.dart';
import 'package:yogi_application/src/custombar/appbar.dart';
import 'package:yogi_application/src/models/account.dart';
import 'package:yogi_application/src/pages/all_exercise.dart';
import 'package:yogi_application/src/pages/exercise_detail.dart';
import 'package:yogi_application/src/pages/filter.dart';
import 'package:yogi_application/src/pages/streak.dart';
import 'package:yogi_application/src/pages/subscription.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/widgets/box_input_field.dart';
import 'package:yogi_application/src/widgets/card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var jsonList;
  bool _isnotSearching = true;
  final TextEditingController _searchController = TextEditingController();
  Account? account;

  @override
  void initState() {
    super.initState();
    _fetchExercises();
  }

  Future<void> _fetchExercises() async {
    final List<dynamic> exercises = await getExercises();
    setState(() {
      jsonList = exercises;
    });
  }

  Future<void> _fetchAccount() async {
    final Account? _account = await retrieveAccount();
    setState(() {
      account = _account;
    });
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
                              builder: (context) => Subscription()));
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 40,
                          height: 50,
                          child: Image.asset('assets/images/Emerald.png'),
                        ),
                        Text(
                          account != null
                              ? account!.profile.point.toString()
                              : '0',
                          style:
                              h3.copyWith(color: theme.colorScheme.onSurface),
                          style:
                              h3.copyWith(color: theme.colorScheme.onSurface),
                        ),
                      ],
                    ),
                  ),
                ],
                titleWidget: StreakValue(
                    account != null ? account!.profile.streak.toString() : '0'),
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
                  trailing: Icon(Icons.search),
                  keyboardType: TextInputType.text,
                  inputFormatters: const [],
                  onSubmitted: (value) {
                    setState(() {
                      String searchValue = value.trim();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AllExercise(
                                searchString:
                                    searchValue)), // Thay NewPage() bằng trang bạn muốn chuyển tới
                            builder: (context) => AllExercise(
                                searchString:
                                    searchValue)), // Thay NewPage() bằng trang bạn muốn chuyển tới
                      );
                      // Use the value here after the user submits
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
                            title: exercise.title,
                            // subtitle: exercise.durations ?? '0',
                            imageUrl:
                                exercise.image_url, // URL hình ảnh của bài tập
                            onTap: () {
                              // Chuyển sang trang chi tiết của bài tập khi thẻ được nhấn
                              pushWithoutNavBar(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ExerciseDetail(id: exercise.id),
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
                      // SizedBox(
                      //   width: 130, // Điều chỉnh kích thước nút nếu cần
                      //   child: BoxButton(
                      //     title: trans.seeall,
                      //     style: ButtonStyleType.Tertiary,
                      //     onPressed: () {

                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: List.generate(5, (index) {
                      return CustomCard(
                        title: 'Card with Image',
                        caption:
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                        onTap: () {
                          // Navigate to the detail page when the card is tapped
                          pushWithoutNavBar(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExerciseDetail(),
                            ),
                          );
                        },
                      );
                    }),
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
