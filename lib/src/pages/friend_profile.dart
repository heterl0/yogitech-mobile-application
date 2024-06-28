import 'package:YogiTech/src/models/account.dart';
import 'package:YogiTech/src/models/social.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:YogiTech/src/custombar/appbar.dart';
import 'package:YogiTech/src/shared/app_colors.dart';
import 'package:YogiTech/src/shared/styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FriendProfile extends StatefulWidget {
  final int? id;
  final SocialProfile profile;
  final Account? account;
  final void Function(int id)? unFollow;
  final void Function(int id)? followUserByUserId;

  FriendProfile(
      {Key? key,
      this.id,
      required this.profile,
      this.account,
      this.unFollow,
      this.followUserByUserId})
      : super(key: key);

  @override
  State<FriendProfile> createState() => _nameState();
}

class _nameState extends State<FriendProfile> {
  bool isFollow = false; // Khai báo biến ở đây

  @override
  void initState() {
    super.initState();
    setState(() {
      isFollow = widget.account!.isFollowing(widget.profile.user_id ?? -1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    final name = widget.profile.first_name != null
        ? '${widget.profile.first_name} ${widget.profile.last_name}'
        : widget.profile.username ?? 'User Name';

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
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
                name,
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
                      child: CircleAvatar(
                        radius: 78,
                        backgroundImage: widget.profile.avatar != null
                            ? CachedNetworkImageProvider(widget.profile.avatar ?? "")
                                as ImageProvider
                            : AssetImage('assets/images/gradient.jpg'),
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
                        widget.profile.exp.toString(),
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
                                    color: isFollow ? error : primary,
                                    width: 2.0),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    if (isFollow) {
                                      widget.unFollow!(
                                          widget.profile.user_id ?? -1);
                                    } else {
                                      widget.followUserByUserId!(
                                          widget.profile.user_id ?? -1);
                                    }
                                    setState(() {
                                      isFollow =
                                          !isFollow; // Thay đổi trạng thái
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(44.0),
                                  child: Center(
                                    child: Text(
                                        isFollow
                                            ? trans.unfollow
                                            : trans.follow,
                                        style: h3.copyWith(
                                            color: isFollow ? error : primary)),
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

  const BoxButton({
    super.key,
    required this.title,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.padding,
    required this.textStyle,
    required this.shape,
    required this.onPressed,
    this.borderColor,
    required style, // Add this line
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
