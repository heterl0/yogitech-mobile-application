import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:yogi_application/src/pages/perform_meditate.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(
    home: Meditate(),
  ));
}

class Meditate extends StatefulWidget {
  @override
  _MeditateState createState() => _MeditateState();
}

class _MeditateState extends State<Meditate> {
  bool _isChecked1 = false;
  bool _isChecked2 = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _selectedDuration = Duration();

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(color: Color(0xFF09141C)),
      child: Stack(
        children: [
          _buildTopRoundedContainer(),
          _buildTitleText(),
          _buildNavigationBar(),
          _buildMainContent(),
          _buildElevatedButton(),
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
        height: 120,
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

  Widget _buildTitleText() {
    return Positioned(
      left: 0,
      right: 0,
      top: 78,
      child: Text(
        'Meditate',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontFamily: 'Readex Pro',
          fontWeight: FontWeight.w700,
          height: 1.2,
        ),
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
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: Container(
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0xFF0D1F29),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 24,
              top: 12,
              right: 24,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNavItem(
                      label: 'Home',
                      icon: 'assets/icons/grid_view.png',
                      isSelected: false,
                    ),
                    _buildNavItem(
                      label: 'Blog',
                      icon: 'assets/icons/newsmode.png',
                      isSelected: false,
                    ),
                    _buildNavItem(
                      label: 'Activities',
                      icon: 'assets/icons/exercise.png',
                      isSelected: false,
                    ),
                    _buildNavItem(
                      label: 'Meditate',
                      icon: 'assets/icons/self_improvement.png',
                      isSelected: true,
                    ),
                    _buildNavItem(
                      label: 'Profile',
                      icon: 'assets/icons/account_circle.png',
                      isSelected: false,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String label,
    required String icon,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        print('Navigated to $label');
      },
      child: Column(
        children: [
          Image.asset(
            icon,
            color: isSelected ? Color(0xFF4094CF) : Color(0xFF8D8E99),
            width: 24,
            height: 24,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Color(0xFF4094CF) : Color(0xFF8D8E99),
              fontSize: 10,
              fontFamily: 'Readex Pro',
              fontWeight: FontWeight.w400,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Positioned(
      left: 24,
      top: 150,
      right: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Color.fromARGB(255, 13, 33, 44), // Đặt màu nền trực tiếp
            child: CupertinoTimerPicker(
              mode: CupertinoTimerPickerMode.ms,
              initialTimerDuration: _selectedDuration,
              onTimerDurationChanged: (Duration newDuration) {
                setState(() {
                  _selectedDuration = Duration(
                    minutes: min(newDuration.inMinutes, 60),
                    seconds: min(newDuration.inSeconds % 60, 60),
                  );
                });
              },
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Sounds',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Readex Pro',
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
          SizedBox(height: 16),
          _buildCheckboxItem(
            title: 'Sound of rain',
            subtitle: 'Deep sound on rainy days',
            value: _isChecked1,
            onChanged: (value) {
              setState(() {
                _isChecked1 = value!;
                if (value) _isChecked2 = false;
              });
            },
          ),
          SizedBox(height: 16),
          _buildCheckboxItem(
            title: 'The sound of the stream flowing',
            subtitle: 'Immersing yourself in the refreshing nature',
            value: _isChecked2,
            onChanged: (value) {
              setState(() {
                _isChecked2 = value!;
                if (value) _isChecked1 = false;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxItem({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Container(
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.transparent,
            checkColor: Colors.white,
            side: MaterialStateBorderSide.resolveWith(
              (states) => BorderSide(
                color: Colors.white, // Outline color
                width: 2,
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Readex Pro',
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Color(0xFF8D8E99),
                    fontSize: 10,
                    fontFamily: 'Readex Pro',
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildElevatedButton() {
    return Positioned(
      right: 27,
      top: 650,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          padding: MaterialStateProperty.all(EdgeInsets.all(0)),
          shape: MaterialStateProperty.all(CircleBorder()),
        ),
        onPressed: () {
          if (_isChecked1) {
            _audioPlayer.play(AssetSource('assets/audios/rain.mp3'));
          } else if (_isChecked2) {
            _audioPlayer.play(AssetSource('assets/audios/tieng_suoi.mp3'));
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  PerformMeditate(selectedDuration: _selectedDuration),
            ),
          );
        },
        child: Ink(
          decoration: BoxDecoration(
            color: Color(0xFF4094CF),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Container(
            width: 67,
            height: 67,
            alignment: Alignment.center,
            child: Image.asset(
              'assets/icons/play_arrow.png',
              width: 24,
              height: 24,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
