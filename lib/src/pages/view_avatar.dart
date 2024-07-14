import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AvatarViewPage extends StatelessWidget {
  final String avatarUrl;
  final Uint8List? imageBytes;

  const AvatarViewPage({
    Key? key,
    required this.avatarUrl,
    this.imageBytes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
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
