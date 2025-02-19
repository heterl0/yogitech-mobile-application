import 'package:YogiTech/models/exercise.dart';
import 'package:flutter/material.dart';
import 'package:YogiTech/shared/app_colors.dart';
import 'package:YogiTech/shared/styles.dart';
import 'package:YogiTech/widgets/box_button.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../widgets/abmob/interstitial_ad_widget.dart';

class Result extends StatelessWidget {
  final ExerciseResult? exerciseResult;
  final InterstitialAdWidget interstitialAdWidget = InterstitialAdWidget();

  Result({super.key, this.exerciseResult}) {
    interstitialAdWidget.loadInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _buildResult(),
      ),
    );
  }

  Widget _buildResult() {
    return ResultAfterPractice(
      exerciseResult: exerciseResult,
      interstitialAdWidget: interstitialAdWidget, // Truyền vào đây
    );
  }
}

class ResultAfterPractice extends StatelessWidget {
  final ExerciseResult? exerciseResult;
  final InterstitialAdWidget interstitialAdWidget; // Nhận từ Result
  const ResultAfterPractice(
      {super.key, this.exerciseResult, required this.interstitialAdWidget});

  @override
  Widget build(BuildContext context) {
    final trans = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final minite = exerciseResult!.totalTimeFinish ~/ 60;
    final second = exerciseResult!.totalTimeFinish % 60;
    return Container(
      width: 360,
      padding: const EdgeInsets.symmetric(
          horizontal: 20, vertical: 40), // Adjust padding
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            trans.goodJob,
            textAlign: TextAlign.center,
            style: h1.copyWith(color: theme.colorScheme.onPrimary),
          ),
          const SizedBox(height: 12),
          SizedBox(
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
            '${trans.accuracy} ${exerciseResult!.result} %',
            textAlign: TextAlign.center,
            style: h2.copyWith(color: primary),
          ),
          const SizedBox(height: 12),
          Text(
            '+ ${exerciseResult!.exp} EXP',
            style: h3.copyWith(color: theme.colorScheme.onSurface),
          ),
          const SizedBox(height: 12),
          exerciseResult!.point > 0
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '+',
                      style: h3.copyWith(color: theme.colorScheme.onSurface),
                    ),
                    const SizedBox(width: 4),
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: Image.asset(
                        'assets/images/Emerald.png',
                      ),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      exerciseResult!.point.toString(),
                      style: h3.copyWith(color: theme.colorScheme.onSurface),
                    ),
                  ],
                )
              : Container(),
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
                  '${trans.caloriesBurned} ${exerciseResult!.calories} kcal',
                  style: bd_text.copyWith(color: theme.colorScheme.onSurface),
                ),
                const SizedBox(height: 4),
                minite == 0
                    ? Text(
                        trans.duration +
                            ': ' +
                            second.toString() +
                            " " +
                            trans.seconds,
                        style: bd_text.copyWith(
                            color: theme.colorScheme.onSurface),
                      )
                    : Text(
                        trans.duration +
                            ': ' +
                            minite.toString() +
                            " " +
                            trans.minutes +
                            second.toString() +
                            " " +
                            trans.seconds,
                        style: bd_text.copyWith(
                            color: theme.colorScheme.onSurface),
                      ),
              ],
            ),
          ),
          const SizedBox(height: 24), // Adjust spacing
          CustomButton(
            title: trans.finish,
            style: ButtonStyleType.Primary,
            onPressed: () {
              // if (interstitialAdWidget.isAdLoaded) {
              //   interstitialAdWidget.showInterstitialAd();
              //   Future.delayed(Duration(seconds: 1), () {
              //     Navigator.pop(context);
              //   });
              // } else {
              Navigator.pop(context);
              // }
            },
          ),
        ],
      ),
    );
  }
}
