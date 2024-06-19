import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:yogi_application/src/pages/meditate.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const performMeditate());
}

class performMeditate extends StatelessWidget {
  final Duration selectedDuration;

  const performMeditate(
      {Key? key, this.selectedDuration = const Duration(minutes: 5)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MeditateCountdownTimer(initialDuration: selectedDuration),
    );
  }
}

class MeditateCountdownTimer extends StatefulWidget {
  final Duration initialDuration;

  const MeditateCountdownTimer({Key? key, required this.initialDuration})
      : super(key: key);
  @override
  _MeditateCountdownTimerState createState() => _MeditateCountdownTimerState();
}

class _MeditateCountdownTimerState extends State<MeditateCountdownTimer>
    with RestorationMixin {
  late Timer _timer;
  int _start = 5;
  var _isTimerOn = false;

  late RestorableRouteFuture<String> _alertDialogRoute;

  @override
  String get restorationId => 'meditate_countdown_timer';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_alertDialogRoute, 'alert_dialog_route');
  }

  void startTimer() {
    const oneSec = Duration(minutes: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            _isTimerOn = false;
            timer.cancel();
          });
          _alertDialogRoute.present();
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void _showInSnackBar(String value) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value),
      ),
    );
  }

  static Route<String> _alertDialogDemoRoute(
    BuildContext context,
    Object? arguments,
  ) {
    final trans = AppLocalizations.of(context)!;
    return DialogRoute<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            trans.finish,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: Text(
            trans.endTimer,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                trans.confirm,
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: const Color(0xFF0A141C),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 24,
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _start = widget.initialDuration.inMinutes;
    _alertDialogRoute = RestorableRouteFuture<String>(
      onPresent: (navigator, arguments) {
        return navigator.restorablePush(_alertDialogDemoRoute);
      },
      onComplete: _showInSnackBar,
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.onSecondary,
      ),
      child: Stack(
        children: [
          _buildTopRoundedContainer(),
          _buildHeader(),
          // _buildNavigationBar(),
          _buildBackButton(context),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      colors: [
                        Color(0xFF3BE2B0),
                        Color(0xFF4095D0),
                        Color(0xFF5986CC),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: MediaQuery.of(context).size.width * 0.85,
                    child: SleekCircularSlider(
                      appearance: CircularSliderAppearance(
                        size: MediaQuery.of(context).size.width * 0.84,
                        customColors: CustomSliderColors(
                          trackColor: const Color(0xFF0D1F29),
                          progressBarColor: Colors.white,
                          dotColor: Colors.black,
                        ),
                        startAngle: 270,
                        angleRange: 360,
                        customWidths: CustomSliderWidths(
                          trackWidth: 36,
                          progressBarWidth: 22,
                          handlerSize: 7,
                        ),
                      ),
                      min: 0,
                      max: 60,
                      initialValue: _start.toDouble(),
                      onChange: (double value) {
                        setState(() {
                          _start = value.round();
                        });
                      },
                      innerWidget: (percentage) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${_start.round()}',
                              style: const TextStyle(
                                fontSize: 120,
                                color: Color(0xfff24FFCC),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              trans.minutes,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 140,
                ),
                GestureDetector(
                  onTap: () {
                    if (_isTimerOn) {
                      _timer.cancel();
                      setState(() {
                        _isTimerOn = false;
                        _start = 5;
                      });
                    } else {
                      _isTimerOn = true;
                      startTimer();
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.65,
                    decoration: BoxDecoration(
                      color: _isTimerOn
                          ? Colors.redAccent
                          : const Color(0xfff24FFCC),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFF0D1F29),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(2, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      _isTimerOn ? trans.endTimer : trans.start,
                      style: TextStyle(
                        fontSize: 24,
                        color: _isTimerOn ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  // child: BoxButton(
                  //   title: _isTimerOn ? 'Stop' : 'Start',
                  //   style: ButtonStyleType.Primary,
                  //   state: ButtonState.Enabled,
                  //   onPressed: () {
                  //     setState(() {
                  //       _isTimerOn = !_isTimerOn;
                  //     });
                  //   },
                  // ),
                ),
              ],
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
        height: 150,
        decoration: BoxDecoration(
          color: theme.colorScheme.onSecondary,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;

    return Positioned(
      left: 0,
      right: 0,
      top: 100,
      child: Text(
        trans.meditate,
        textAlign: TextAlign.center,
        style: h2.copyWith(color: theme.colorScheme.onBackground),
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
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
            width: 24,
            height: 24,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Positioned(
      left: 10,
      top: 70,
      child: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white, size: 25),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Meditate()),
          );
        },
      ),
    );
  }
}
