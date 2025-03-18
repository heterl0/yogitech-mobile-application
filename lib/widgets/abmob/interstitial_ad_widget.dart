import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class InterstitialAdWidget {
  late InterstitialAd _interstitialAd;
  bool _isAdLoaded = false;
  final _adUnitId = dotenv.env['INTERSTITIAL_AD'];
  // Getter
  bool get isAdLoaded => _isAdLoaded;

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId:
          //'ca-app-pub-3940256099942544/1033173712', // thay id that vao
          '$_adUnitId',
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isAdLoaded = true;
        },
        onAdFailedToLoad: (error) {
          print('Failed to load interstitial ad: $error');
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (_isAdLoaded) {
      _interstitialAd.show();
    } else {
      print('Interstitial ad not loaded yet');
    }
  }

  void dispose() {
    _interstitialAd.dispose();
  }
}
