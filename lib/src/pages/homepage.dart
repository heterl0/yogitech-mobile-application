import 'package:flutter/material.dart';
import 'package:yogi_application/src/custombar/appbar.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';
import 'package:yogi_application/src/pages/exercise_detail.dart';
import 'package:yogi_application/src/pages/filter.dart';
import 'package:yogi_application/src/pages/streak.dart';
import 'package:yogi_application/src/pages/subscription.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/widgets/box_input_field.dart';
import 'package:yogi_application/src/widgets/card.dart';

class HomePage extends StatefulWidget {
  final String? savedEmail;
  final String? savedPassword;

  HomePage({required this.savedEmail, required this.savedPassword});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var jsonList;
  bool _isnotSearching = true;
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: _isnotSearching
          ? CustomAppBar(
              showBackButton: false,
              preActions: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Subscription(),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 50,
                        child: Image.asset('assets/images/Emerald.png'),
                      ),
                      Text(
                        '5',
                        style:
                            h3.copyWith(color: theme.colorScheme.onBackground),
                      ),
                    ],
                  ),
                ),
              ],
              titleWidget: const StreakValue('0000'),
              postActions: [
                IconButton(
                  icon:
                      Icon(Icons.search, color: theme.colorScheme.onBackground),
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
                  icon: Icon(Icons.tune_outlined,
                      color: theme.colorScheme.onBackground),
                  onPressed: () {
                    Navigator.push(
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
                placeholder: 'Search...',
                trailing: Icon(Icons.search),
                keyboardType: TextInputType.text,
                inputFormatters: [],
                onTap: () {
                  // Xử lý khi input field được nhấn
                },
              ),
              postActions: [
                IconButton(
                  icon:
                      Icon(Icons.close, color: theme.colorScheme.onBackground),
                  onPressed: () {
                    setState(() {
                      _isnotSearching = true;
                    });
                  },
                ),
              ],
            ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Container(
                height: 160, // Chiều cao của khung viền
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: primary, width: 2),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Try this exercise',
                            textAlign: TextAlign.left,
                            style: bd_text.copyWith(
                                color: theme.colorScheme.onPrimary),
                          ),
                          Text(
                            'for beginner',
                            textAlign: TextAlign.left,
                            style:
                                h3.copyWith(color: theme.colorScheme.onPrimary),
                          ),
                          const Spacer(),
                          Text(
                            'Warrior 2 pose!',
                            textAlign: TextAlign.left,
                            style: h3.copyWith(color: primary),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 160, // Độ rộng của nửa bên phải
                      child: const Image(
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
                'For You',
                style: h3.copyWith(color: theme.colorScheme.onPrimary),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Replace these placeholders with your actual content
                  CustomCard(
                    title: 'Card with Image',
                    caption:
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExerciseDetail(),
                        ),
                      );
                    },
                  ),
                  CustomCard(
                    title: 'Card with Image',
                    caption:
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                  ),
                  CustomCard(
                    title: 'Card with Image',
                    caption:
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                  ),
                  // Add more containers if needed
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Newest',
                style: h3.copyWith(color: theme.colorScheme.onPrimary),
              ),
            ),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Similar to the "For You" section, add your content here
                  CustomCard(
                    title: 'Card with Image',
                    caption:
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                  ),
                  CustomCard(
                    title: 'Card with Image',
                    caption:
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                  ),
                  CustomCard(
                    title: 'Card with Image',
                    caption:
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomBar(),
    );
  }
}

// Phải tạo Widget riêng chỉ nhằm mục đích áp dụng màu Gradient
class StreakValue extends StatelessWidget {
  final String streakValue;

  const StreakValue(this.streakValue, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          // Chuyển sang trang mới khi nhấn vào
          Navigator.push(
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
              'Streak',
              style: min_cap.copyWith(
                color: text,
              ),
            ),
            Container(
              height: 32,
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return gradient.createShader(bounds);
                },
                child: Text(
                  streakValue,
                  style: h2.copyWith(color: Colors.white, height: 1),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
