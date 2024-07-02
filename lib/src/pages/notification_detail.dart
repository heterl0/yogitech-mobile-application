import 'package:YogiTech/src/pages/camera/camera_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:YogiTech/src/models/notification.dart' as n;

import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:YogiTech/api/auth/auth_service.dart';
import 'package:YogiTech/src/custombar/appbar.dart';
import 'package:YogiTech/src/custombar/bottombar.dart';
import 'package:YogiTech/src/shared/app_colors.dart';
import 'package:YogiTech/src/shared/styles.dart';
import 'package:YogiTech/src/widgets/box_input_field.dart';
import 'package:YogiTech/src/widgets/card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:YogiTech/utils/formatting.dart';

class NotificationDetail extends StatefulWidget {
  final n.Notification? notification;

  const NotificationDetail({super.key, this.notification, });

  @override
  _NotificationDetailState createState() => _NotificationDetailState();
}

class _NotificationDetailState extends State<NotificationDetail> {
  late n.Notification? _noti;
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
          : _buildBody(context)
    );
  }

  @override
  void initState() {
    super.initState();
    _noti = widget.notification;
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
    final trans = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 140),
          _buildTitle(context),
          const SizedBox(height: 16),
          _buildRowWithText(trans, context),
          const SizedBox(height: 16),
          _buildDescription(context),
        ],
      ),
    );
  }


  Widget _buildRowWithText(AppLocalizations trans, BuildContext context) {
    final time = _noti?.time ?? 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$time',
          style: bd_text.copyWith(color: text),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            'st',
            style: bd_text.copyWith(color: primary),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    return HtmlWidget(
      _noti?.body != null? 
          _noti!.body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras tincidunt sollicitudin nisl, vel ornare dolor tincidunt ut. Fusce consectetur turpis feugiat tellus efficitur, id egestas dui rhoncus',
      textStyle: TextStyle(fontFamily: 'ReadexPro', fontSize: 16, height: 1.2),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final theme = Theme.of(context);
    return      Container(
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
              width: 70,
              height: 70,
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
                          _noti!.is_admin? 'YogiTech':
                          '${_noti!.profile.first_name} ${_noti!.profile.last_name}',
                          textAlign: TextAlign.start,
                          style: h3.copyWith(color: _noti!.is_admin? Colors.redAccent:primary),
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
                  Text(
                    _noti!.title,
                    style: h2.copyWith(color: theme.colorScheme.onPrimary),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }


}
