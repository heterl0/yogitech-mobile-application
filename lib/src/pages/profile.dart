import 'package:flutter/material.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/shared/app_colors.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24.0),
            bottomRight: Radius.circular(24.0),
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: theme.colorScheme.onSecondary,
            bottom: PreferredSize(
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
                    IconButton(
                      icon: Image.asset('assets/icons/share.png'),
                      onPressed: () {},
                    ),
                    Text('Profile',
                        style:
                            h2.copyWith(color: theme.colorScheme.onBackground)),
                    IconButton(
                      icon: Image.asset('assets/icons/settings.png'),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Container(
                        width: 144, // 2 * radius + 8 (border width) * 2
                        height:
                            144, // Đã sửa lại thành 144 cho khớp tỉ lệ so với Figma
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 78,
                          backgroundImage:
                              AssetImage('assets/images/avatar.png'),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Duy',
                        style: h2.copyWith(color: theme.colorScheme.onPrimary),
                      ),
                    ],
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InfoCard(
                          title: 'Calorie',
                          subtitle: 'Your total of calories',
                          iconPath: 'assets/icons/info.png',
                          onTap: () {
                            print('Calorie info pressed');
                          },
                        ),
                        SizedBox(height: 6),
                        InfoCard(
                          title: 'Social',
                          subtitle: 'Your friends and more',
                          iconPath: 'assets/icons/diversity_2.png',
                          onTap: () {
                            print('Social info pressed');
                          },
                        ),
                        SizedBox(height: 6),
                        InfoCard(
                          title: 'Personalized Exercise',
                          subtitle: 'Your customize exercise',
                          iconPath: 'assets/icons/tune_setting.png',
                          onTap: () {
                            print('Personalized Exercise info pressed');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        StatCard(
                          title: 'Following',
                          value: '6', // Replace with API data
                          valueColor: theme.colorScheme.onPrimary,
                        ),
                        SizedBox(height: 16),
                        StatCard(
                          title: 'Follower',
                          value: '7', // Replace with API data
                          valueColor: theme.colorScheme.onPrimary,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        StatCard(
                          title: 'EXP',
                          value: '999', // Replace with API data
                          valueColor: primary,
                          isTitleFirst: true,
                        ),
                        SizedBox(height: 16),
                        StatCard(
                          title: 'BMI',
                          value: '18.5', // Replace with API data
                          valueColor: theme.colorScheme.onPrimary,
                          isTitleFirst: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(0.0),
                      height: 160,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF8D8E99)),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0), // Added space for better layout
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(44.0),
                        border: Border.all(color: error, width: 2.0),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            // Xử lý sự kiện khi nhấn vào nút "Đăng xuất"
                          },
                          borderRadius: BorderRadius.circular(44.0),
                          child: Center(
                            child: Text('Logout',
                                style: h3.copyWith(color: error)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(),
    );
  }
}

// Widget dùng chung cho Calorie, Social và Personalized Exercise
class InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconPath;
  final VoidCallback onTap;

  InfoCard({
    required this.title,
    required this.subtitle,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: stroke),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: bd_text.copyWith(color: theme.colorScheme.onPrimary),
              ),
              Text(
                subtitle,
                style: min_cap.copyWith(color: text),
              ),
            ],
          ),
          InkWell(
            onTap: onTap,
            child: Image.asset(
              iconPath,
              width: 20,
              height: 20,
            ),
          ),
        ],
      ),
    );
  }
}

// Widget dùng chung cho Following, EXP, Follower và BMI
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;
  final bool isTitleFirst;

  StatCard({
    required this.title,
    required this.value,
    required this.valueColor,
    this.isTitleFirst = false, // Mặc định title sẽ đứng trước value
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: isTitleFirst
            ? [
                Text(
                  title,
                  style: min_cap.copyWith(color: text),
                ),
                SizedBox(width: 10),
                Text(value, style: h2.copyWith(color: valueColor)),
              ]
            : [
                Text(value, style: h2.copyWith(color: valueColor)),
                SizedBox(width: 10),
                Text(
                  title,
                  style: min_cap.copyWith(color: text),
                ),
              ],
      ),
    );
  }
}
