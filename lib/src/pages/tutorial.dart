import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Tutorial extends StatefulWidget {
  const Tutorial({super.key});

  @override
  State<Tutorial> createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  late VideoPlayerController _videoPlayerController;
  bool _showSkipButton = true; // Initially show the skip button

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.asset('assets/video/vi_Tutorial.mp4')
          ..initialize().then((_) {
            _videoPlayerController
              ..play()
              ..addListener(() {
                if (_videoPlayerController.value.position >=
                    _videoPlayerController.value.duration) {
                  // Video finished playing, hide the skip button
                  setState(() {
                    _showSkipButton = false;
                  });
                }
              });
          });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _videoPlayerController.value.isInitialized
            ? Stack(
                alignment: Alignment.bottomRight,
                children: [
                  AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerController),
                  ),
                  if (_showSkipButton) // Conditionally show the skip button
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Skip the video
                          _videoPlayerController.pause();
                          Navigator.of(context).pop(); // Navigate back
                        },
                        child: const Text("Skip"),
                      ),
                    ),
                ],
              )
            : const CircularProgressIndicator(), // Show loading while initializing
      ),
    );
  }
}
