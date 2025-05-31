import 'package:ZenAiYoga/views/_mainscreen.dart';
import 'package:ZenAiYoga/shared/app_colors.dart';
import 'package:ZenAiYoga/shared/styles.dart';
import 'package:ZenAiYoga/widgets/box_button.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  // final VoidCallback onComplete;

  // OnboardingScreen({required this.onComplete});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations trans = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: 5,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return buildPage(
                    color: theme.colorScheme.surface, // Màu tím yoga
                    title: trans.onboarding_title_1,
                    text: trans.onboarding_text_1,
                    imageAsset: 'assets/onboarding/onboarding1.png',
                  );
                case 1:
                  return buildPage(
                    color:
                        theme.colorScheme.surface, // Màu xanh lá cây tươi mát
                    title: trans.onboarding_title_2,
                    text: trans.onboarding_text_2,
                    imageAsset: 'assets/onboarding/onboarding2.png',
                  );
                case 2:
                  return buildPage(
                    color: theme.colorScheme.surface, // Màu cam năng động
                    title: trans.onboarding_title_3,
                    text: trans.onboarding_text_3,
                    imageAsset: 'assets/onboarding/onboarding3.png',
                  );
                case 3:
                  return buildPage(
                    color:
                        theme.colorScheme.surface, // Màu xanh dương nhẹ nhàng
                    title: trans.onboarding_title_4,
                    text: trans.onboarding_text_4,
                    imageAsset: 'assets/onboarding/onboarding4.png',
                  );
                case 4:
                  return buildPage(
                    color: theme.colorScheme.surface, // Màu hồng đậm
                    title: trans.onboarding_title_5,
                    text: trans.onboarding_text_5,
                    imageAsset: 'assets/onboarding/onboarding5.png',
                  );
                default:
                  return Container();
              }
            },
          ),
          Positioned(
            bottom: 20.0,
            left: 20.0,
            right: 20.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: 5,
                  effect: WormEffect(
                    dotHeight: 12,
                    dotWidth: 12,
                    spacing: 16,
                    dotColor: stroke,
                    activeDotColor:
                        theme.colorScheme.onPrimary, // Màu chấm active trắng
                  ),
                ),
                SizedBox(height: 16),
                CustomButton(
                  title: _currentPage == 4 ? trans.start : trans.next,
                  style: _currentPage == 4
                      ? ButtonStyleType.Primary
                      : ButtonStyleType.Secondary,
                  onPressed: () {
                    if (_currentPage == 4) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainScreen(
                            isDarkMode: false,
                            onThemeChanged: (bool value) {},
                            locale: Locale('en'),
                            onLanguageChanged: (bool value) {},
                            isVietnamese: false,
                          ),
                        ),
                      );
                    } else {
                      _controller.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
                SizedBox(height: 36),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPage({
    required Color color,
    required String title,
    required String text,
    required String imageAsset,
  }) {
    final theme = Theme.of(context);
    return Container(
      color: color,
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imageAsset, height: 240),
          SizedBox(height: 30),
          Text(
            title,
            style: h2.copyWith(color: theme.colorScheme.onPrimary, height: 1.2),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            text,
            style: bd_text.copyWith(color: theme.colorScheme.onSurface),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
