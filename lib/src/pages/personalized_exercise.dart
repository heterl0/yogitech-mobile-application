import 'package:flutter/material.dart';
import 'package:yogi_application/src/custombar/appbar.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';
import 'package:yogi_application/src/widgets/box_input_field.dart';

class PersonalizedExercisePage extends StatefulWidget {
  @override
  _PersonalizedExercisePageState createState() =>
      _PersonalizedExercisePageState();
}

class _PersonalizedExercisePageState extends State<PersonalizedExercisePage> {
  bool _isNotSearching = true;
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: _isNotSearching
          ? CustomAppBar(title: 'Your Exercise')
          : CustomAppBar(
              showBackButton: false,
              largeTitle: true,
              titleWidget: BoxInputField(
                controller: _searchController,
                placeholder: 'Search...',
                trailing: Icon(Icons.search),
                keyboardType: TextInputType.text,
                inputFormatters: [],
                onTap: () {
                  // Xử lý khi input field được nhấn
                },
              ),
              postActions: [
                IconButton(
                  icon:
                      Icon(Icons.close, color: theme.colorScheme.onBackground),
                  onPressed: () {
                    setState(() {
                      _isNotSearching = true;
                    });
                  },
                ),
              ],
            ),
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
                      return const ListItem(
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Ink(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: gradient, // Gradient từ app_colors.dart
        ),
        width: 60,
        height: 60,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () {
            setState(() {
              _isNotSearching = false;
            });
          },
          child: const Icon(
            Icons.edit,
            color: active,
            size: 24,
          ),
        ),
      ),
      onPressed: () {}, // Cái này nhấn không có tác dụng
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
