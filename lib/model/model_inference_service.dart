import 'dart:isolate';
import 'package:YogiTech/model/pose/pose_service.dart';
import 'package:camera/camera.dart';

import '../utils/isolate_utils.dart';
import 'ai_model.dart';
import 'service_locator.dart';

enum Models {
  pose,
}

class ModelInferenceService {
  late AiModel model = locator<Pose>();
  late Function handler = runPoseEstimator;
  Map<String, dynamic>? inferenceResults;

  Future<void> inference({
    required IsolateUtils isolateUtils,
    required CameraImage cameraImage,
  }) async {
    final responsePort = ReceivePort();

    isolateUtils.sendMessage(
      handler: handler,
      params: {
        'cameraImage': cameraImage,
        'detectorAddress': model.getAddress,
      },
      sendPort: isolateUtils.sendPort,
      responsePort: responsePort,
    );

    inferenceResults = await responsePort.first;
    responsePort.close();
  }
}
