import 'package:YogiTech/src/shared/premium_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:share_plus/share_plus.dart';
import 'package:YogiTech/api/account/account_service.dart';
import 'package:YogiTech/api/auth/auth_service.dart';
import 'package:YogiTech/src/custombar/appbar.dart';
import 'package:YogiTech/src/models/account.dart';
import 'package:YogiTech/src/pages/change_profile.dart';
import 'package:YogiTech/src/pages/calorie.dart';
import 'package:YogiTech/src/pages/social.dart';
import 'package:YogiTech/src/routing/app_routes.dart';
import 'package:YogiTech/src/shared/styles.dart';
import 'package:YogiTech/src/shared/app_colors.dart';
import 'package:YogiTech/src/pages/personalized_exercise_list.dart';
import 'package:YogiTech/src/pages/settings.dart';
import 'package:YogiTech/src/pages/friendlist.dart';
import 'package:YogiTech/src/pages/change_BMI.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:ui';

class ProfilePage extends StatefulWidget {
  final Account? account;
  final VoidCallback? fetchAccount;

  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final Locale locale;
  final ValueChanged<bool> onLanguageChanged;
  final bool isVietnamese;

  const ProfilePage(
      {super.key,
      required this.isDarkMode,
      required this.onThemeChanged,
      required this.locale,
      required this.onLanguageChanged,
      required this.isVietnamese,
      this.account,
      this.fetchAccount});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  Profile? _profile;
  Account? _account;
  bool _isLoading = false;
  late TabController _tabController;
  final int initialTabIndex = 0;

  List<FlSpot> sampleDataPoints = [
    FlSpot(0, 1000), // x = thời gian (ví dụ: ngày), y = điểm
    FlSpot(1, 1200),
    FlSpot(2, 1400),
    FlSpot(3, 1600),
    FlSpot(4, 1800),
    FlSpot(5, 2000),
  ];

  List<FlSpot> sampleDataExp = [
    FlSpot(0, 2000), // x = thời gian (ví dụ: ngày), y = kinh nghiệm
    FlSpot(1, 2200),
    FlSpot(2, 2400),
    FlSpot(3, 2600),
    FlSpot(4, 2800),
    FlSpot(5, 3000),
  ];

  void refreshProfile() {
    // Gọi API để lấy lại dữ liệu hồ sơ sau khi cập nhật BMI
    widget.fetchAccount?.call();
    _fetchUserProfile();
  }

