import 'package:flutter/material.dart';
import 'package:yogi_application/src/shared/app_colors.dart'; // Giả sử bạn đã có tệp này
import 'package:yogi_application/src/shared/styles.dart'; // Giả sử bạn đã có tệp này

class CustomCard extends StatelessWidget {
  final String title;
  final String? caption;
  final String? subtitle;
  final String? imageUrl;

  const CustomCard({
    Key? key,
    required this.title,
    this.caption,
    this.subtitle,
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.all(8),
      constraints: BoxConstraints(
        maxWidth: 150, // Kích thước tối thiểu ngang
        minWidth: 150, // Kích thước tối thiểu ngang
        minHeight: 120, // Kích thước tối thiểu dọc
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.background, // Màu nền của Container
        borderRadius: BorderRadius.circular(16),
        boxShadow: [], // Không có bóng đổ
        border: Border.all(color: text),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                height: 90, // Chiều cao cố định của ảnh
                width: double.infinity, // Đảm bảo ảnh chiếm toàn bộ chiều ngang
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: bd_text.copyWith(color: theme.colorScheme.onPrimary),
                ),
                if (caption != null && subtitle != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        caption!,
                        style: min_cap.copyWith(color: text),
                      ),
                      Text(
                        subtitle!,
                        style: min_cap.copyWith(color: primary),
                      ),
                    ],
                  ),
                if (caption != null && subtitle == null)
                  Text(
                    caption!,
                    style: min_cap.copyWith(color: text),
                  ),
                if (subtitle != null && caption == null)
                  Text(
                    subtitle!,
                    style: min_cap.copyWith(color: primary),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
