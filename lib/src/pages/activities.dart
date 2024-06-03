import 'package:flutter/material.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/shared/styles.dart';

class Activities extends StatefulWidget {
  const Activities({super.key});

  @override
  _ActivitiesState createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A141C),
      ),
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
          _buildTopRoundedContainer(),
          Positioned(
            left: 24,
            right: 24,
            top: 150,
            bottom: 0,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  _buildRankMainTitle(),
                  const SizedBox(height: 24),
                  _buildRankMainContent(),
                ],
              ),
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
        height: 155,
        decoration: BoxDecoration(
          color: Color(0xFF0D1F29),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 24, // Adjust the left position as needed
              bottom: 0, // Adjust the bottom position to lower the title
              child: _buildTitleContainer('Rank', 2),
            ),
            Positioned(
              right: 24, // Adjust the right position as needed
              bottom: 0, // Adjust the bottom position to lower the title
              child: _buildTitleContainer('Event', 0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleContainer(String title, double bottomBorderWidth) {
    final theme = Theme.of(context);
    return Container(
      width: 185,
      height: 36,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: bottomBorderWidth, color: primary),
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
        padding: EdgeInsets.symmetric(horizontal: 0),
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
    return Container(
      width: 312,
      height: 168,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 312,
            child: Row(
              mainAxisSize: MainAxisSize.min,
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
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Readex Pro',
                        fontWeight: FontWeight.w600,
                        height: 0.06,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '20 gems',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Color(0xFF4094CF),
                    fontSize: 16,
                    fontFamily: 'Readex Pro',
                    fontWeight: FontWeight.w600,
                    height: 0.06,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: 312,
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
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Readex Pro',
                      fontWeight: FontWeight.w600,
                      height: 0.06,
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
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Readex Pro',
                        fontWeight: FontWeight.w600,
                        height: 0.06,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '19 gems',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Color(0xFF4094CF),
                    fontSize: 16,
                    fontFamily: 'Readex Pro',
                    fontWeight: FontWeight.w600,
                    height: 0.06,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: 312,
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
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Readex Pro',
                      fontWeight: FontWeight.w600,
                      height: 0.06,
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
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Readex Pro',
                        fontWeight: FontWeight.w600,
                        height: 0.06,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '1 gem',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Color(0xFF4094CF),
                    fontSize: 16,
                    fontFamily: 'Readex Pro',
                    fontWeight: FontWeight.w600,
                    height: 0.06,
                  ),
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
      width: 312,
      height: 428,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150,
            padding: const EdgeInsets.all(8),
            decoration: ShapeDecoration(
              color: Color(0xFF09141C),
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: Color(0x7FA4B7BD)),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: 80,
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 28,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 16,
                        child: Text(
                          'Planking',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'Readex Pro',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: SizedBox(
                                child: Text(
                                  'Planking',
                                  style: TextStyle(
                                    color: Color(0xFF8D8E99),
                                    fontSize: 10,
                                    fontFamily: 'Readex Pro',
                                    fontWeight: FontWeight.w400,
                                    height: 0.12,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                child: Text(
                                  '5 days left',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: Color(0xFF4094CF),
                                    fontSize: 10,
                                    fontFamily: 'Readex Pro',
                                    fontWeight: FontWeight.w400,
                                    height: 0.12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 150,
            padding: const EdgeInsets.all(8),
            decoration: ShapeDecoration(
              color: Color(0xFF09141C),
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: Color(0x7FA4B7BD)),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: 80,
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 28,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 16,
                        child: Text(
                          'Planking',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'Readex Pro',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: SizedBox(
                                child: Text(
                                  'Planking',
                                  style: TextStyle(
                                    color: Color(0xFF8D8E99),
                                    fontSize: 10,
                                    fontFamily: 'Readex Pro',
                                    fontWeight: FontWeight.w400,
                                    height: 0.12,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                child: Text(
                                  '5 days left',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: Color(0xFF4094CF),
                                    fontSize: 10,
                                    fontFamily: 'Readex Pro',
                                    fontWeight: FontWeight.w400,
                                    height: 0.12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}
