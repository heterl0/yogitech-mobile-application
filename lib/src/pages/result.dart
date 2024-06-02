import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Result extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A141C),
      ),
      home: Scaffold(
        body: Center(
          child: _buildResult(), // Wrap _buildResult() with Center widget
        ),
      ),
    );
  }

  Widget _buildResult() {
    return ResultAfterPractice();
  }
}

class ResultAfterPractice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Use SingleChildScrollView to avoid overflow
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 360,
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 40), // Adjust padding
              decoration: BoxDecoration(
                color: Color(0xFF09141C),
                borderRadius: BorderRadius.circular(
                    24), // Add border radius for better UI
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Good job!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontFamily: 'Readex Pro',
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 110,
                    height: 110,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/Fire.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Accuracy: 90%',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF4094CF),
                      fontSize: 24,
                      fontFamily: 'Readex Pro',
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '+ 300 EXP',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Readex Pro',
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '+',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Readex Pro',
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 16,
                        height: 16,
                        child: Image.asset(
                          'assets/images/Emerald.png',
                        ),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '100',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Readex Pro',
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 36),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Calories burned: 9000',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'Readex Pro',
                            fontWeight: FontWeight.w400,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Duration: 1m30s',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'Readex Pro',
                            fontWeight: FontWeight.w400,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24), // Adjust spacing
                  Container(
                    width: double.infinity,
                    height: 44,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
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
                        borderRadius: BorderRadius.circular(44),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Finish',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Readex Pro',
                          fontWeight: FontWeight.w600,
                          height: 1.2,
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
    );
  }
}
