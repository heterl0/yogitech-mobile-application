import 'package:flutter/material.dart';

class exerciseDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A141C),
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: _buildBody(context),
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
          _buildMainContent(),
          _buildNavigationBar(),
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
          top: 110,
          child: Text(
            'Exercise detail',
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
          left: 15,
          top: 92,
          child: _buildBackButton(context),
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
        Navigator.pop(context);
      },
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

  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.only(top: 350),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildTitle('Ringo Island', 24, FontWeight.w700, Colors.white),
              const SizedBox(height: 16),
              _buildRowWithText(),
              const SizedBox(height: 16),
              _buildDescription(),
              const SizedBox(height: 16),
              _buildTitle('Poses', 16, FontWeight.w600, Colors.white),
              const SizedBox(height: 16),
              _buildPoses(),
              const SizedBox(height: 16),
              _buildTitle('Comment', 16, FontWeight.w600, Colors.white),
              const SizedBox(height: 16),
              _buildCommentSection(),
              const SizedBox(height: 16),
              _buildUserComment(),
              const SizedBox(
                  height: 100), // Provide space for the navigation bar
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(
      String text, double fontSize, FontWeight fontWeight, Color color) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontFamily: 'Readex Pro',
          fontWeight: fontWeight,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildRowWithText() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '10 mins',
          style: TextStyle(
            color: Color(0xFF8D8E99),
            fontSize: 12,
            fontFamily: 'Readex Pro',
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            'Beginner',
            style: TextStyle(
              color: Color(0xFF4094CF),
              fontSize: 12,
              fontFamily: 'Readex Pro',
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ),
      ],
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

  Widget _buildPoses() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildPoseCard(),
        _buildPoseCard(),
      ],
    );
  }

  Widget _buildPoseCard() {
    return Container(
      width: 170,
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
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Planking',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'Readex Pro',
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Planking',
                style: TextStyle(
                  color: Color(0xFF8D8E99),
                  fontSize: 10,
                  fontFamily: 'Readex Pro',
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              Text(
                '5 secs',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color(0xFF4094CF),
                  fontSize: 10,
                  fontFamily: 'Readex Pro',
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommentSection() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: ShapeDecoration(
              color: Color(0xFF09141C),
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: Color(0x7FA4B7BD)),
                borderRadius: BorderRadius.circular(44),
              ),
            ),
            child: TextField(
              style: TextStyle(
                color: Color(0xFF8D8E99),
                fontSize: 16,
                fontFamily: 'Readex Pro',
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Your comment',
                hintStyle: TextStyle(color: Color(0xFF8D8E99)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 36,
          height: 36,
          child: Image.asset('assets/icons/send.png'),
        ),
      ],
    );
  }

  Widget _buildUserComment() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 10),
            decoration: ShapeDecoration(
              color: Color(0xFF09141C),
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: Color(0x7FA4B7BD)),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
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
                      borderRadius: BorderRadius.circular(80),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                'Chinhphu',
                                style: TextStyle(
                                  color: Color(0xFF4094CF),
                                  fontSize: 10,
                                  fontFamily: 'Readex Pro',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 52),
                              child: Row(
                                children: [
                                  Text(
                                    'Feb 30 2024',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Color(0xFF8D8E99),
                                      fontSize: 10,
                                      fontFamily: 'Readex Pro',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Padding(
                                    padding: EdgeInsets.only(top: 2),
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      child: Image.asset(
                                        'assets/icons/favorite.png',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'This exercise is too hard to do!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'Readex Pro',
                            fontWeight: FontWeight.w400,
                            height: 1.5,
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
    );
  }

  Widget _buildNavigationBar() {
    return Positioned(
      left: 0,
      bottom: 0,
      right: 0,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Color(0xFF0D1F29),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Center(
              child: _buildExerciseButton(),
            )),
      ),
    );
  }

  Widget _buildExerciseButton() {
    return Container(
      width: 324,
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.91, -0.41),
          end: Alignment(-0.91, 0.41),
          colors: [Color(0xFF3BE2B0), Color(0xFF4095D0), Color(0xFF5986CC)],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(44),
        ),
      ),
      child: Center(
        child: Text(
          'Do exercise',
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
    );
  }
}
