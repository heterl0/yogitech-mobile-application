import 'dart:developer';
import 'dart:io';

import 'package:YogiTech/utils/model_file.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as image_lib;
import 'package:tflite_flutter/tflite_flutter.dart';

import '../../utils/image_utils.dart';
import '../ai_model.dart';

// ignore: must_be_immutable
class Pose extends AiModel {
  Interpreter? interpreter;

  Pose({this.interpreter}) {
    loadModel();
  }
  final int inputSize = 256;
  final double threshold = 0.8;

  // Default statics
  final defaultStatics = [
    createBufferLoad([1, 195]),
    createBufferLoad([1, 1]),
    createBufferLoad([1, 256, 256, 1]),
    createBufferLoad([1, 64, 64, 39]),
    createBufferLoad([1, 117])
  ];

  @override
  List<Object> get props => [];

  @override
  int get getAddress => interpreter!.address;

  @override
  Interpreter? get getInterpreter => interpreter;

  @override
  Future<void> loadModel() async {
    try {
      final interpreterOptions = InterpreterOptions();

      interpreter ??= await Interpreter.fromAsset(ModelFile.pose,
          options: interpreterOptions);

      final outputTensors = interpreter!.getOutputTensors();

      for (var tensor in outputTensors) {
        outputShapes.add(tensor.shape);
        outputTypes.add(tensor.type);
      }
    } catch (e) {
      log('Error while creating interpreter: $e');
    }
  }

  @override
  dynamic getProcessedImage(inputImage) {
    if (inputImage != null) {
      // Resize the image to 256x256
      image_lib.Image resizedImage = image_lib.copyResize(inputImage,
          width: 256,
          height: 256,
          interpolation: image_lib.Interpolation.linear);
      List<dynamic> output = [];
      List<dynamic> row = [];
      List<dynamic> column = [];
      for (int y = 0; y < resizedImage.height; y++) {
        column = [];
        for (int x = 0; x < resizedImage.width; x++) {
          image_lib.Pixel pixel = resizedImage.getPixel(x, y);
          num r = pixel.r;
          num g = pixel.g;
          num b = pixel.b;

          // column.add([r, g, b]);

          // Normalize each channel to the range [0, 1]
          double normalizedR = r / 255.0;
          double normalizedG = g / 255.0;
          double normalizedB = b / 255.0;

          // This step is illustrative; actual implementation may vary based on how you plan to use the normalized values
          // For example, you might store these in a tensor or another data structure instead of creating a new image
          column.add([normalizedR, normalizedG, normalizedB]);
        }
        row.add(column);
      }
      output.add(row);

      return output;

      // Normalization is not explicitly required if you're working with standard image formats
      // as the pixel values are inherently within the 0-255 range for each channel.
      // However, if you need to adjust the pixel values, you would do it here.

      // Save or use the resized image
    }
    return null;
  }

  @override
  Map<String, dynamic>? predict(image_lib.Image image) {
    if (Platform.isAndroid) {
      image = image_lib.copyRotate(image,
          angle: -90, interpolation: image_lib.Interpolation.linear);
      image = image_lib.flipHorizontal(image);
    }
    final dynamic inputImage = getProcessedImage(image);

    final inputs = <Object>[inputImage!];
    dynamic outputLandmarks = defaultStatics[0];
    dynamic outputIdentity1 = defaultStatics[1];
    dynamic outputIdentity2 = defaultStatics[2];
    dynamic outputIdentity3 = defaultStatics[3];
    dynamic outputIdentity4 = defaultStatics[4];

    final outputs = <int, Object>{
      0: outputLandmarks,
      1: outputIdentity1,
      2: outputIdentity2,
      3: outputIdentity3,
      4: outputIdentity4,
    };

    interpreter!.runForMultipleInputs(inputs, outputs);
    print(outputIdentity1[0][0]);
    // print(outputShapes);
    if (outputIdentity1[0][0] < threshold) {
      return null;
    }

    final landmarkPoints =
        (outputLandmarks[0] as List<double>).reshape([39, 5]);
    final landmarkResults = <Offset>[];

    for (var point in landmarkPoints) {
      landmarkResults.add(Offset(
        point[0] / inputSize * image.width,
        point[1] / inputSize * image.height,
      ));
    }

    return {'point': landmarkResults};
  }
}

List<dynamic> createBufferLoad(List<int> shape) {
  if (shape.length == 2) {
    // Create a 2D buffer with shape [shape[0], shape[1]]
    return List.generate(shape[0], (_) => List.filled(shape[1], 0.0));
  } else if (shape.length == 4) {
    // Create a 4D buffer with shape [shape[0], shape[1], shape[2], shape[3]]
    return List.generate(
        shape[0],
        (_) => List.generate(shape[1],
            (_) => List.generate(shape[2], (_) => List.filled(shape[3], 0.0))));
  }
  return [];
}

Map<String, dynamic>? runPoseEstimator(Map<String, dynamic> params) {
  final pose =
      Pose(interpreter: Interpreter.fromAddress(params['detectorAddress']));

  final image = ImageUtils.convertCameraImage(params['cameraImage']);
  final result = pose.predict(image!);

  return result;
}
