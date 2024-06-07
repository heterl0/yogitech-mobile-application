import 'package:flutter/material.dart';
import 'package:yogi_application/src/pages/blog.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';
import 'package:yogi_application/src/custombar/appbar.dart';

class BlogDetail extends StatefulWidget {
  final String title;
  final String caption;
  final String subtitle;

  const BlogDetail(
      {Key? key,
      required this.title,
      required this.caption,
      required this.subtitle})
      : super(key: key);

  @override
  _BlogDetailState createState() => _BlogDetailState();
}

class _BlogDetailState extends State<BlogDetail> {
  get onPressed => null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: CustomAppBar(
        onBackPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Blog()),
          );
        },
        postActions: [_buildLikeButton(), _buildDislikeButton()],
      ),
      body: _buildBody(context),
      bottomNavigationBar: CustomBottomBar(),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      child: Stack(
        children: [_buildImage(), _buildMainContent(context)],
      ),
    );
  }

  Widget _buildLikeButton() {
    final theme = Theme.of(context);
    return IconButton(
      icon: Icon(
        Icons.thumb_up_outlined,
        color: theme.colorScheme.onBackground,
      ),
      onPressed: () {},
    );
  }

  Widget _buildDislikeButton() {
    final theme = Theme.of(context);
    return IconButton(
        onPressed: onPressed,
        icon: Icon(
          Icons.thumb_down_outlined,
          color: theme.colorScheme.onBackground,
        ));
  }

  Widget _buildImage() {
    return Padding(
      padding: const EdgeInsets.only(top: 100), // Adjust the value as needed
      child: Container(
        width: double.infinity,
        height: 250,
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
      padding: const EdgeInsets.only(top: 350),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildTitle(context),
              const SizedBox(height: 16),
              _buildDescription(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Ringo Island',
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
