import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  @override
  _BannerAdWidgetState createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  late BannerAd _bannerAd;
  final _adUnitId = dotenv.env['BANNER_ADD'];
  bool _isBannerAdLoaded = false;
  @override
  void initState() {
    super.initState();
    _initializeBannerAd();
  }

  // Khởi tạo Banner Ad
  void _initializeBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: '$_adUnitId', // Thay bằng Ad Unit ID của bạn
      // 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          print('Failed to load banner ad: $error');
        },
      ),
    );
    _bannerAd.load();
  }

  @override
  void dispose() {
    _bannerAd.dispose(); // Giải phóng tài nguyên khi widget bị hủy
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isBannerAdLoaded
        ? Container(
            alignment: Alignment.center,
            child: AdWidget(ad: _bannerAd),
            width: _bannerAd.size.width.toDouble(),
            height: _bannerAd.size.height.toDouble(),
          )
        : SizedBox.shrink(); // Nếu chưa tải được quảng cáo, không hiển thị gì
  }
}
