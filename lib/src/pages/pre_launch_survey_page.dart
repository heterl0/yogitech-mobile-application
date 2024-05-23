import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PrelaunchSurveyPage extends StatelessWidget {
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController birthday = TextEditingController();
  final TextEditingController height = TextEditingController();
  final TextEditingController weight = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF0A141C),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome to ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'yogi',
                        style: TextStyle(
                          color: Color(0xFF4095D0),
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Please fill in information here to optimize your experience',
                      style: TextStyle(
                        color: Color(0xFF8D8E99),
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  // First Name
                  Text(
                    'First Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: firstName,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0),
                      hintText: 'First name',
                      hintStyle: TextStyle(color: Color(0xFF8D8E99)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(44.0),
                        borderSide: BorderSide(color: Color(0xFF8D8E99)),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 16.0),
                  // Last Name
                  Text(
                    'Last Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: lastName,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0),
                      hintText: 'Last Name',
                      hintStyle: TextStyle(color: Color(0xFF8D8E99)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(44.0),
                        borderSide: BorderSide(color: Color(0xFF8D8E99)),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 16.0),
                  // Birthday
                  Text(
                    'Birthday',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: birthday,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0),
                      hintText: 'dd/mm/yyyy',
                      hintStyle: TextStyle(color: Color(0xFF8D8E99)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(44.0),
                        borderSide: BorderSide(color: Color(0xFF8D8E99)),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp('[^0-9/]')),
                      LengthLimitingTextInputFormatter(10),
                    ],
                    keyboardType: TextInputType.datetime,
                  ),
                  SizedBox(height: 16.0),
                  // Height
                  Text(
                    'Height(cm)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: height,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0),
                      hintText: 'e.g. 154.5',
                      hintStyle: TextStyle(color: Color(0xFF8D8E99)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(44.0),
                        borderSide: BorderSide(color: Color(0xFF8D8E99)),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d{0,3}\.?\d{0,1}$')),
                      LengthLimitingTextInputFormatter(6),
                    ],
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                  ),
                  SizedBox(height: 16.0),
                  // Weight
                  Text(
                    'Weight(kg)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: weight,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0),
                      hintText: 'e.g. 70',
                      hintStyle: TextStyle(color: Color(0xFF8D8E99)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(44.0),
                        borderSide: BorderSide(color: Color(0xFF8D8E99)),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d{1,3}$')),
                      LengthLimitingTextInputFormatter(3),
                    ],
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
            child: BottomAppBar(
              color: Color(0xFF0D1F29),
              height: 100.0,
              child: Container(
                height: 50.0,
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(44.0),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF3BE2B0),
                      Color(0xFF4095D0),
                      Color(0xFF5986CC),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      _handleLetsgo(context);
                    },
                    borderRadius: BorderRadius.circular(44.0),
                    child: Center(
                      child: Text(
                        "Let's go",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )));
  }

  void _handleLetsgo(context) {}
}
