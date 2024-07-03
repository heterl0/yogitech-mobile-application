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
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timeago/timeago.dart' as timeago;

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
          _notifications!.sort((a, b) => b.time.compareTo(a.time));
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
    required this.notifications,
    this.account,
    this.unFollow,
    this.followUserByUserId,
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
              onTap: () {
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
                    builder: (context) => NotificationDetail(
                        notification: notifications![index],
                        account: account,
                        unFollow: unFollow,
                        followUserByUserId: followUserByUserId),
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
    DateTime dateTime = DateTime.parse(notification.time);
    timeago.setLocaleMessages(trans.locale,
        trans.locale == 'vi' ? timeago.ViMessages() : timeago.EnMessages());
    // trans.locale == 'vi'? timeago.ViMessages():timeago.EnMessages();

    return GestureDetector(
        onTap: onTap,
        child: Container(
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
              (!notification.is_admin)
                  ? ((notification.profile.avatar != null) &&
                          notification.profile.avatar != '')
                      ? Container(
                          width: 60,
                          height: 60,
                          child: CircleAvatar(
                            radius: 80,
                            backgroundImage: CachedNetworkImageProvider(
                                notification.profile.avatar.toString()),
                            backgroundColor: Colors.transparent,
                          ))
                      : Container(
                          width: 60, // 2 * radius + 8 (border width) * 2
                          height: 60, // Matching the ratio as per Figma
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 78,
                            backgroundImage:
                                AssetImage('assets/images/gradient.jpg'),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                notification.profile.first_name != null
                                  ? notification.profile.first_name![0].toUpperCase()
                                  : ':)',
                                style: TextStyle(
                                  fontSize: 36, // Adjust the size as needed
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                  : Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        border: Border.all(
                          color: Colors.blue, // Color of the border
                          width: 1.0, // Width of the border
                        ),
                        image: DecorationImage(
                          image: AssetImage('assets/icons/yogiAvatar.png'),
                          fit: BoxFit
                              .cover, // This ensures the image covers the circle properly
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
                        notification.is_admin
                            ? Expanded(
                                child: ShaderMask(
                                shaderCallback: (bounds) {
                                  return gradient.createShader(bounds);
                                },
                                child: Text(
                                  'YogiTech',
                                  style: min_cap.copyWith(color: active),
                                ),
                              ))
                            : Expanded(
                                child: Text(
                                  '${notification.profile.first_name} ${notification.profile.last_name}',
                                  textAlign: TextAlign.start,
                                  style: min_cap.copyWith(color: primary),
                                ),
                              ),
                        Expanded(
                          child: Text(
                            timeago.format(dateTime, locale: trans.locale),
                            textAlign: TextAlign.end,
                            style: min_cap.copyWith(color: text),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification.title,
                      style: h3.copyWith(color: theme.colorScheme.onPrimary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
