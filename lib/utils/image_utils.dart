import 'package:camera/camera.dart';
import 'package:image/image.dart' as image_lib;

/// ImageUtils
class ImageUtils {
  /// Converts a [CameraImage] in YUV420 format to [Image] in RGB format
  static image_lib.Image? convertCameraImage(CameraImage cameraImage) {
    if (cameraImage.format.group == ImageFormatGroup.yuv420) {
      return convertYUV420ToImage(cameraImage);
    } else if (cameraImage.format.group == ImageFormatGroup.bgra8888) {
      return convertBGRA8888ToImage(cameraImage);
    } else {
      return null;
    }
  }

  /// Converts a [CameraImage] in BGRA888 format to [Image] in RGB format
  static image_lib.Image convertBGRA8888ToImage(CameraImage cameraImage) {
    var img = image_lib.Image.fromBytes(
      width: cameraImage.planes[0].width!,
      height: cameraImage.planes[0].height!,
      bytes: cameraImage.planes[0].bytes.buffer,
    );
    return img;
  }

  /// Converts a [CameraImage] in YUV420 format to [Image] in RGB format
  static image_lib.Image convertYUV420ToImage(CameraImage cameraImage) {
    final width = cameraImage.width;
    final height = cameraImage.height;

    final uvRowStride = cameraImage.planes[1].bytesPerRow;
    final uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

    final image = image_lib.Image(width: width, height: height);

    for (var w = 0; w < width; w++) {
      for (var h = 0; h < height; h++) {
        final uvIndex =
            uvPixelStride * (w / 2).floor() + uvRowStride * (h / 2).floor();
        final index = h * width + w;

        final y = cameraImage.planes[0].bytes[index];
        final u = cameraImage.planes[1].bytes[uvIndex];
        final v = cameraImage.planes[2].bytes[uvIndex];
        if (image.data != null) {
          final value = ImageUtils.yuv2rgb(y, u, v);
          image.data?.setPixelRgb(w, h, value['r'], value['g'], value['b']);
        }
      }
    }
    return image;
  }

  /// Convert a single YUV pixel to RGB
  static dynamic yuv2rgb(int y, int u, int v) {
    // Convert yuv pixel to rgb
    var r = (y + v * 1436 / 1024 - 179).round();
    var g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
    var b = (y + u * 1814 / 1024 - 227).round();

    // Clipping RGB values to be inside boundaries [ 0 , 255 ]
    r = r.clamp(0, 255);
    g = g.clamp(0, 255);
    b = b.clamp(0, 255);

    // return 0xff000000 |
    //     ((b << 16) & 0xff0000) |
    //     ((g << 8) & 0xff00) |
    //     (r & 0xff);
    return {"r": r, "g": g, "b": b};
  }
}

// class TensorImage {
//   image_lib.Image image;

//   TensorImage(this.image);

//   Uint8List get bytes => image.getBytes();

//   void set bytes(Uint8List bytes) {
//     image = image_lib.Image.fromBytes(
//         width: image.width, height: image.height, bytes: bytes.buffer);
//   }
// }

// class ImageProcessor {
//   final int inputSize;

//   ImageProcessor(this.inputSize);

//   TensorImage process(TensorImage inputImage) {
//     // Resize the image
//     image_lib.Image resizedImage = image_lib.copyResize(inputImage.image,
//         width: inputSize, height: inputSize);

//     // Normalize the image
//     Uint8List normalizedBytes = Uint8List(resizedImage.length);
//     for (int i = 0; i < resizedImage.length; i++) {
//       normalizedBytes[i] = (resizedImage.getBytes()[i] / 255.0).toInt();
//     }

//     TensorImage outputImage = TensorImage(resizedImage);
//     outputImage.bytes = normalizedBytes;

//     return outputImage;
//   }
// }
