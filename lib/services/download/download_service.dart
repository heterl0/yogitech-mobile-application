import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DownloadService {
  /// Hàm yêu cầu quyền truy cập bộ nhớ
  static Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      print("✅ Quyền storage đã được cấp!");
      return true;
    } else {
      print("🚫 Quyền storage bị từ chối!");
      return false;
    }
  }

  /// Hàm tải file từ URL về máy
  static Future<String> downloadFile(String url, String fileName) async {
    bool hasPermission = await requestStoragePermission();
    if (!hasPermission) return url;

    final directory = await getApplicationSupportDirectory();
    final filePath = '${directory.path}/$fileName';
    print(filePath);
    if (await File(filePath).exists()) {
      print("📂 File đã tồn tại: $filePath");
      return filePath;
    }

    try {
      Dio dio = Dio();
      await dio.download(url, filePath);
      print("✅ Tải file thành công: $filePath");
      print("📂 File được lưu tại: $filePath");

      return filePath;
    } catch (e) {
      print("❌ Lỗi tải file: $e");
      return url;
    }
  }

  /// Hàm tải trước (preload) các file media
  static Future<void> preloadAssets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstRun = prefs.getBool('first_run') ?? true;

    if (isFirstRun) {
      print("🔄 Đang tải assets...");
      await downloadFile(
          'https://storage.zenaiyoga.com/assets/audios/rain.mp3', 'rain.mp3');
      await downloadFile(
          'https://storage.zenaiyoga.com/assets/audios/wave.mp3', 'wave.mp3');
      await downloadFile(
          'https://storage.zenaiyoga.com/assets/audios/morning.mp3',
          'morning.mp3');
      await downloadFile('https://storage.zenaiyoga.com/res/raw/vi_tutorial.mp4',
          'vi_tutorial.mp4');
      prefs.setBool('first_run', false);
      print("✅ Tải assets thành công!");
    } else {
      print("📂 Assets đã có sẵn, không cần tải lại!");
    }
  }
}
