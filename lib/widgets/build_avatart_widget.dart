import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AvatarWidget extends StatelessWidget {
  final String? avatarUrl;
  final Uint8List? imageBytes;
  final String? username;
  final VoidCallback? onTap;

  const AvatarWidget({
    super.key,
    this.avatarUrl,
    this.imageBytes,
    this.username,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const double avatarSize = 144;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: avatarSize,
        height: avatarSize,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Center(
          child: imageBytes == null
              ? (avatarUrl != null
                  ? CircleAvatar(
                      radius: avatarSize,
                      backgroundImage: CachedNetworkImageProvider(avatarUrl!),
                      backgroundColor: Colors.transparent,
                    )
                  : Center(
                      child: Container(
                        width: avatarSize,
                        height: avatarSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                          border: Border.all(
                            color: Colors.blue, // Chỉnh màu viền nếu cần
                            width: 3.0,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            username != null && username!.isNotEmpty
                                ? username![0].toUpperCase()
                                : '',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ))
              : CircleAvatar(
                  radius: 50,
                  backgroundImage: MemoryImage(imageBytes!),
                  backgroundColor: Colors.transparent,
                ),
        ),
      ),
    );
  }
}
