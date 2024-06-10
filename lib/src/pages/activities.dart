import 'package:flutter/material.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';
import 'package:yogi_application/src/pages/event_detail.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/widgets/card.dart';

class Activities extends StatefulWidget {
  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  // Biến trạng thái để lưu trữ nội dung hiện tại
  bool _showRankContent = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
      bottomNavigationBar: CustomBottomBar(),
    );
  }

  Widget _buildBody(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(color: theme.colorScheme.background),
      child: Stack(
        children: [
          _buildTopRoundedContainer(),
          Positioned(
            left: 24,
            right: 24,
            top: 150,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // Show title based on current state
                  _showRankContent ? _buildRankMainTitle() : Container(),
                  const SizedBox(height: 24),
                  // Show content based on current state
                  _showRankContent
                      ? _buildRankMainContent()
                      : _buildEventMainContent(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopRoundedContainer() {
    final theme = Theme.of(context);
    return Positioned(
      left: 0,
      top: 0,
      right: 0,
      child: Container(
        height: 155,
        decoration: BoxDecoration(
          color: theme.colorScheme.onSecondary,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 24,
              bottom: 0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showRankContent = true;
                  });
                },
                child: _buildTitleContainer('Rank', _showRankContent),
              ),
            ),
            Positioned(
              right: 24,
              bottom: 0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showRankContent = false;
                  });
                },
                child: _buildTitleContainer('Event', !_showRankContent),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleContainer(String title, bool isSelected) {
    final theme = Theme.of(context);
    return Container(
      width: 185,
      height: 36,
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: isSelected ? 2.0 : 0.0,
            color: isSelected ? primary : Colors.transparent,
          ),
        ),
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: h3.copyWith(color: theme.colorScheme.onBackground),
        ),
      ),
    );
  }

  Widget _buildRankMainTitle() {
    final theme = Theme.of(context);

    return Center(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '5 days left',
              style: h2.copyWith(color: theme.colorScheme.onBackground),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankMainContent() {
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

  Widget _buildEventMainContent() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.only(top: 0.0), // Adjust the top padding as needed
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
          final title = 'Event ${index + 1}';
          final caption = 'Caption ${index + 1}';
          final subtitle = '${5 - index} days left';

          return CustomCard(
            title: title,
            caption: caption,
            subtitle: subtitle,
            onTap: () {
              Navigator.push(
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
