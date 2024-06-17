import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:yogi_application/src/custombar/appbar.dart';
import 'package:yogi_application/src/pages/event_detail.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/widgets/card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Activities extends StatefulWidget {
  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  // Biến trạng thái để lưu trữ nội dung hiện tại

  @override
  Widget build(BuildContext context) {
    final trans = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(
        title: trans.event,
        showBackButton: false,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(color: theme.colorScheme.background),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildEventMainContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildEventMainContent() {
    final trans = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 24.0, left: 24.0, right: 24.0),
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(
            horizontal: 4.0), // Add horizontal padding if needed
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(), // Enable scrolling
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 columns
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 3 / 2, // Aspect ratio of each card
        ),
        itemCount: 6, // Number of cards
        itemBuilder: (context, index) {
          final title = '${trans.event} ${index + 1}';
          final caption = 'Caption ${index + 1}';
          final subtitle = '${5 - index} ${trans.daysLeft}';

          return CustomCard(
            title: title,
            caption: caption,
            subtitle: subtitle,
            onTap: () {
              pushWithoutNavBar(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetail(
                    title: title,
                    caption: caption,
                    remainingDays: subtitle,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
