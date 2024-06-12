import 'package:flutter/material.dart';
import 'package:yogi_application/src/custombar/appbar.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';
import 'package:yogi_application/src/widgets/dropdown_field.dart'; // Import DropdownField

class FilterPage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final TextEditingController category = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: CustomAppBar(
        showBackButton: false,
        title: 'Filter',
        postActions: [
          IconButton(
            icon: Icon(Icons.close, color: theme.colorScheme.onBackground),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Category',
                  style: h3.copyWith(color: theme.colorScheme.onPrimary)),
              SizedBox(height: 8.0),
              CustomDropdownFormField(
                // Sử dụng CustomDropdownFormField
                controller: category,
                placeholder: "Choose category",
                items: ['Hip', 'Chest', 'Other'],
                onTap: () {
                  // Tùy chỉnh hành động khi dropdown được nhấn, nếu cần thiết
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        buttonTitle: "Apply",
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
