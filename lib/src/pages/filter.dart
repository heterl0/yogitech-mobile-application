import 'package:flutter/material.dart';
import 'package:yogi_application/src/custombar/appbar.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';
import 'package:yogi_application/src/widgets/dropdown_field.dart'; // Import DropdownField
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class FilterPage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final TextEditingController category = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: CustomAppBar(
        showBackButton: false,
        title: trans.filter,
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
              Text(trans.category,
                  style: h3.copyWith(color: theme.colorScheme.onPrimary)),
              SizedBox(height: 8.0),
              CustomDropdownFormField(
                // Sử dụng CustomDropdownFormField
                controller: category,
                placeholder:trans.choosecCategory,
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
        buttonTitle: trans.apply,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
