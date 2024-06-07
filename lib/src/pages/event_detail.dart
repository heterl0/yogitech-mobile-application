import 'package:flutter/material.dart';
import 'package:yogi_application/src/custombar/appbar.dart';
import 'package:yogi_application/src/pages/activities.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/widgets/box_button.dart';

class EventDetail extends StatelessWidget {
  final String title;
  final String caption;
  final String subtitle;

  const EventDetail(
      {Key? key,
      required this.title,
      required this.caption,
      required this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: title, // Set the title from widget parameter
        isTransparent: true, // Maintain transparency for background image
        showBackButton: false, // Disable default back button behavior
        preActions: [
          // Add back button to preActions for left placement
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: text, // Assuming 'text' is your desired color
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Activities()),
              );
            },
          ),
        ],
      ),
      backgroundColor: theme.colorScheme.background,
      resizeToAvoidBottomInset: false,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
      ),
      child: Stack(
        children: [
          _buildImage(),
          // _buildTitleText(context),
          _buildMainContent(context),
          _buildNavigationBar(context),
        ],
      ),
    );
  }

  Widget _buildTitleText(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: <Widget>[
        Positioned(
          left: 0,
          right: 0,
          top: 80,
          child: Text(
            '5 days left',
            textAlign: TextAlign.center,
            style: h3.copyWith(color: active),
          ),
        ),
        Positioned(
          right: 15,
          top: 74,
          child: _buildBackButton(context),
        ),
      ],
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      icon: Image.asset(
        'assets/icons/close.png',
        color: active,
        width: 30,
        height: 30,
      ),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Activities()),
        );
      },
    );
  }

  Widget _buildImage() {
    return Padding(
      padding: const EdgeInsets.only(top: 0), // Adjust the value as needed
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
      padding: const EdgeInsets.only(top: 250),
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
              const SizedBox(height: 16),
              _buildTitle2(context),
              const SizedBox(height: 16),
              _buildRankMainContent(context),
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
      style: TextStyle(
        color: Color(0xFF8D8E99),
        fontSize: 12,
        fontFamily: 'Readex Pro',
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
    );
  }

  Widget _buildTitle2(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      alignment: Alignment.centerLeft, // Aligns the ch // Add padding if needed
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            CrossAxisAlignment.start, // Aligns the children to the start
        children: [
          Text(
            'Leaderboard',
            style: h3.copyWith(color: theme.colorScheme.onPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildRankMainContent(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: 200,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 348,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/icons/Warranty.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 48,
                  height: 48,
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.91, -0.41),
                      end: Alignment(-0.91, 0.41),
                      colors: [
                        Color(0xFF3BE2B0),
                        Color(0xFF4095D0),
                        Color(0xFF5986CC)
                      ],
                    ),
                    shape: OvalBorder(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    child: Text(
                      '3 chân 4 cẳng',
                      style: h3.copyWith(color: theme.colorScheme.onBackground),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '20 gems',
                  textAlign: TextAlign.right,
                  style: h3.copyWith(color: primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: 348,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 28,
                  child: Text(
                    '2',
                    textAlign: TextAlign.center,
                    style: h3.copyWith(color: theme.colorScheme.onBackground),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 48,
                  height: 48,
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.91, -0.41),
                      end: Alignment(-0.91, 0.41),
                      colors: [
                        Color(0xFF3BE2B0),
                        Color(0xFF4095D0),
                        Color(0xFF5986CC)
                      ],
                    ),
                    shape: OvalBorder(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    child: Text(
                      '3 chân 4 cẳng',
                      style: h3.copyWith(color: theme.colorScheme.onBackground),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '19 gems',
                  textAlign: TextAlign.right,
                  style: h3.copyWith(color: primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: 348,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 28,
                  child: Text(
                    '3',
                    textAlign: TextAlign.center,
                    style: h3.copyWith(color: theme.colorScheme.onBackground),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 48,
                  height: 48,
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.91, -0.41),
                      end: Alignment(-0.91, 0.41),
                      colors: [
                        Color(0xFF3BE2B0),
                        Color(0xFF4095D0),
                        Color(0xFF5986CC)
                      ],
                    ),
                    shape: OvalBorder(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    child: Text(
                      '3 chân 4 cẳng',
                      style: h3.copyWith(color: theme.colorScheme.onBackground),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '1 gem',
                  textAlign: TextAlign.right,
                  style: h3.copyWith(color: primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationBar(BuildContext context) {
    final theme = Theme.of(context);
    return Positioned(
      left: 0,
      bottom: 0,
      right: 0,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: theme.colorScheme.onSecondary,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Center(
              child: _buildJoinButton(context),
            )),
      ),
    );
  }

  Widget _buildJoinButton(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: BoxButton(style: ButtonStyleType.Primary, title: 'Join in'),
    );
  }
}
