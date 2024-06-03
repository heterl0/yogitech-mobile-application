import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
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
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_isSearching ? 100 : 100),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24.0),
            bottomRight: Radius.circular(24.0),
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: theme.colorScheme.onSecondary,
            title: _isSearching ? _buildSearchBar() : _buildDefaultAppBar(),
            bottom: _isSearching
                ? null
                : PreferredSize(
                    preferredSize: Size.fromHeight(0),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 12.0,
                        right: 24.0,
                        left: 24.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              // Xử lý khi nhấn vào nút
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 50,
                                  child:
                                      Image.asset('assets/images/Emerald.png'),
                                ),
                                SizedBox(width: 0),
                                Text(
                                  '5',
                                  style: h3.copyWith(
                                      color: theme.colorScheme.onBackground),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Streak',
                                style: min_cap.copyWith(color: text),
                              ),
                              Streak_value('7777777'),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.search,
                                color: theme.colorScheme.onBackground),
                            onPressed: () {
                              setState(() {
                                _isSearching = true;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
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
                              style: h3.copyWith(
                                  color: theme.colorScheme.onPrimary),
                            ),
                            Spacer(),
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
                  'For You',
                  style: h3.copyWith(color: theme.colorScheme.onPrimary),
                ),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    // Replace these placeholders with your actual content
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
                    // Add more containers if needed
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Newest',
                  style: h3.copyWith(color: theme.colorScheme.onPrimary),
                ),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16),
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
      ),
      bottomNavigationBar: CustomBottomBar(),
    );
  }

  Widget _buildDefaultAppBar() {
    return Text('');
  }

  Widget _buildSearchBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          children: [
            IconButton(
              icon: Image.asset('assets/icons/tune.png'),
              onPressed: () {
                // Handle filter button press
              },
            ),
            Expanded(
              child: Container(
                height: 44,
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(44.0),
                      borderSide: BorderSide(color: Color(0xFF8D8E99)),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    suffixIcon: IconButton(
                      icon: Image.asset('assets/icons/search.png'),
                      onPressed: () {
                        // Handle the send button press
                      },
                    ),
                  ),
                  cursorColor: Colors.white,
                ),
              ),
            ),
            IconButton(
              icon: Image.asset('assets/icons/close.png'),
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Phải tạo Widget riêng chỉ nhằm mục đích áp dụng màu Gradient
class Streak_value extends StatelessWidget {
  final String text;

  const Streak_value(this.text);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return gradient.createShader(bounds); // Sử dụng gradient từ styles.dart
      },
      child: Text(
        text,
        style: h2.copyWith(color: Colors.white), // hoặc màu chữ mong muốn
      ),
    );
  }
}
