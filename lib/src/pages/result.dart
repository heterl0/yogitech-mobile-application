import 'package:flutter/material.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/widgets/box_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class Result extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _buildResult(), // Wrap _buildResult() with Center widget
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
    final trans = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
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
            trans.accuracy+' 90%',
            textAlign: TextAlign.center,
            style: h2.copyWith(color: primary),
          ),
          const SizedBox(height: 12),
          Text(
            '+ 300 EXP',
            style: h3.copyWith(color: theme.colorScheme.onBackground),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '+',
                style: h3.copyWith(color: theme.colorScheme.onBackground),
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
                style: h3.copyWith(color: theme.colorScheme.onBackground),
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
                  trans.caloriesBurned+' 9000',
                  style:
                      bd_text.copyWith(color: theme.colorScheme.onBackground),
                ),
                const SizedBox(height: 4),
                Text(
                  trans.duration+': '+"20"+trans.minutes+"70"+trans.seconds,
                  style:
                      bd_text.copyWith(color: theme.colorScheme.onBackground),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24), // Adjust spacing
          BoxButton(
            title: trans.finish,
            style: ButtonStyleType.Primary,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
