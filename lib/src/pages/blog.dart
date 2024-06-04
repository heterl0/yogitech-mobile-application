import 'package:flutter/material.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/widgets/card.dart';

class Blog extends StatefulWidget {
  const Blog({super.key});

  @override
  _BlogState createState() => _BlogState();
}

class _BlogState extends State<Blog> {
  bool _showRankContent = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
      bottomNavigationBar: CustomBottomBar(),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(color: Color(0xFF0A141C)),
      child: Stack(
        children: [
          _buildTopRoundedContainer(),
          _buildTitleText(context),
          Positioned.fill(
            child: SingleChildScrollView(
              child: _buildBLogMainContent(),
            ),
          ),
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
          left: 0,
          right: 0,
          top: 100,
          child: Text(
            'Blog',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontFamily: 'Readex Pro',
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
        ),
        Positioned(
          right: 15,
          top: 92,
          child: _buildCloseButton(context),
        ),
      ],
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return IconButton(
      icon: Image.asset(
        'assets/icons/search.png',
        color: Colors.white.withOpacity(1),
        width: 30,
        height: 30,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Widget _buildBLogMainContent() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.only(top: 170.0), // Adjust the top padding as needed
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(
            horizontal: 16.0), // Add horizontal padding if needed
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
          final title = 'Event ${index + 1}';
          final caption = 'Caption ${index + 1}';
          final subtitle = '${5 - index} days left';

          return GestureDetector(
            onTap: () {
              // Implement navigation to detail page if needed
            },
            child: CustomCard(
              title: title,
              caption: caption,
              subtitle: subtitle,
            ),
          );
        },
      ),
    );
  }
}
