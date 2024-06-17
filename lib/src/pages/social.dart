import 'package:flutter/material.dart';
import 'package:yogi_application/src/custombar/appbar.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/pages/friendlist.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class SocialPage extends StatefulWidget {
  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: CustomAppBar(
        title: "Social",
        postActions: [
          IconButton(
              icon: Icon(
                Icons.group_add_outlined,
                color: theme.colorScheme.onBackground,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FollowingPage(),
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
                itemCount: 10,
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
  final int itemCount;
  final Function()? onTap;

  const NewsFeed({
    Key? key,
    required this.itemCount,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return NewsListItem(
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

class NewsListItem extends StatelessWidget {
  final String name;
  final String exp;
  final String avatarUrl;
  final VoidCallback onTap;

  const NewsListItem({
    Key? key,
    required this.name,
    required this.avatarUrl,
    required this.onTap,
    required this.exp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
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
            width: 80,
            height: 80,
            decoration: ShapeDecoration(
              gradient: gradient,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80),
              ),
            ),
          ),
          const SizedBox(width: 8),
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
                        'Archivement',
                        textAlign: TextAlign.start,
                        style: min_cap.copyWith(color: primary),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Feb 30 2024',
                        textAlign: TextAlign.end,
                        style: min_cap.copyWith(color: text),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Your friend are broken her legs!',
                  style: h3.copyWith(color: theme.colorScheme.onPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
