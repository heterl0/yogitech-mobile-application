import 'package:YogiTech/models/account.dart';
import 'package:YogiTech/views/friend_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:YogiTech/models/notification.dart' as n;
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:YogiTech/custombar/appbar.dart';
import 'package:YogiTech/shared/app_colors.dart';
import 'package:YogiTech/shared/styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class NotificationDetail extends StatefulWidget {
  final n.Notification? notification;
  final Account? account;
  final void Function(int id)? unFollow;
  final void Function(int id)? followUserByUserId;

  const NotificationDetail({
    super.key,
    this.notification,
    this.account,
    this.unFollow,
    this.followUserByUserId,
  });

  @override
  _NotificationDetailState createState() => _NotificationDetailState();
}

class _NotificationDetailState extends State<NotificationDetail> {
  late n.Notification? _noti;
  late Account? _account;

  late bool _isLoading = false;
  final TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final trans = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: CustomAppBar(
          title: trans.social,
          style: widthStyle.Large,
        ),
        resizeToAvoidBottomInset: true,
        body: _isLoading
            ? Container(
                color: theme.colorScheme.surface,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : _buildBody(context));
  }

  @override
  void initState() {
    super.initState();
    _noti = widget.notification;
    _account = widget.account;
    print(_noti);
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildMainContent(context),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 140),
          _buildHeader(context),
          const SizedBox(height: 16),
          _buildTitle(context),
          const SizedBox(height: 16),
          _buildDescription(context),
        ],
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return HtmlWidget(
      _noti?.body != null
          ? _noti!.body
          : 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras tincidunt sollicitudin nisl, vel ornare dolor tincidunt ut. Fusce consectetur turpis feugiat tellus efficitur, id egestas dui rhoncus',
      textStyle: TextStyle(fontFamily: 'ReadexPro', fontSize: 16, height: 1.2),
    );
  }

  Widget _buildTitle(BuildContext context) {
    Theme.of(context);

    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              _noti!.title,
              style: h2.copyWith(color: primary),
            ),
          )
        ]);
  }

  Widget _buildHeader(BuildContext context) {
    Theme.of(context);
    DateTime dateTime = DateTime.parse(_noti!.time).toUtc().toLocal();

    return GestureDetector(
        onTap: () {
          if (!_noti!.is_admin) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FriendProfile(
                  profile: _noti!.profile,
                  account: _account,
                  unFollow: widget.unFollow,
                  followUserByUserId: widget.followUserByUserId,
                ),
              ),
            );
          }
        },
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
              (!_noti!.is_admin)
                  ? ((_noti!.profile.avatar != null) &&
                          _noti!.profile.avatar != '')
                      ? Container(
                          width: 60,
                          height: 60,
                          child: CircleAvatar(
                            radius: 80,
                            backgroundImage: CachedNetworkImageProvider(
                                _noti!.profile.avatar.toString()),
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
                                _noti!.profile.first_name != null
                                    ? _noti!.profile.first_name![0]
                                        .toUpperCase()
                                    : ':)',
                                style: TextStyle(
                                  fontSize: 36, // Adjust the size as needed
                                  color: active,
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
                        Expanded(
                          child: Text(
                            '${DateFormat('HH:mm dd/MM/yyyy').format(dateTime)}',
                            textAlign: TextAlign.start,
                            style: bd_text.copyWith(color: active),
                          ),
                        ),
                        // Expanded(
                        //   child: Text(
                        //     _noti!.time,
                        //     textAlign: TextAlign.end,
                        //     style: min_cap.copyWith(color: text),
                        //   ),
                        // ),
                      ],
                    ),
                    _noti!.is_admin
                        ? ShaderMask(
                            shaderCallback: (bounds) {
                              return gradient.createShader(bounds);
                            },
                            child: Text(
                              'YogiTech',
                              style: h2.copyWith(color: active),
                            ),
                          )
                        : Text(
                            '${_noti!.profile.first_name} ${_noti!.profile.last_name}',
                            style: h2.copyWith(color: primary, fontSize: 28),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
