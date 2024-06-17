import 'package:flutter/material.dart';
import 'package:yogi_application/src/custombar/appbar.dart';
import 'package:yogi_application/src/services/api_service.dart';
import 'package:yogi_application/src/widgets/box_input_field.dart';
import 'package:yogi_application/src/widgets/card.dart';
import 'package:yogi_application/src/pages/blog_detail.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Blog extends StatefulWidget {
  const Blog({super.key});

  @override
  BlogState createState() => BlogState();

  static fromJson(item) {}

  static fromMap(x) {}

  toMap() {}
}

class BlogState extends State<Blog> {
  late Future<Blog> blogs;
  bool _isNotSearching = true;
  TextEditingController _searchController = TextEditingController();
  List<Blog> _blogs = [];

  @override
  void initState() {
    super.initState();
    _fetchBlogs(); // Gọi hàm fetchBlogs khi trạng thái của widget được khởi tạo
  }

  Future<void> _fetchBlogs() async {
    ApiService apiService = ApiService();
    try {
      // List<Blog> blogs =
      //     await apiService.fetchBlogs(); // Gọi hàm fetchBlogs từ service
      setState(() {
        // _blogs = blogs;
      });
    } catch (e) {
      print('Error fetching blogs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: _isNotSearching
          ? CustomAppBar(
              showBackButton: false,
              title: trans.blog,
              postActions: [
                IconButton(
                  icon:
                      Icon(Icons.search, color: theme.colorScheme.onBackground),
                  onPressed: () {
                    setState(() {
                      _isNotSearching = false;
                    });
                  },
                ),
              ],
            )
          : CustomAppBar(
              onBackPressed: () {
                setState(() {
                  _isNotSearching = true;
                });
              },
              style: widthStyle.Large,
              titleWidget: BoxInputField(
                controller: _searchController,
                placeholder: trans.search,
                trailing: const Icon(Icons.search),
                keyboardType: TextInputType.text,
                inputFormatters: [],
                onTap: () {},
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
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(color: theme.colorScheme.background),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildBlogMainContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildBlogMainContent() {
    final trans = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 24.0, left: 24.0, right: 24.0),
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 3 / 2,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          final title = 'title';
          final caption = 'Caption';
          final subtitle = '${6 - index} ${trans.daysLeft}';

          return CustomCard(
            title: title,
            caption: caption,
            subtitle: subtitle,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlogDetail(
                    title: title,
                    caption: caption,
                    subtitle: subtitle,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
