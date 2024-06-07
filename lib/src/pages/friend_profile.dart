import 'package:flutter/material.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';
import 'package:yogi_application/src/pages/friendlist.dart';
import 'package:yogi_application/src/pages/personalized_exercise.dart';
import 'package:yogi_application/src/pages/profile.dart';
import 'package:yogi_application/src/pages/settings.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/widgets/box_button.dart';

class FriendProfile extends StatefulWidget {
  const FriendProfile({super.key});

  @override
  State<FriendProfile> createState() => _nameState();
}

class _nameState extends State<FriendProfile> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24.0),
            bottomRight: Radius.circular(24.0),
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: theme.colorScheme.onSecondary,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 12.0,
                  right: 20.0,
                  left: 20.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Spacer(),
                    Text('Friend Profile', style: h2.copyWith(color: active)),
                    Spacer(
                      flex: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(24.0),
        child: Column(
          children: [
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
                      'Duy',
                      style: h2.copyWith(color: theme.colorScheme.onPrimary),
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
                        style: min_cap,
                      ),
                      Text(
                        '999',
                        style: h1.copyWith(color: primary),
                      ),
                      SizedBox(height: 36), // Khoảng cách giữa các phần tử
                      Row(
                        children: [
                          Expanded(
                            child: BoxButton(
                              title: 'Following', // Set the button text
                              style: ButtonStyleType
                                  .Secondary, // Set the button style (optional)
                              onPressed: () {
                                // Handle change avatar action here
                              },
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
      bottomNavigationBar: CustomBottomBar(),
    );
  }
}
