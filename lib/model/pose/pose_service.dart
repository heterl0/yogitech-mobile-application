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
    dynamic outputLandmarks = createBufferLoad(outputShapes[0]);
    dynamic outputIdentity1 = createBufferLoad(outputShapes[1]);
    dynamic outputIdentity2 = createBufferLoad(outputShapes[2]);
    dynamic outputIdentity3 = createBufferLoad(outputShapes[3]);
    dynamic outputIdentity4 = createBufferLoad(outputShapes[4]);

    final outputs = <int, Object>{
      0: outputLandmarks,
      1: outputIdentity1,
      2: outputIdentity2,
      3: outputIdentity3,
      4: outputIdentity4,
    };
    interpreter!.runForMultipleInputs(inputs, outputs);

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

dynamic createBufferLoad(List<int> shape) {
  if (shape.length == 2) {
    List<dynamic> buffer = [];
    for (var i = 0; i < shape[0]; i++) {
      List<dynamic> row = List.filled(shape[1], 0.0);
      buffer.add(row);
    }
    return buffer;
  }
  if (shape.length == 4) {
    List<dynamic> buffer = [];
    for (var i = 0; i < shape[0]; i++) {
      List<dynamic> row = [];
      for (var j = 0; j < shape[1]; j++) {
        List<dynamic> column = [];
        for (var k = 0; k < shape[2]; k++) {
          List<dynamic> depth = List.filled(shape[3], 0.0);
          column.add(depth);
        }
        row.add(column);
      }
      buffer.add(row);
    }
    return buffer;
  }
  return null;
}

// @override
// dynamic getProcessedImage(image_lib.Image inputImage) {
//   // final imageProcessor = ImageProcessorBuilder()
//   //     .add(ResizeOp(inputSize, inputSize, ResizeMethod.BILINEAR))
//   //     .add(NormalizeOp(0, 255))
//   //     .build();

//   // inputImage = imageProcessor.process(inputImage);
//   return inputImage;
// }

// @override
// Map<String, dynamic>? predict(image_lib.Image image) {
//   if (interpreter == null) {
//     return null;
//   }

//   // if (Platform.isAndroid) {
//   //   image = image_lib.copyRotate(image, -90);
//   //   image = image_lib.flipHorizontal(image);
//   // }
//   // final tensorImage = TensorImage(TfLiteType.float32);
//   // tensorImage.loadImage(image);
//   // final inputImage = getProcessedImage(tensorImage);

//   // TensorBuffer outputLandmarks = TensorBufferFloat(outputShapes[0]);
//   // TensorBuffer outputIdentity1 = TensorBufferFloat(outputShapes[1]);
//   // TensorBuffer outputIdentity2 = TensorBufferFloat(outputShapes[2]);
//   // TensorBuffer outputIdentity3 = TensorBufferFloat(outputShapes[3]);
//   // TensorBuffer outputIdentity4 = TensorBufferFloat(outputShapes[4]);

//   final inputs = <Object>[image.buffer];

//   final outputs = <int, Object>{
//     0: outputLandmarks.buffer,
//     1: outputIdentity1.buffer,
//     2: outputIdentity2.buffer,
//     3: outputIdentity3.buffer,
//     4: outputIdentity4.buffer,
//   };

//   interpreter!.runForMultipleInputs(inputs);

//   if (outputIdentity1.getDoubleValue(0) < threshold) {
//     return null;
//   }

//   final landmarkPoints = outputLandmarks.getDoubleList().reshape([39, 5]);
//   final landmarkResults = <Offset>[];

//   for (var point in landmarkPoints) {
//     landmarkResults.add(Offset(
//       point[0] / inputSize * image.width,
//       point[1] / inputSize * image.height,
//     ));
//   }

//   return {'point': landmarkResults};
// }

Map<String, dynamic>? runPoseEstimator(Map<String, dynamic> params) {
  final pose =
      Pose(interpreter: Interpreter.fromAddress(params['detectorAddress']));

  final image = ImageUtils.convertCameraImage(params['cameraImage']);
  final result = pose.predict(image!);

  return result;
}
