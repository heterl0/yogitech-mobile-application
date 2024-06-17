import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class EventDetail extends StatelessWidget {
  final String title;
  final String caption;
  final String remainingDays;

  EventDetail(
      {super.key,
      required this.title,
      required this.caption,
      required this.remainingDays});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      // appBar: CustomAppBar(
      //   title: remainingDays,
      //   style: widthStyle.Large,
      //   isTransparent: true,
      //   postActions: [
      //     IconButton(
      //       icon: Icon(Icons.close, color: theme.colorScheme.onBackground),
      //       onPressed: () {
      //         Navigator.pop(context);
      //       },
      //     ),
      //   ],
      // ),
    backgroundColor: theme.colorScheme.background,
      // body: _buildBody(context),
      body: CustomScrollView(
        slivers: [
          _buildCustomTopBar(context),
          SliverToBoxAdapter(
            child: _buildBody(context),
          )
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        buttonTitle: trans.joinIn,
      ),
    );
  }

  Widget _buildCustomTopBar(BuildContext context) {
    final theme = Theme.of(context);
    return SliverAppBar(
      toolbarHeight: 80,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: theme.colorScheme.onBackground,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      scrolledUnderElevation: appElevation,
      elevation: appElevation,
      backgroundColor: theme.colorScheme.onSecondary,
      pinned: true,
      centerTitle: true,
      title: Text(remainingDays,
          style: h2.copyWith(color: theme.colorScheme.onBackground)),
      expandedHeight: 320,
      flexibleSpace: FlexibleSpaceBar(
        background: Image.asset(
          'assets/images/yoga.jpeg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildTitle(context),
          const SizedBox(height: 16),
          _buildDescription(),
          const SizedBox(height: 16),
          _buildTitle2(context),
          const SizedBox(height: 16),
          _buildRankMainContent(context),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Text(
        title,
        style: h2.copyWith(color: theme.colorScheme.onPrimary),
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras tincidunt sollicitudin nisl, vel ornare dolor tincidunt ut. Fusce consectetur turpis feugiat tellus efficitur, id egestas dui rhoncus Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras tincidunt sollicitudin nisl, vel ornare dolor tincidunt ut. Fusce consectetur turpis feugiat tellus efficitur, id egestas dui rhoncusLorem ipsum dolor sit amet, consectetur adipiscing elit. Cras tincidunt sollicitudin nisl, vel ornare dolor tincidunt ut. Fusce consectetur turpis feugiat tellus efficitur, id egestas dui rhoncus',
      style: bd_text.copyWith(color: text),
    );
  }

  Widget _buildTitle2(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;


    return Container(
      alignment: Alignment.centerLeft, // Aligns the ch // Add padding if needed
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            CrossAxisAlignment.start, // Aligns the children to the start
        children: [
          Text(
            trans.leaderboard,
            style: h3.copyWith(color: theme.colorScheme.onPrimary),
          ),
        ],
      ),
    );
  }

  final List<RankItem> rankItems = [
    RankItem(title: '3 chân 4 cẳng', gems: '20 gems'),
    RankItem(title: '3 chân 4 cẳng', gems: '19 gems'),
    RankItem(title: '3 chân 4 cẳng', gems: '1 gem'),
    RankItem(title: '3 chân 4 cẳng', gems: '20 gems'),
    RankItem(title: '3 chân 4 cẳng', gems: '19 gems'),
    RankItem(title: '3 chân 4 cẳng', gems: '1 gem'),
    RankItem(title: '3 chân 4 cẳng', gems: '20 gems'),
    RankItem(title: '3 chân 4 cẳng', gems: '19 gems'),
    RankItem(title: '3 chân 4 cẳng', gems: '1 gem'),
    RankItem(title: '3 chân 4 cẳng', gems: '20 gems'),
    RankItem(title: '3 chân 4 cẳng', gems: '19 gems'),
    RankItem(title: '3 chân 4 cẳng', gems: '1 gem'),
  ];

  Widget _buildRankMainContent(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: rankItems.asMap().entries.map((entry) {
          int index = entry.key;
          RankItem item = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: SizedBox(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 28,
                    height: 28,
                    child: index == 0
                        ? Image.asset('assets/icons/Warranty.png',
                            fit: BoxFit.fill)
                        : Center(
                            child: Text(
                              (index + 1).toString(),
                              textAlign: TextAlign.center,
                              style: h3.copyWith(
                                  color: theme.colorScheme.onBackground),
                            ),
                          ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const ShapeDecoration(
                      gradient: gradient,
                      shape: OvalBorder(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      child: Text(
                        item.title,
                        style:
                            h3.copyWith(color: theme.colorScheme.onBackground),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.gems,
                    textAlign: TextAlign.right,
                    style: h3.copyWith(color: primary),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class RankItem {
  final String title;
  final String gems;

  RankItem({
    required this.title,
    required this.gems,
  });
}
