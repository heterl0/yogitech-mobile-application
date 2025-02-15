import 'package:YogiTech/shared/app_colors.dart';
import 'package:YogiTech/shared/styles.dart';
import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;
  final bool isTitleFirst;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.valueColor,
    this.isTitleFirst = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.0), // Bo góc cho InkWell
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(16.0), // Bo góc cho Container (tùy chọn)
        ),
        child: Row(
          children: isTitleFirst
              ? [
                  Text(
                    title,
                    style: min_cap.copyWith(color: text),
                  ),
                  const SizedBox(width: 10),
                  Text(value, style: h2.copyWith(color: valueColor)),
                ]
              : [
                  Text(value, style: h2.copyWith(color: valueColor)),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: min_cap.copyWith(color: text),
                  ),
                ],
        ),
      ),
    );
  }
}
