import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdWidget {
  late InterstitialAd _interstitialAd;
  bool _isAdLoaded = false;

  // Getter công khai để kiểm tra trạng thái quảng cáo
  bool get isAdLoaded => _isAdLoaded;

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId:
          'ca-app-pub-3940256099942544/1033173712', // Thay bằng Ad Unit ID thật
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
