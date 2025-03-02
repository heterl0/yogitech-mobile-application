import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:YogiTech/shared/app_colors.dart';
import 'package:YogiTech/shared/styles.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String? caption;
  final String? subtitle;
  final String? imageUrl;
  final VoidCallback? onTap; // Thêm thuộc tính onTap
  final Widget? topRightIcon; // Thêm thuộc tính topRightIcon
  final bool? premium;

  const CustomCard({
    super.key,
    required this.title,
    this.caption,
    this.subtitle,
    this.imageUrl,
    this.onTap, // Thêm thuộc tính onTap vào constructor
    this.topRightIcon,
    this.premium = false, // Thêm thuộc tính topRightIcon vào constructor
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap, // Gọi callback khi thẻ được nhấn
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(8),
            constraints: const BoxConstraints(
              maxWidth: 160, // Kích thước tối thiểu ngang
              minWidth: 152, // Kích thước tối thiểu ngang
              minHeight: 120, // Kích thước tối thiểu dọc
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface, // Màu nền của Container
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [], // Không có bóng đổ
              border: Border.all(color: stroke),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (imageUrl != null)
                  Padding(
                    padding: EdgeInsets.only(top: 8, right: 8, left: 8),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl ?? '',
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Image.asset(
                          premium == true
                              ? 'assets/images/Null_Exercise2.png'
                              : 'assets/images/Null_Exercise.png',
                          fit: BoxFit.cover,
                          height: 90, // Fixed height
                          width: double
                              .infinity, // Ensure the image occupies the full width
                        ),
                        fit: BoxFit.cover,
                        height: 90, // Fixed height
                        width: double
                            .infinity, // Ensure the image occupies the full width
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title.endsWith('\n')
                            ? '$title\n'
                            : '$title\n', // Thêm một dòng trống nếu cần
                        style: bd_text.copyWith(
                            color: theme.colorScheme.onPrimary),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: min_cap.copyWith(
                              color: premium == false ? primary : primary2),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (caption != null)
                        Text(
                          caption!,
                          style: min_cap.copyWith(color: text),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (topRightIcon != null)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface, // Màu nền
                  borderRadius: BorderRadius.all(Radius.circular(8)), // Bo góc
                  border: Border.all(color: stroke),
                ),
                child: Padding(
                  padding: EdgeInsets.all(4),
                  child: topRightIcon,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
