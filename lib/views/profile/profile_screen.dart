import 'package:YogiTech/services/account/account_service.dart';
import 'package:YogiTech/shared/premium_dialog.dart';
import 'package:YogiTech/viewmodels/auth/auth_viewmodel.dart';
import 'package:YogiTech/widgets/infor_card_component.dart';
import 'package:YogiTech/widgets/stat_card_component.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:share_plus/share_plus.dart';
import 'package:YogiTech/custombar/appbar.dart';
import 'package:YogiTech/models/account.dart';
import 'package:YogiTech/views/profile/change_profile_screen.dart';
import 'package:YogiTech/views/social/social.dart';
import 'package:YogiTech/shared/styles.dart';
import 'package:YogiTech/shared/app_colors.dart';
import 'package:YogiTech/views/settings/settings_screen.dart';
import 'package:YogiTech/views/social/friendlist.dart';
import 'package:YogiTech/views/profile/change_BMI_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:ui';
import 'package:provider/provider.dart';

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
  bool _isChartDataLoading = true; // Flag to indicate chart data loading

  List<FlSpot> expDataPoints = [];
  List<FlSpot> pointDataPoints = [];
  List<FlSpot> caloriesDataPoints = [];
  late DateTime _startDate;

  void refreshProfile() {
    // Gọi API để lấy lại dữ liệu hồ sơ sau khi cập nhật BMI
    widget.fetchAccount?.call();
    _fetchUserProfile();
  }

  DateTime parseDate(String dateStr) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    return dateFormat.parse(dateStr);
  }

  Future<void> _fetchSevenRecentDays() async {
    final data = await getSevenRecentDays();
    print('Dữ liệu lấy về là ${data}');
    if (data != null && data is List) {
      setState(() {
        final DateTime startDate = parseDate(
            data.first['date']); // Ngày gốc là ngày đầu tiên trong dữ liệu

        expDataPoints = data.map((item) {
          final currentDate = parseDate(item['date']);
          final int daysSinceStart = currentDate.difference(startDate).inDays;

          return FlSpot(
            daysSinceStart.toDouble(),
            item['total_exp'].toDouble(),
          );
        }).toList();

        pointDataPoints = data.map((item) {
          final currentDate = parseDate(item['date']);
          final int daysSinceStart = currentDate.difference(startDate).inDays;

          return FlSpot(
            daysSinceStart.toDouble(),
            item['total_point'].toDouble(),
          );
        }).toList();

        caloriesDataPoints = data.map((item) {
          final currentDate = parseDate(item['date']);
          final int daysSinceStart = currentDate.difference(startDate).inDays;

          return FlSpot(
            daysSinceStart.toDouble(),
            item['total_calories'].toDouble(),
          );
        }).toList();
        _startDate = startDate;
        print('EXP: ${expDataPoints}');
        print('Point: ${pointDataPoints}');
        print('Calories: ${caloriesDataPoints}');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchUserProfile();
    _fetchSevenRecentDays().then((_) {
      setState(() {
        _isChartDataLoading =
            false; // Data is loaded, stop showing the indicator
      });
    });
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
      print(
          'Account from widget: $_account'); // Thêm print để kiểm tra _account
      print('Profile from account: $_profile');
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
            ? Center(
                child: CircularProgressIndicator(
                color: (!(_account?.is_premium ?? false)) ? primary : primary2,
              ))
            : SafeArea(
                child: RefreshIndicator(
                  color:
                      (!(_account?.is_premium ?? false)) ? primary : primary2,
                  backgroundColor: theme.colorScheme.onSecondary,

                  // Bọc SingleChildScrollView bằng RefreshIndicator
                  onRefresh: () async {
                    // Gọi hàm để refresh dữ liệu ở đây
                    _fetchUserProfile();
                    _fetchSevenRecentDays();
                    widget.fetchAccount?.call();
                  },
                  child: SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) {
                              return (!(_account?.is_premium ?? false))
                                  ? gradient.createShader(bounds)
                                  : gradient2.createShader(bounds);
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
                                            )),
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
                                              backgroundColor:
                                                  Colors.transparent,
                                              child: _profile!.avatar_url ==
                                                      null
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
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors
                                                              .transparent,
                                                          border: Border.all(
                                                            color: (!(_account
                                                                        ?.is_premium ??
                                                                    false))
                                                                ? primary
                                                                : primary2, // Màu của border
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
                                                                  FontWeight
                                                                      .bold,
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
                                            builder: (context) =>
                                                FriendListPage(
                                              initialTabIndex: 0,
                                              account: _account,
                                              onProfileUpdated: refreshProfile,
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16)),
                                        child: Stack(
                                          children: [
                                            // InfoCard(
                                            //   title: trans.personalizedExercise,
                                            //   subtitle: trans.customizeExercise,
                                            //   icon: Icons.tune_outlined,
                                            //   onTap: () {
                                            //     Navigator.push(
                                            //       context,
                                            //       MaterialPageRoute(
                                            //         builder: (context) =>
                                            //             PersonalizedExercisePage(
                                            //           fetchAccount:
                                            //               widget.fetchAccount,
                                            //         ),
                                            //       ),
                                            //     );
                                            //   },
                                            // ),
                                            // if (!(_account?.is_premium ??
                                            //     false))
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
                                            //           color: theme.colorScheme
                                            //               .onSecondary
                                            //               .withOpacity(0.8),
                                            //           child: Center(
                                            //             child: Row(
                                            //               mainAxisAlignment:
                                            //                   MainAxisAlignment
                                            //                       .center,
                                            //               children: [
                                            //                 Icon(
                                            //                   Icons
                                            //                       .lock_outline,
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
                                      value: _account?.following.length
                                              .toString() ??
                                          '0', // Replace with API data
                                      valueColor: theme.colorScheme.onPrimary,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FriendListPage(
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
                                      value: _account?.followers.length
                                              .toString() ??
                                          '0', // Replace with API data
                                      valueColor: theme.colorScheme.onPrimary,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FriendListPage(
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
                                      valueColor:
                                          (!(_account?.is_premium ?? false))
                                              ? primary
                                              : primary2,
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
                                              profile: widget.account!.profile,
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
                                  labelColor: (!(_account?.is_premium ?? false))
                                      ? primary
                                      : primary2,
                                  dividerColor: Colors.transparent,
                                  controller: _tabController,
                                  indicator: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color:
                                            (!(_account?.is_premium ?? false))
                                                ? primary
                                                : primary2,
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
                                  padding: EdgeInsets.only(top: 60),
                                  height: 320,
                                  child: _isChartDataLoading
                                      ? Center(
                                          child: CircularProgressIndicator(
                                          color:
                                              ((_account?.is_premium ?? false))
                                                  ? primary
                                                  : primary2,
                                        ))
                                      : TabBarView(
                                          controller: _tabController,
                                          children: [
                                            _buildLineChart(expDataPoints,
                                                trans.days, 'EXP', _startDate),
                                            _buildLineChart(
                                                pointDataPoints,
                                                trans.days,
                                                trans.point,
                                                _startDate),
                                            _buildLineChart(
                                                caloriesDataPoints,
                                                trans.days,
                                                trans.calorie,
                                                _startDate),
                                          ],
                                        ),
                                ),
                                if ((_account?.is_premium ?? false))
                                  Positioned.fill(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 5, sigmaY: 5),
                                      child: GestureDetector(
                                        onTap: () => {
                                          showPremiumDialog(context, _account!,
                                              widget.fetchAccount),
                                        },
                                        child: Container(
                                          color: theme.colorScheme.onSecondary
                                              .withOpacity(0.8),
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.lock_outline,
                                                  color: theme
                                                      .colorScheme.onPrimary,
                                                  size: 40,
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  trans.premiumFeature,
                                                  style: h2.copyWith(
                                                      color: theme.colorScheme
                                                          .onPrimary),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
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
                                    border:
                                        Border.all(color: error, width: 2.0),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        Provider.of<AuthViewModel>(context,
                                                listen: false)
                                            .logout(context);
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
                ),
              ));
  }
}

Widget _buildLineChart(
  List<FlSpot> data,
  String xLabel,
  String yLabel,
  DateTime startDate,
) {
  return LineChart(
    LineChartData(
      borderData: FlBorderData(show: false),
      minX: data.first.x,
      maxX: data.last.x,
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          axisNameWidget: Padding(
            padding: const EdgeInsets.only(right: 0),
            child: Text(
              yLabel,
              style: min_cap.copyWith(color: text),
            ),
          ),
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toStringAsFixed(
                    1), // Hiển thị giá trị y với 1 chữ số thập phân
                style: min_cap.copyWith(color: text),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          axisNameWidget: Text(xLabel, style: min_cap.copyWith(color: text)),
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: 1, // Đảm bảo hiển thị tất cả các giá trị x
            getTitlesWidget: (value, meta) {
              // Tính toán ngày hiển thị từ số ngày đã qua
              final date = startDate.add(Duration(days: value.toInt()));
              final formattedDate = DateFormat('dd/MM').format(date);

              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  formattedDate, // Hiển thị ngày/tháng
                  style: min_cap.copyWith(color: text),
                ),
              );
            },
          ),
        ),
        topTitles: AxisTitles(
            axisNameWidget: SizedBox(
          height: 4,
        )),
        rightTitles: AxisTitles(
            axisNameWidget: SizedBox(
          width: 4,
        )),
      ),
      gridData: FlGridData(show: true),
      lineBarsData: [
        LineChartBarData(
          color: primary,
          spots: data,
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                primary.withOpacity(0.2),
                darkblue.withOpacity(0.0),
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
