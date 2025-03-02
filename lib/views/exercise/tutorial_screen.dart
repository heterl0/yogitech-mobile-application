import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Tutorial extends StatefulWidget {
  const Tutorial({super.key});

  @override
  State<Tutorial> createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  late VideoPlayerController _videoPlayerController;
  bool _showSkipButton = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    final locale = AppLocalizations.of(context)?.localeName ?? 'vi';
    print('Ngôn ngữ là: $locale');
    // String videoAssetPath = 'assets/video/$locale\_Tutorial.mp4';
    String videoUrl =
        'https://storage.yogitech.me/res/raw/$locale\_tutorial.mp4';

    // _videoPlayerController = VideoPlayerController.asset(videoAssetPath)
    _videoPlayerController = VideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        setState(() {
          _videoPlayerController!.play(); // Lưu ý dấu ! để chắc chắn không null
        });

        _videoPlayerController!.addListener(() {
          // Lưu ý dấu !
          if (_videoPlayerController!.value.position >=
              _videoPlayerController!.value.duration) {
            setState(() {
              _showSkipButton = false;
            });
          }
        });
      }).catchError((error) {
        print('Lỗi khi khởi tạo video: $error');
        // Xử lý lỗi (ví dụ: hiển thị thông báo lỗi cho người dùng)
      });
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose(); // Kiểm tra null trước khi dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      // Bọc Scaffold bằng OrientationBuilder
      builder: (context, orientation) {
        // Khóa xoay màn hình theo hướng hiện tại
        if (orientation == Orientation.portrait) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
        } else {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
        }

        return Scaffold(
          body: Center(
            child: _videoPlayerController.value.isInitialized
                ? Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      AspectRatio(
                        aspectRatio: _videoPlayerController.value.aspectRatio,
                        child: RotatedBox(
                          quarterTurns: orientation == Orientation.landscape
                              ? 1
                              : 0, // Xoay 90 độ nếu ở chế độ ngang
                          child: VideoPlayer(_videoPlayerController),
                        ),
                      ),
                      if (_showSkipButton)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              _videoPlayerController.pause();
                              Navigator.of(context).pop();
                            },
                            child: const Text("Bỏ qua"),
                          ),
                        ),
                    ],
                  )
                : const CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
