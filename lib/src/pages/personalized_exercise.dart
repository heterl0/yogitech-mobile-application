import 'package:flutter/material.dart';
import 'package:yogi_application/src/custombar/appbar.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';

class PersonalizedExercisePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(100),
      //   child: ClipRRect(
      //     borderRadius: BorderRadius.only(
      //       bottomLeft: Radius.circular(24.0),
      //       bottomRight: Radius.circular(24.0),
      //     ),
      //     child: AppBar(
      //       automaticallyImplyLeading: false,
      //       backgroundColor: theme.colorScheme.onSecondary,
      //       bottom: PreferredSize(
      //         preferredSize: Size.fromHeight(0),
      //         child: Padding(
      //           padding: const EdgeInsets.only(
      //             bottom: 12.0,
      //             right: 24.0,
      //             left: 24.0,
      //           ),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               IconButton(
      //                 icon: Icon(
      //                   Icons.arrow_back,
      //                   color: theme.colorScheme.onBackground,
      //                 ), // Sử dụng icon "back" có sẵn
      //                 onPressed: () {
      //                   Navigator.pop(context); // Thêm sự kiện quay lại
      //                 },
      //               ),
      //               Text('Your Exercise',
      //                   style:
      //                       h2.copyWith(color: theme.colorScheme.onBackground)),
      //               Opacity(
      //                 opacity: 0.0,
      //                 child: IgnorePointer(
      //                   child: IconButton(
      //                     icon: Image.asset('assets/icons/settings.png'),
      //                     onPressed: () {},
      //                   ),
      //                 ),
      //               ) // Ẩn icon đi
      //             ],
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      appBar: CustomAppBar(title: 'Your Exercise'),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Danh sách đầu tiên
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 15, // Số phần tử trong danh sách đầu tiên
                    itemBuilder: (context, index) {
                      return ListItem(
                        difficulty: 'Beginner',
                        poseName: 'Hip',
                        calories: '100000',
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(),
      floatingActionButton: _buildFloatingActionButton(context), // Thêm nút nổi
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // Định vị nút nổi
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.transparent,
      elevation: 0,
      onPressed: () {
        // Xử lý sự kiện khi nhấn nút
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: gradient, // Áp dụng gradient từ app_colors.dart
        ),
        child: Icon(
          Icons.edit,
          color: active,
          size: 24,
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final String? difficulty;
  final String? poseName;
  final String? calories;

  const ListItem({
    Key? key,
    this.difficulty,
    this.poseName,
    this.calories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      constraints: BoxConstraints(
        minWidth: double.infinity,
        minHeight: 80,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: stroke),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: stroke, // Màu nền của Avatar placeholder
            ),
            // Avatar placeholder có thể được thay thế bằng Image.network hoặc CircleAvatar nếu có URL hình ảnh
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(difficulty ?? 'N/A',
                    style: min_cap.copyWith(color: primary)),
                SizedBox(width: 8),
                Text(poseName ?? 'N/A',
                    style: h3.copyWith(color: theme.colorScheme.onPrimary)),
                Text('Calories: ${calories ?? 'N/A'}',
                    style: min_cap.copyWith(color: text)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
