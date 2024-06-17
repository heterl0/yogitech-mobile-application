import 'package:flutter/material.dart';
import 'package:yogi_application/src/custombar/appbar.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class FriendsPage extends StatelessWidget {
  final ScrollController _controller = ScrollController(); // ScrollController

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: CustomAppBar(
        title: 'Friends',
      ),
      body: SingleChildScrollView(
        controller: _controller, // Gán ScrollController
        child: Container(
          margin: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              FriendList(
                title: 'Following',
                itemCount: 10,
                onTap: () {
                  _controller.animateTo(
                    MediaQuery.of(context).size.height,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
              ),
              SizedBox(height: 16),
              FriendList(
                title: 'Follower',
                itemCount: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FriendList extends StatelessWidget {
  final String title;
  final int itemCount;
  final Function()? onTap;

  const FriendList({
    Key? key,
    required this.title,
    required this.itemCount,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: h2.copyWith(color: theme.colorScheme.onBackground),
        ),
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
              onTap: onTap != null
                  ? () => onTap!()
                  : () {}, // Sử dụng hàm mặc định khi onTap là null
            );
          },
        ),
      ],
    );
  }
}

class FriendListItem extends StatelessWidget {
  final String name;
  final String exp;
  final String avatarUrl;
  final VoidCallback onTap;

  const FriendListItem({
    Key? key,
    required this.name,
    required this.avatarUrl,
    required this.onTap,
    required this.exp,
  }) : super(key: key);

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
