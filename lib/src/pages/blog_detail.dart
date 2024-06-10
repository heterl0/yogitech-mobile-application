import 'package:flutter/material.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';
import 'package:yogi_application/src/custombar/appbar.dart';

class BlogDetail extends StatefulWidget {
  final String title;
  final String caption;
  final String subtitle;

  const BlogDetail({
    Key? key,
    required this.title,
    required this.caption,
    required this.subtitle,
  }) : super(key: key);

  @override
  _BlogDetailState createState() => _BlogDetailState();
}

class _BlogDetailState extends State<BlogDetail> {
  int userFeedback = 0; // 0: không có ý kiến, 1: like, 2: dislike

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        postActions: [_buildDislikeButton(), _buildLikeButton()],
      ),
      body: _buildBody(context),
      bottomNavigationBar: CustomBottomBar(),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildImage(),
          _buildMainContent(context),
        ],
      ),
    );
  }

  Widget _buildLikeButton() {
    final theme = Theme.of(context);
    return IconButton(
      icon: Icon(
        userFeedback == 1 ? Icons.thumb_up_rounded : Icons.thumb_up_outlined,
        color: userFeedback == 1 ? primary : theme.colorScheme.onBackground,
      ),
      onPressed: () {
        setState(() {
          // Khi người dùng nhấn like, cập nhật userFeedback và gọi setState để rebuild UI
          userFeedback = userFeedback != 1 ? 1 : 0;
        });
      },
    );
  }

  Widget _buildDislikeButton() {
    final theme = Theme.of(context);
    return IconButton(
      icon: Icon(
        userFeedback == 2
            ? Icons.thumb_down_alt_rounded
            : Icons.thumb_down_outlined,
        color: userFeedback == 2 ? error : theme.colorScheme.onBackground,
      ),
      onPressed: () {
        setState(() {
          // Khi người dùng nhấn dislike, cập nhật userFeedback và gọi setState để rebuild UI
          userFeedback = userFeedback != 2 ? 2 : 0;
        });
      },
    );
  }

  Widget _buildImage() {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Container(
        width: double.infinity,
        height: 360,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/yoga.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildTitle(context),
          const SizedBox(height: 16),
          _buildDescription(),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Container(
        child: Column(
          children: [
            Text(
              'Japan: Discovering the Land of the Rising Sun',
              style: h2.copyWith(color: theme.colorScheme.onPrimary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras tincidunt sollicitudin nisl, vel ornare dolor tincidunt ut. Fusce consectetur turpis feugiat tellus efficitur, id egestas dui rhoncus',
      style: min_cap.copyWith(color: text),
      textAlign: TextAlign.left,
    );
  }
}
