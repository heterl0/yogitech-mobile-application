import 'package:flutter/material.dart';
import 'package:yogi_application/src/pages/blog.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';

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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _buildBody(context),
        bottomNavigationBar: CustomBottomBar(),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(color: Color(0xFF0A141C)),
      child: Stack(
        children: [
          _buildImage(),
          _buildTopRoundedContainer(),
          _buildTitleText(context),
          _buildMainContent(context)
        ],
      ),
    );
  }

  Widget _buildTopRoundedContainer() {
    return Positioned(
      left: 0,
      top: 0,
      right: 0,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: Color(0xFF0D1F29),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleText(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: 15,
          top: 92,
          child: _buildBackButton(context),
        ),
        Positioned(
          right: 20, // Place like and dislike buttons on the right
          top: 100,
          child: Row(
            children: [
              _buildLikeButton(),
              SizedBox(width: 20),
              _buildDislikeButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      icon: Image.asset(
        'assets/icons/arrow_back.png',
        color: Colors.white.withOpacity(1),
        width: 30,
        height: 30,
      ),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Blog()),
        );
      },
    );
  }

  Widget _buildLikeButton() {
    return Container(
      width: 27,
      height: 27,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/icons/thumb_down.png'),
        ),
      ),
    );
  }

  Widget _buildDislikeButton() {
    return Container(
      width: 27,
      height: 27,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/icons/thumb_up.png'),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Padding(
      padding: const EdgeInsets.only(top: 100), // Adjust the value as needed
      child: Container(
        width: double.infinity,
        height: 250,
        decoration: BoxDecoration(
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
              style: h2.copyWith(color: theme.colorScheme.onBackground),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras tincidunt sollicitudin nisl, vel ornare dolor tincidunt ut. Fusce consectetur turpis feugiat tellus efficitur, id egestas dui rhoncus',
      style: min_cap.copyWith(color: active),
    );
  }
}
