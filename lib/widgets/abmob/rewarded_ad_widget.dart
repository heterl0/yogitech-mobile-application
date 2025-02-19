// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// class RewardedAdWidget {
//   late RewardedAd _rewardedAd;
//   bool _isAdLoaded = false;

//   // Khởi tạo quảng cáo Rewarded
//   void loadRewardedAd() {
//     RewardedAd.load(
//       adUnitId:
//           'ca-app-pub-3940256099942544/5224354917', // Thay bằng Ad Unit ID của bạn
//       request: AdRequest(),
//       rewardedAdLoadCallback: RewardedAdLoadCallback(
//         onAdLoaded: (ad) {
//           _rewardedAd = ad;
//           _isAdLoaded = true;
//         },
//         onAdFailedToLoad: (error) {
//           print('Failed to load rewarded ad: $error');
//         },
//       ),
//     );
//   }

//   // Hiển thị quảng cáo Rewarded
//   void showRewardedAd(BuildContext context) {
//     if (_isAdLoaded) {
//       _rewardedAd.show(
//         onUserEarnedReward: (ad, reward) {
//           // Xử lý phần thưởng sau khi người dùng xem quảng cáo
//           print('User earned reward: ${reward.amount} ${reward.type}');
//         },
//       );
//     } else {
//       print('Rewarded ad not loaded yet');
//     }
//   }

//   // Giải phóng tài nguyên khi không còn cần thiết
//   void dispose() {
//     _rewardedAd.dispose();
//   }
// }