  Future<void> _logout() async {
    try {
      // Xóa token từ SharedPreferences khi người dùng logout
      await clearToken();
      await clearAccount();
      // Chuyển hướng đến trang đăng nhập và xóa tất cả các route cũ
      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
          AppRoutes.login, (Route<dynamic> route) => false);
    } catch (e) {
      print('Logout error: $e');
      // Xử lý lỗi khi logout
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchUserProfile();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.account != widget.account) {
      _fetchUserProfile();
    }
  }

  Future<void> _fetchUserProfile() async {
    setState(() {
      _isLoading = true;
      _account = widget.account;
      _profile = _account?.profile;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: CustomAppBar(
          showBackButton: false,
          title: trans.profile,
          preActions: [
            IconButton(
              icon: Icon(
                Icons.ios_share,
                color: theme.colorScheme.onSurface,
              ),
              onPressed: () async {
                await Share.share(
                    'check out my website https://www.yogitech.me',
                    subject: 'Look what I made!');
              },
            ),
          ],
          postActions: [
            IconButton(
                icon: Icon(
                  Icons.settings_outlined,
                  color: theme.colorScheme.onSurface,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(
                        isVietnamese: widget.isVietnamese,
                        isDarkMode: widget.isDarkMode,
                        onThemeChanged: widget.onThemeChanged,
                        locale: widget.locale,
                        onLanguageChanged: widget.onLanguageChanged,
                        onProfileUpdated: refreshProfile,
                        account: _account,
                      ),
                    ),
                  );
                })
          ],
        ),
        body: _isLoading // Check loading state
            ? Center(child: CircularProgressIndicator())
            : SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) {
                            return gradient.createShader(bounds);
                          },
                          child: Text(
                            [
                              (_profile?.last_name ?? ''),
                              (_profile?.first_name ?? '')
                            ].where((s) => s.isNotEmpty).join(' ').isEmpty
                                ? trans.name
                                : [
                                    (_profile?.last_name ?? ''),
                                    (_profile?.first_name ?? '')
                                  ].where((s) => s.isNotEmpty).join(' '),
                            style: h2.copyWith(color: active),
                          ),
                        ),

                        const SizedBox(height: 16),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                pushWithoutNavBar(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChangeProfilePage(
                                            onProfileUpdated: refreshProfile,
                                            account: _account,
                                          )), // Thay NewPage() bằng trang bạn muốn chuyển tới
                                );
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width:
                                        144, // 2 * radius + 8 (border width) * 2
                                    height:
                                        144, // Đã sửa lại thành 144 cho khớp tỉ lệ so với Figma
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: _profile != null &&
                                            (_profile!.avatar_url != null &&
                                                _profile!
                                                    .avatar_url!.isNotEmpty)
                                        ? CircleAvatar(
                                            radius: 50,
                                            backgroundImage: _profile!
                                                        .avatar_url !=
                                                    null
                                                ? CachedNetworkImageProvider(
                                                    _profile!.avatar_url!)
                                                : null,
                                            backgroundColor: Colors.transparent,
                                            child: _profile!.avatar_url == null
                                                ? Icon(Icons.person, size: 50)
                                                : null,
                                          )
                                        : Center(
                                            child: _profile != null &&
                                                    (_profile!.avatar_url !=
                                                            null &&
                                                        _profile!.avatar_url!
                                                            .isNotEmpty)
                                                ? CircleAvatar(
                                                    radius: 50,
                                                    backgroundImage:
                                                        CachedNetworkImageProvider(
                                                            _profile!
                                                                .avatar_url!),
                                                    backgroundColor:
                                                        Colors.transparent,
                                                  )
                                                : Center(
                                                    child: Container(
                                                      width: 144,
                                                      height: 144,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color:
                                                            Colors.transparent,
                                                        border: Border.all(
                                                          color:
                                                              primary, // Màu của border
                                                          width:
                                                              3.0, // Độ rộng của border
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          (_account?.username ??
                                                                      '')
                                                                  .isNotEmpty
                                                              ? (_account!
                                                                  .username[0]
                                                                  .toUpperCase())
                                                              : '',
                                                          style: TextStyle(
                                                            fontSize: 40,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: theme
                                                                .colorScheme
                                                                .onPrimary, // Màu chữ
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    trans.avatar,
                                    style: bd_text.copyWith(color: text),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InfoCard(
                                    title: trans.friends,
                                    subtitle: trans.listFriend,
                                    icon: Icons.people_alt_outlined,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FriendListPage(
                                            initialTabIndex: 0,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 6),
                                  InfoCard(
                                    title: trans.social,
                                    subtitle: trans.yourFriends,
                                    icon: Icons.diversity_2_outlined,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SocialPage(
                                            account: _account,
                                            onProfileUpdated: refreshProfile,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 6),
                                  ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(16)),
                                      child: Stack(
                                        children: [
                                          InfoCard(
                                            title: trans.personalizedExercise,
                                            subtitle: trans.customizeExercise,
                                            icon: Icons.tune_outlined,
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PersonalizedExercisePage(),
                                                ),
                                              );
                                            },
                                          ),
                                          // if (!(_account?.is_premium ?? false))
                                          //   Positioned.fill(
                                          //     child: BackdropFilter(
                                          //       filter: ImageFilter.blur(
                                          //           sigmaX: 5, sigmaY: 5),
                                          //       child: GestureDetector(
                                          //         onTap: () => {
                                          //           showPremiumDialog(
                                          //               context,
                                          //               _account!,
                                          //               widget.fetchAccount),
                                          //         },
                                          //         child: Container(
                                          //           color: theme
                                          //               .colorScheme.onSecondary
                                          //               .withOpacity(0.8),
                                          //           child: Center(
                                          //             child: Row(
                                          //               mainAxisAlignment:
                                          //                   MainAxisAlignment
                                          //                       .center,
                                          //               children: [
                                          //                 Icon(
                                          //                   Icons.lock_outline,
                                          //                   color: theme
                                          //                       .colorScheme
                                          //                       .onPrimary,
                                          //                   size: 24,
                                          //                 ),
                                          //                 SizedBox(width: 8),
                                          //                 Text(
                                          //                   trans
                                          //                       .premiumFeature,
                                          //                   style: bd_text.copyWith(
                                          //                       color: theme
                                          //                           .colorScheme
                                          //                           .onPrimary),
                                          //                 ),
                                          //               ],
                                          //             ),
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  StatCard(
                                    title: trans.following,
                                    value:
                                        _account?.following.length.toString() ??
                                            '0', // Replace with API data
                                    valueColor: theme.colorScheme.onPrimary,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FriendListPage(
                                            initialTabIndex: 0,
                                            account: _account,
                                            onProfileUpdated: refreshProfile,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  StatCard(
                                    title: trans.follower,
                                    value:
                                        _account?.followers.length.toString() ??
                                            '0', // Replace with API data
                                    valueColor: theme.colorScheme.onPrimary,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FriendListPage(
                                            initialTabIndex: 1,
                                            account: _account,
                                            onProfileUpdated: refreshProfile,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                children: [
                                  StatCard(
                                    title: 'EXP',
                                    value: _profile?.exp.toString() ?? '',
// Replace with API data
                                    valueColor: primary,
                                    isTitleFirst: true,
                                  ),
                                  StatCard(
                                    title: 'BMI',
                                    value: _profile?.bmi?.toString() ??
                                        '0', // Replace with API data
                                    valueColor: theme.colorScheme.onPrimary,
                                    isTitleFirst: true,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChangeBMIPage(
                                            onBMIUpdated: refreshProfile,
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
                        const SizedBox(height: 20.0),
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          child: Stack(
                            children: [
                              TabBar(
                                dividerColor: Colors.transparent,
                                controller: _tabController,
                                indicator: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: primary,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                unselectedLabelColor: text,
                                tabs: [
                                  Tab(
                                    child: Text(
                                      'EXP',
                                      style: h3,
                                    ),
                                  ),
                                  Tab(
                                    child: Text(
                                      trans.point,
                                      style: h3,
                                    ),
                                  ),
                                  Tab(
                                    child: Text(
                                      trans.calorie,
                                      style: h3,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 80),
                                height: 240,
                                child: TabBarView(
                                  controller: _tabController,
                                  children: [
                                    _buildLineChart(sampleDataPoints),
                                    _buildLineChart(sampleDataExp),
                                    _buildLineChart(sampleDataExp),
                                  ],
                                ),
                              ),

                              // Padding(
                              //   padding: EdgeInsets.all(8),
                              //   child: AspectRatio(
                              //     aspectRatio: 16 / 9,
                              //     child: LineChart(LineChartData(
                              //       borderData: FlBorderData(show: false),
                              //       gridData: FlGridData(
                              //         show: true,
                              //         drawVerticalLine: false,
                              //         drawHorizontalLine: true,
                              //         getDrawingHorizontalLine: (value) {
                              //           return FlLine(
                              //             color: stroke,
                              //             strokeWidth: 1,
                              //           );
                              //         },
                              //       ),
                              //       lineBarsData: [
                              //         LineChartBarData(
                              //           spots: sampleDataPoints,
                              //           isCurved: true,
                              //           color: green,
                              //           barWidth: 4,
                              //         ),
                              //         LineChartBarData(
                              //           spots: sampleDataExp,
                              //           isCurved: true,
                              //           gradient: gradient,
                              //           barWidth: 4,
                              //         ),
                              //       ],
                              //       titlesData: FlTitlesData(
                              //         leftTitles: AxisTitles(
                              //           sideTitles: SideTitles(
                              //             getTitlesWidget: (value, meta) {
                              //               return Text(
                              //                 value.toString(),
                              //                 style:
                              //                     min_cap.copyWith(color: text),
                              //                 textAlign: TextAlign.center,
                              //               );
                              //             },
                              //             reservedSize: 60,
                              //             showTitles: true,
                              //           ),
                              //         ),
                              //         bottomTitles: AxisTitles(
                              //           drawBelowEverything: true,
                              //           sideTitles: SideTitles(
                              //               getTitlesWidget: (value, meta) {
                              //                 return Text(
                              //                   value.toString(),
                              //                   style: min_cap.copyWith(
                              //                       color: text),
                              //                   textAlign: TextAlign.center,
                              //                 );
                              //               },
                              //               showTitles: true,
                              //               reservedSize: 48),
                              //         ),
                              //         topTitles: AxisTitles(),
                              //         rightTitles: AxisTitles(),
                              //       ),
                              //     )),
                              //   ),
                              // ),

                              // if (!(_account?.is_premium ?? false))
                              //   Positioned.fill(
                              //     child: BackdropFilter(
                              //       filter:
                              //           ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              //       child: GestureDetector(
                              //         onTap: () => {
                              //           showPremiumDialog(context, _account!,
                              //               widget.fetchAccount),
                              //         },
                              //         child: Container(
                              //           color: theme.colorScheme.onSecondary
                              //               .withOpacity(0.8),
                              //           child: Center(
                              //             child: Column(
                              //               mainAxisAlignment:
                              //                   MainAxisAlignment.center,
                              //               children: [
                              //                 Icon(
                              //                   Icons.lock_outline,
                              //                   color:
                              //                       theme.colorScheme.onPrimary,
                              //                   size: 40,
                              //                 ),
                              //                 SizedBox(height: 8),
                              //                 Text(
                              //                   trans.premiumFeature,
                              //                   style: h2.copyWith(
                              //                       color: theme
                              //                           .colorScheme.onPrimary),
                              //                 ),
                              //               ],
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                            ],
                          ),
                        ),

                        const SizedBox(
                            height: 20.0), // Added space for better layout
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
                                      _logout();
                                    },
                                    borderRadius: BorderRadius.circular(44.0),
                                    child: Center(
                                      child: Text(trans.logout,
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
              ));
  }
}

Widget _buildLineChart(List<FlSpot> data) {
  return LineChart(
    LineChartData(
      // ... (Your chart configuration here - adjust as needed)
      lineBarsData: [
        LineChartBarData(
          spots: data,
          isCurved: true,
          dotData: FlDotData(show: false), // Remove dots for this example
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                Colors.blue.withOpacity(0.2),
                Colors.blue.withOpacity(0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    ),
  );
}

// Widget dùng chung cho Calorie, Social và Personalized Exercise
class InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const InfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      // InkWell bao toàn bộ container
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.0), // Bo góc cho InkWell
      child: Container(
        padding: const EdgeInsets.all(8.0),
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
            Icon(
              icon,
              size: 20,
              color: stroke,
            ),
            // Image.asset(
            //   icon,
            //   width: 20,
            //   height: 20,
            // ),
          ],
        ),
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
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.valueColor,
    this.isTitleFirst = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.0), // Bo góc cho InkWell
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(16.0), // Bo góc cho Container (tùy chọn)
        ),
        child: Row(
          children: isTitleFirst
              ? [
                  Text(
                    title,
                    style: min_cap.copyWith(color: text),
                  ),
                  const SizedBox(width: 10),
                  Text(value, style: h2.copyWith(color: valueColor)),
                ]
              : [
                  Text(value, style: h2.copyWith(color: valueColor)),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: min_cap.copyWith(color: text),
                  ),
                ],
        ),
      ),
    );
  }
}
