import 'dart:typed_data';
import 'package:ZenAiYoga/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AvatarViewPage extends StatelessWidget {
  final String avatarUrl;
  final Uint8List? imageBytes;

  const AvatarViewPage({
    super.key,
    required this.avatarUrl,
    this.imageBytes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: active),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          scaleEnabled: true,
          minScale: 0.1,
          maxScale: 4.0,
          child: imageBytes != null
              ? Image.memory(imageBytes!)
              : CachedNetworkImage(
                  imageUrl: avatarUrl,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
        ),
      ),
    );
  }
}
