YogiTech - Ứng dụng hướng dẫn Yoga bằng AI

Giới thiệu

YogiTech là một ứng dụng di động hỗ trợ người dùng tập Yoga bằng cách nhận diện cử chỉ và cung cấp hướng dẫn luyện tập chính xác. Ứng dụng này sử dụng công nghệ AI kết hợp với các tính năng như video hướng dẫn, theo dõi tiến trình, nhắc nhở lịch tập, và nhiều tiện ích khác.

🌟 Tính năng nổi bật

Hướng dẫn Yoga thông minh: Nhận diện cử chỉ và hỗ trợ luyện tập chính xác.

Đăng nhập và xác thực: Hỗ trợ đăng nhập bằng Google, Facebook, và Email.

Giao diện trực quan: Thiết kế đơn giản, dễ sử dụng.

Nhắc nhở luyện tập: Hệ thống thông báo giúp bạn duy trì lịch tập đều đặn.

Lưu trữ dữ liệu cá nhân: Theo dõi tiến trình tập luyện.

Hỗ trợ đa ngôn ngữ: Tiếng Việt & Tiếng Anh.

📌 Yêu cầu hệ thống

Flutter SDK (phiên bản >= 3.3.4)

Dart SDK (phiên bản >= 3.3)

Android minSdkVersion: 26

🔗 Hướng dẫn cài đặt Flutter: Tại đây🎥 Hướng dẫn cài đặt và kết nối máy ảo Android Studio: Xem video

📥 Cài đặt & chạy dự án

1️⃣ Clone dự án từ GitHub

git clone <repository-link>
cd YogiTech

2️⃣ Cài đặt dependencies

flutter clean
flutter pub get

3️⃣ Tạo splash screen

flutter pub run flutter_native_splash:create

4️⃣ Chạy ứng dụng trên thiết bị ảo hoặc thật

flutter run

📌 Lưu ý: Nếu gặp lỗi localization, chạy lệnh sau:

flutter gen-l10n

Hoặc chỉ cần lưu file pubspec.yaml để cập nhật lại.

📦 Build ứng dụng

1️⃣ Build file APK (release)

flutter build apk --release

👉 File APK nằm tại: build/app/outputs/flutter-apk/app-release.apk

2️⃣ Build file AAB (dùng để upload lên Google Play)

flutter build appbundle

👉 File AAB nằm tại: build/app/outputs/bundle/release/app-release.aab

3️⃣ Tăng version trước khi build bản mới

Mở pubspec.yaml và chỉnh sửa:

version: 1.0.1+2

1.0.1: Phiên bản hiển thị

+2: Version Code (phải lớn hơn lần trước)

Sau đó build lại bằng:

flutter build appbundle

📜 Công nghệ sử dụng

Flutter (Dart) - Framework chính

Provider - Quản lý trạng thái

Dio, HTTP - Gọi API

Google Sign-In - Xác thực đăng nhập

Flutter Local Notifications - Hệ thống thông báo

Google Mobile Ads - Quảng cáo

Image Picker, Camera - Xử lý hình ảnh

WorkManager - Lập lịch tác vụ nền

Rive - Hiệu ứng splash screen

💡 Đóng góp & Liên hệ

Nếu bạn muốn đóng góp vào dự án hoặc gặp bất kỳ vấn đề gì, vui lòng liên hệ:
📧 Email: your.email@example.com💬 Facebook: Fanpage YogiTech

🌟 Cảm ơn bạn đã quan tâm đến YogiTech! Chúc bạn luyện tập Yoga hiệu quả! 🧘‍♂️✨
