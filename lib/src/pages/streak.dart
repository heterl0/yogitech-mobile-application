import 'package:flutter/material.dart';
import 'package:yogi_application/src/custombar/appbar.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/shared/styles.dart';

class Streak extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: "Streak",
        showBackButton: false,
        postActions: [
          IconButton(
            icon: Icon(Icons.close, color: theme.colorScheme.onBackground),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: _buildMainContent(context),
      bottomNavigationBar: CustomBottomBar(),
    );
  }

  // Widget _buildBody(BuildContext context) {
  //   return Container(
  //     width: double.infinity,
  //     height: double.infinity,
  //     child: Stack(
  //       children: [
  //         // _buildTopRoundedContainer(),
  //         // _buildTitleText(context),
  //         Positioned.fill(
  //           child: SingleChildScrollView(
  //             child: _buildMainContent(),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildTopRoundedContainer() {
  //   return Positioned(
  //     left: 0,
  //     top: 0,
  //     right: 0,
  //     child: Container(
  //       height: 150,
  //       decoration: BoxDecoration(
  //         color: Color(0xFF0D1F29),
  //         shape: BoxShape.rectangle,
  //         borderRadius: BorderRadius.only(
  //           bottomLeft: Radius.circular(24),
  //           bottomRight: Radius.circular(24),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildTitleText(BuildContext context) {
  //   return Stack(
  //     children: <Widget>[
  //       Positioned(
  //         left: 0,
  //         right: 0,
  //         top: 100,
  //         child: Text(
  //           'Streak',
  //           textAlign: TextAlign.center,
  //           style: TextStyle(
  //             color: Colors.white,
  //             fontSize: 26,
  //             fontFamily: 'Readex Pro',
  //             fontWeight: FontWeight.w800,
  //             height: 1.2,
  //           ),
  //         ),
  //       ),
  //       Positioned(
  //         right: 15,
  //         top: 92,
  //         child: _buildCloseButton(context),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildCloseButton(BuildContext context) {
  //   return IconButton(
  //     icon: Image.asset(
  //       'assets/icons/close.png',
  //       color: Colors.white.withOpacity(1),
  //       width: 30,
  //       height: 30,
  //     ),
  //     onPressed: () {
  //       Navigator.pop(context);
  //     },
  //   );
  // }

  Widget _buildMainContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildStreakInfo(),
                SizedBox(height: 16),
                _buildMonthInfo(context),
                SizedBox(height: 16),
                _buildAdditionalInfo(context),
                SizedBox(height: 16),
                _buildPlaceholder(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: _buildStreakText(),
        ),
        Expanded(
          flex: 1,
          child: _buildStreakImage(),
        )
      ],
    );
  }

  Widget _buildStreakText() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) {
            return gradient.createShader(bounds);
          },
          child: const Text(
            "256",
            style: TextStyle(
              color: active,
              fontSize: 60,
              fontFamily: 'ReadexPro',
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ),
        Text(
          'day streak!',
          textAlign: TextAlign.center,
          style: bd_text.copyWith(color: text),
        ),
      ],
    );
  }

  Widget _buildStreakImage() {
    return Container(
      width: 96,
      height: 96,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/Fire.png'),
        ),
      ),
    );
  }

  Widget _buildMonthInfo(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'May 2024',
            style: h2.copyWith(color: theme.colorScheme.onBackground),
          ),
          Row(
            children: [
              _buildMonthControlBack(),
              _buildMonthControlForward(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthControlBack() {
    return IconButton(
      icon: Icon(
        Icons.chevron_left,
        size: 36,
        color: stroke,
      ),
      onPressed: () {},
    );
    // return Container(
    //   width: 27,
    //   height: 27,
    //   decoration: BoxDecoration(
    //     image: DecorationImage(
    //       image: AssetImage('assets/icons/arrow_back_ios.png'),
    //     ),
    //   ),
    // );
  }

  Widget _buildMonthControlForward() {
    // return Container(
    //   width: 27,
    //   height: 27,
    //   decoration: BoxDecoration(
    //     image: DecorationImage(
    //       image: AssetImage('assets/icons/arrow_forward_ios.png'),
    //     ),
    //   ),
    // );
    return IconButton(
      icon: Icon(
        Icons.chevron_right,
        size: 36,
        color: stroke,
      ),
      onPressed: () {},
    );
  }

  Widget _buildAdditionalInfo(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '30 days',
                    style: h3.copyWith(color: active, height: 1.2),
                  ),
                  Text(
                    'practiced in month',
                    style: min_cap.copyWith(
                      color: active,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 16), // Khoảng cách giữa hai Container
        Expanded(
          child: Container(
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: stroke,
                )),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Feb 14',
                    style: h3.copyWith(
                        color: theme.colorScheme.onPrimary, height: 1.2),
                  ),
                  Text(
                    'begin of the streak',
                    style: min_cap.copyWith(
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: double.infinity,
        height: 280,
        decoration: BoxDecoration(color: Color(0xFF8D8E99)),
        child: Column(
            // Add children widgets here
            ),
      ),
    );
  }
}

// Widget _buildNavigationBar() {
//   return Container(
//     height: 100,
//     child: Stack(
//       children: [
//         Container(
//           height: 100,
//           decoration: BoxDecoration(
//             color: Color(0xFF0D1F29),
//             shape: BoxShape.rectangle,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(24),
//               topRight: Radius.circular(24),
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 0.0),
//           child: Container(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildNavItem(
//                   label: 'Home',
//                   icon: 'assets/icons/grid_view.png',
//                   isSelected: true,
//                 ),
//                 _buildNavItem(
//                   label: 'Blog',
//                   icon: 'assets/icons/newsmode.png',
//                   isSelected: false,
//                 ),
//                 _buildNavItem(
//                   label: 'Activities',
//                   icon: 'assets/icons/exercise.png',
//                   isSelected: false,
//                 ),
//                 _buildNavItem(
//                   label: 'Meditate',
//                   icon: 'assets/icons/self_improvement.png',
//                   isSelected: false,
//                 ),
//                 _buildNavItem(
//                   label: 'Profile',
//                   icon: 'assets/icons/account_circle.png',
//                   isSelected: false,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Widget _buildNavItem({
//   required String label,
//   required String icon,
//   required bool isSelected,
// }) {
//   return GestureDetector(
//     onTap: () {
//       print('Navigated to $label');
//     },
//     child: Column(
//       children: [
//         Image.asset(
//           icon,
//           color: isSelected ? Color(0xFF4094CF) : Color(0xFF8D8E99),
//           width: 24,
//           height: 24,
//         ),
//         const SizedBox(height: 8),
//         Text(
//           label,
//           style: TextStyle(
//             color: isSelected ? Color(0xFF4094CF) : Color(0xFF8D8E99),
//             fontSize: 10,
//             fontFamily: 'Readex Pro',
//             fontWeight: FontWeight.w400,
//             height: 1.2,
//           ),
//         ),
//       ],
//     ),
//   );
// }
