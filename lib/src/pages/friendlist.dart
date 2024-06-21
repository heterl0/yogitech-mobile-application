import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:YogiTech/src/custombar/appbar.dart';
import 'package:YogiTech/src/pages/friend_profile.dart';
import 'package:YogiTech/src/shared/styles.dart';
import 'package:YogiTech/src/shared/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FriendListPage extends StatefulWidget {
  final int initialTabIndex;
  const FriendListPage({super.key, required this.initialTabIndex});

  @override
  _FriendListPageState createState() => _FriendListPageState();
}

class _FriendListPageState extends State<FriendListPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2, vsync: this, initialIndex: widget.initialTabIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        style: widthStyle.Large,
        title: trans.friends,
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: primary, // Màu sắc của đường gạch chân tab được chọn
                  width: 2.0, // Độ dày của đường gạch chân tab được chọn
                ),
              ),
            ),
            unselectedLabelColor: text,
            padding: EdgeInsets.only(left: 24, right: 24, top: 16),
            tabs: [
              Tab(
                child: Text(
                  trans.following,
                  style: h3,
                ),
              ),
              Tab(
                child: Text(
                  trans.follower,
                  style: h3,
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                FriendList(
                  itemCount: 10,
                ),
                FriendList(
                  itemCount: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FriendList extends StatelessWidget {
  final int itemCount;

  const FriendList({
    super.key,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              return FriendListItem(
                name: 'Friend Name $index',
                avatarUrl: 'assets/images/gradient.jpg',
                exp: '10000',
                onTap: () {
                  pushWithoutNavBar(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FriendProfile(),
                    ),
                  );
                }, // Sử dụng hàm mặc định khi onTap là null
              );
            },
          ),
        ],
      ),
    );
  }
}

class FriendListItem extends StatelessWidget {
  final String name;
  final String exp;
  final String avatarUrl;
  final VoidCallback onTap;

  const FriendListItem({
    super.key,
    required this.name,
    required this.avatarUrl,
    required this.onTap,
    required this.exp,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12), // Thay đổi từ 8 thành 12
        padding: EdgeInsets.all(8),
        constraints: BoxConstraints(minHeight: 80),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.center, // Canh chỉnh theo trục chính của Row
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: stroke, // Màu nền của Avatar placeholder
              ),
              child: CircleAvatar(
                backgroundImage: AssetImage(avatarUrl),
              ),
            ),
            SizedBox(width: 12), // Thêm khoảng cách giữa Avatar và nội dung

            // Sử dụng một Column để hiển thị tên và EXP
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: h3.copyWith(color: theme.colorScheme.onPrimary),
                  ),
                  SizedBox(height: 4), // Thêm khoảng cách giữa tên và EXP
                  Text(
                    '$exp EXP',
                    style: min_cap.copyWith(color: text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
