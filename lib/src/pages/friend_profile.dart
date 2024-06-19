import 'package:flutter/material.dart';
import 'package:yogi_application/src/custombar/appbar.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FriendProfile extends StatefulWidget {
  const FriendProfile({super.key});

  @override
  State<FriendProfile> createState() => _nameState();
}

class _nameState extends State<FriendProfile> {
  bool follow = true; // Khai báo biến ở đây

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: CustomAppBar(
        title: trans.friendProfile,
        style: widthStyle.Large,
      ),
      body: Container(
        margin: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            ShaderMask(
              shaderCallback: (bounds) {
                return gradient.createShader(bounds);
              },
              child: Text(
                'Name',
                style: h2.copyWith(color: active),
              ),
            ),

            Row(
              children: [
                Column(
                  children: [
                    Container(
                      width: 144, // 2 * radius + 8 (border width) * 2
                      height:
                          144, // Đã sửa lại thành 144 cho khớp tỉ lệ so với Figma
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        radius: 78,
                        backgroundImage: AssetImage('assets/images/avatar.png'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Avatar',
                      style: bd_text.copyWith(color: text),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'EXP',
                        style: min_cap.copyWith(color: text, height: 1),
                      ),
                      Text(
                        '999',
                        style: h1.copyWith(color: primary, height: 1),
                      ),
                      SizedBox(height: 36), // Khoảng cách giữa các phần tử
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 50.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(44.0),
                                border: Border.all(
                                    color: follow ? error : primary,
                                    width: 2.0),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    // Xử lý sự kiện khi nhấn vào nút
                                    setState(() {
                                      follow = !follow; // Thay đổi trạng thái
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(44.0),
                                  child: Center(
                                    child: Text(
                                        follow ? trans.unfollow : trans.follow,
                                        style: h3.copyWith(
                                            color: follow ? error : primary)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(0.0),
                    height: 160,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF8D8E99)),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0), // Added space for better layout
          ],
        ),
      ),
    );
  }
}

class BoxButton extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Color foregroundColor;
  final EdgeInsets padding;
  final TextStyle textStyle;
  final ShapeBorder shape;
  final VoidCallback onPressed;
  final Color? borderColor; // Add this line

  BoxButton({
    required this.title,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.padding,
    required this.textStyle,
    required this.shape,
    required this.onPressed,
    this.borderColor, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    // Modify shape to include borderColor if provided
    final buttonShape = borderColor != null
        ? RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: borderColor!),
          )
        : shape;

    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(backgroundColor),
        foregroundColor: MaterialStateProperty.all(foregroundColor),
        padding: MaterialStateProperty.all(padding),
        textStyle: MaterialStateProperty.all(textStyle),
        shape: MaterialStateProperty.all(buttonShape as OutlinedBorder?),
      ),
      onPressed: onPressed,
      child: Text(title),
    );
  }
}
