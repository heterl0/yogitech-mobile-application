import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:yogi_application/api/account/account_service.dart';
import 'package:yogi_application/api/auth/auth_service.dart';
import 'package:yogi_application/src/custombar/appbar.dart';
import 'package:yogi_application/src/models/account.dart';
import 'package:yogi_application/src/pages/change_profile.dart';
import 'package:yogi_application/src/pages/calorie.dart';
import 'package:yogi_application/src/pages/social.dart';
import 'package:yogi_application/src/routing/app_routes.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/pages/personalized_exercise.dart';
import 'package:yogi_application/src/pages/settings.dart';
import 'package:yogi_application/src/pages/friendlist.dart';
import 'package:yogi_application/src/pages/change_BMI.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final Locale locale;
  final ValueChanged<bool> onLanguageChanged;
  final bool isVietnamese;

  ProfilePage(
      {required this.isDarkMode,
      required this.onThemeChanged,
      required this.locale,
      required this.onLanguageChanged,
      required this.isVietnamese});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Profile? _profile;
  Account? _account;

  Future<void> _logout() async {
    try {
      // Xóa token từ SharedPreferences khi người dùng logout
      await clearToken();

      // Chuyển hướng đến trang đăng nhập và xóa tất cả các route cũ
      Navigator.of(context, rootNavigator: false).pushNamedAndRemoveUntil(
          AppRoutes.login, (Route<dynamic> route) => false);
    } catch (e) {
      print('Logout error: $e');
      // Xử lý lỗi khi logout
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    Profile? profile = await getUserProfile();
    print(profile);
    Account? account = await retrieveAccount();
    print(account);
    // Cập nhật trạng thái với danh sách bài tập mới nhận được từ API
    setState(() {
      _profile = profile;
      _account = account;
      String _avatarText =
          (_profile?.last_name ?? '') + (_profile?.first_name ?? '');
      if (_profile!.avatar_url == null || _profile!.avatar_url!.isEmpty) {
        _avatarText = _profile!.first_name!.substring(0, 1).toUpperCase();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    return Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: CustomAppBar(
          showBackButton: false,
          title: trans.profile,
          postActions: [
            IconButton(
                icon: Icon(
                  Icons.settings_outlined,
                  color: theme.colorScheme.onBackground,
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
                      ),
                    ),
                  );
                })
          ],
          preActions: [
            IconButton(
              icon: Icon(
                Icons.ios_share,
                color: theme.colorScheme.onBackground,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: SafeArea(
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
                          ? 'Name'
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
                                builder: (context) =>
                                    ChangeProfilePage()), // Thay NewPage() bằng trang bạn muốn chuyển tới
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 144, // 2 * radius + 8 (border width) * 2
                              height:
                                  144, // Đã sửa lại thành 144 cho khớp tỉ lệ so với Figma
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: _profile != null &&
                                      (_profile!.avatar_url != null &&
                                          _profile!.avatar_url!.isNotEmpty)
                                  ? CircleAvatar(
                                      radius: 50,
                                      backgroundImage:
                                          NetworkImage(_profile!.avatar_url!),
                                    )
                                  : Center(
                                      child: _profile != null &&
                                              (_profile!.avatar_url != null &&
                                                  _profile!
                                                      .avatar_url!.isNotEmpty)
                                          ? CircleAvatar(
                                              radius: 50,
                                              backgroundImage: NetworkImage(
                                                  _profile!.avatar_url!),
                                            )
                                          : Center(
                                              child: Container(
                                                width: 144,
                                                height: 144,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors
                                                      .grey, // Màu nền của hình tròn
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    (_account?.username ?? '')
                                                            .isNotEmpty
                                                        ? (_account!.username[0]
                                                            .toUpperCase())
                                                        : '',
                                                    style: TextStyle(
                                                      fontSize: 40,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors
                                                          .white, // Màu chữ
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
                              style: h3.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
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
                              title: 'Calorie',
                              subtitle: trans.totalCalories,
                              iconPath: 'assets/icons/info.png',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Calorie(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 6),
                            InfoCard(
                              title: trans.social,
                              subtitle: trans.yourFriends,
                              iconPath: 'assets/icons/diversity_2.png',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SocialPage(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 6),
                            InfoCard(
                              title: trans.personalizedExercise,
                              subtitle: trans.customizeExercise,
                              iconPath: 'assets/icons/tune_setting.png',
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
                              value: _account?.following.length.toString() ??
                                  '0', // Replace with API data
                              valueColor: theme.colorScheme.onPrimary,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FollowingPage(),
                                  ),
                                );
                              },
                            ),
                            StatCard(
                              title: trans.follower,
                              value: _account?.following.length.toString() ??
                                  '', // Replace with API data
                              valueColor: theme.colorScheme.onPrimary,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FollowerPage(),
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
                                    builder: (context) => ChangeBMIPage(),
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
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(0.0),
                          height: 160,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF8D8E99)),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0), // Added space for better layout
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
            Image.asset(
              iconPath,
              width: 20,
              height: 20,
            ),
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

  StatCard({
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
