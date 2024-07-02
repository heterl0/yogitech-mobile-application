// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:YogiTech/api/social/social_service.dart';
import 'package:YogiTech/src/models/notification.dart' as n;
import 'package:YogiTech/src/custombar/appbar.dart';
import 'package:YogiTech/src/models/account.dart';
import 'package:YogiTech/src/pages/friend_profile.dart';
import 'package:YogiTech/src/pages/friendlist.dart';
import 'package:YogiTech/src/pages/notification_detail.dart';
import 'package:YogiTech/src/pages/notifications.dart';
import 'package:YogiTech/src/shared/app_colors.dart';
import 'package:YogiTech/src/shared/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../api/notification/notification_service.dart';

class SocialPage extends StatefulWidget {
  final VoidCallback? onProfileUpdated;
  final Account? account;

  const SocialPage({
    Key? key,
    this.onProfileUpdated,
    required this.account,
  }) : super(key: key);

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  List<n.Notification>? _notifications = [];
  Account? _account; 

  @override
  void initState() {
    super.initState();
    fetchNotification();
    _account = widget.account;
  }

  Future<void> fetchNotification() async {
    try {
      final notifications = await getNotifications();
      if (notifications != null) {
        setState(() {
          _notifications = notifications.cast<n.Notification>();
        });
      } else {
        setState(() {
          _notifications = [];
        });
      }
    } catch (e) {
      // Handle any errors here
      setState(() {
        _notifications = [];
      });
    }
  }

    Future<void> unFollow(int id) async {
    try {
      final account = await unfollowUser(id);

      if (widget.onProfileUpdated != null) {
        widget.onProfileUpdated!();
      }
      if (account != null) {
        setState(() {
          _account = account;
        });
      }
      fetchNotification();
    } catch (e) {
      print('Error unfollowing: $e');
    }
  }

  Future<void> followUserByUserId(int id) async {
    try {
      final account = await followUser(id);
      if (widget.onProfileUpdated != null) {
        widget.onProfileUpdated!();
      }
      if (account != null) {
        setState(() {
        _account = account;
        });
      }
      fetchNotification();
    } catch (e) {
      print('Error following: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        title: trans.social,
        style: widthStyle.Large,
        postActions: [
          IconButton(
              icon: Icon(
                Icons.group_outlined,
                color: theme.colorScheme.onSurface,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FriendListPage(
                          initialTabIndex: 0,
                          account: _account,
                          onProfileUpdated: widget.onProfileUpdated),
                    ));
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              NewsFeed(
                notifications: _notifications,
                account: _account,
                unFollow: unFollow,
                followUserByUserId: followUserByUserId,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewsFeed extends StatelessWidget {
  final List<n.Notification>? notifications;
  final Function()? onTap;
  final Account? account;
  final void Function(int id)? unFollow;
  final void Function(int id)? followUserByUserId;


  const NewsFeed({
    super.key,
    this.onTap,
    required this.notifications, this.account, this.unFollow, this.followUserByUserId,
  });

  @override
  Widget build(BuildContext context) {
    final trans = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: notifications?.length ?? 0,
          itemBuilder: (context, index) {
            return NewsListItem(
              notification: notifications![index],
              onTap:(){
                  // Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) => FriendProfile(
                  //               profile: notifications![index].profile,
                  //               account: account,
                  //               unFollow: unFollow,
                  //               followUserByUserId: followUserByUserId,
                  //             ),
                  //           ),
                  //         );
                  Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotificationDetail(notification: notifications![index]),
                            ),
                          );
              },
            );
          },
        ),
      ],
    );
  }
}

class NewsListItem extends StatelessWidget {
  final n.Notification notification;
  final VoidCallback onTap;
  

  const NewsListItem({
    super.key,
    required this.onTap,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;

    return 
    GestureDetector(
      onTap: onTap,
      child: 
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: stroke),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: ShapeDecoration(
                gradient: gradient,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          textAlign: TextAlign.start,
                          style: min_cap.copyWith(color: primary),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          notification.time,
                          textAlign: TextAlign.end,
                          style: min_cap.copyWith(color: text),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    notification.body,
                    style: h3.copyWith(color: theme.colorScheme.onPrimary),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
      );
  }
}
